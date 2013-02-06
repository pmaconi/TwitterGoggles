import argparse, collections, configparser, json, math, mysql.connector as sql, requests, sys, time
from datetime import datetime
from mysql.connector import errorcode
from requests import HTTPError
from requests import ConnectionError
from requests_oauthlib import OAuth1

# Print strings in verbose mode
def verbose(info) :
	if args.verbose:
		print(info)

# Connect to MySQL using config entries
def connect() :
	config = configparser.ConfigParser()
	config.read("config/settings.cfg")

	db_params = {
		'user' : config["MySQL"]["user"],
		'password' : config["MySQL"]["password"],
		'host' : config["MySQL"]["host"],
		'port' : int(config["MySQL"]["port"]),
		'database' : config["MySQL"]['database'],
		'charset' : 'utf8'
	}

	return sql.connect(**db_params)

# Get all jobs from the database
def getJobs(conn) :
	cursor = conn.cursor() 

	query = ("SELECT job_id, zombie_head, state, query, since_id_str, description, \
				consumer_key, consumer_secret, access_token, access_token_secret \
			FROM job, oauth \
			WHERE job.oauth_id = oauth.oauth_id AND zombie_head = %s \
			ORDER BY job_id")

	cursor.execute(query,[args.head])
	return cursor

# Append default values to the job's query string
def getFullQuery(query, since_id) :
	return "?" + query + "&since_id=" + since_id + "&count=100&include_entities=1"

# Query Twitter's Search 1.1 API
def search(query, oauth) :
	verbose("Query: " + query)

	attempt = 1
	while attempt <= 3 :
		try :
			r = requests.get("https://api.twitter.com/1.1/search/tweets.json" + query, auth=oauth)
			return json.loads(r.text)

		except (ConnectionError, HTTPError) as err :
			sleep_time = 2**(attempt - 1)
			verbose("Connection attempt " + str(attempt) + " failed. "
				"Sleeping for " + str(sleep_time) + " second(s).")
			time.sleep(sleep_time)
			attempt = attempt + 1

	print("***** Error: Unable to query Twitter. Terminating.")
	sys.exit(1)

# Add a tweet to the DB
def addTweet(conn, job_id, tweet) :
	cursor = conn.cursor()

	prefix = "INSERT INTO tweet (tweet_id_str, job_id, created_at, text, from_user, from_user_id_str, " \
		"from_user_name, to_user, to_user_id_str, to_user_name, source, iso_language"
	suffix = ") VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s"
	values = [
		tweet["id_str"],
		job_id,
		datetime.strptime(tweet["created_at"], '%a %b %d %H:%M:%S +0000 %Y').strftime('%Y-%m-%d %H:%M:%S'),
		tweet["text"],
		tweet["user"]["id"],
		tweet["user"]["id_str"],
		tweet["user"]["screen_name"],
		tweet["in_reply_to_user_id"],
		tweet["in_reply_to_user_id_str"],
		tweet["in_reply_to_screen_name"],
		tweet["source"],
		tweet["metadata"]["iso_language_code"]
	]

	# Optionally include the geo data
	if tweet['geo'] is not None and tweet['geo']['type'] == "Point" :		
		prefix = prefix + ", location_geo, location_geo_0, location_geo_1"
		suffix = suffix + ", Point(%s,%s), %s, %s"
		values.extend([
			tweet["geo"]["coordinates"][0],
			tweet["geo"]["coordinates"][1],
			tweet["geo"]["coordinates"][0],
			tweet["geo"]["coordinates"][1]
		])

	suffix = suffix + ")"
	query = (prefix + suffix)
	
	try :
		cursor.execute(query, values)
		conn.commit()
		return True
	except sql.Error as err :
		verbose(">>>> Warning: Could not add Tweet: " + str(err))
		# Convert unprintable utf8 strings to ascii bytes and decode back to a string
		verbose("     Query: " + cursor.statement.encode("ascii", "ignore").decode())
		return False
	finally :
		cursor.close()

# Add hashtag entities to the DB
def addHashtags(conn, job_id, tweet) :
	cursor = conn.cursor()

	query = "INSERT INTO hashtag (tweet_id, job_id, text, index_start, index_end) " \
		"VALUES(%s, %s, %s, %s, %s)"

	for hashtag in tweet['entities']['hashtags'] :
		values = [
			tweet["id_str"], 
			job_id, 
			hashtag["text"], 
			hashtag["indices"][0],
			hashtag["indices"][1] 
		]

		try :
			cursor.execute(query, values)
			conn.commit()
		except sql.Error as err :
			verbose(">>>> Warning: Could not add Hashtag: " + str(err))
			# Convert unprintable utf8 strings to ascii bytes and decode back to a string
			verbose("     Query: " + cursor.statement.encode("ascii", "ignore").decode())
	
	cursor.close()

# Add user mention entities to the DB
def addUserMentions(conn, job_id, tweet) :
	cursor = conn.cursor()

	query = "INSERT INTO mention (tweet_id, job_id, screen_name, name, id_str, index_start, index_end) " \
		"VALUES(%s, %s, %s, %s, %s, %s, %s)"

	for mention in tweet['entities']['user_mentions'] :
		values = [
			tweet["id_str"], 
			job_id, 
			mention["screen_name"], 
			mention["name"], 
			mention["id_str"], 
			mention["indices"][0],
			mention["indices"][1] 
		]

		try :
			cursor.execute(query, values)
			conn.commit()
		except sql.Error as err :
			verbose(">>>> Warning: Could not add User Mention: " + str(err))
			# Convert unprintable utf8 strings to ascii bytes and decode back to a string
			verbose("     Query: " + cursor.statement.encode("ascii", "ignore").decode())
	
	cursor.close

# Add all URL entities to the DB
def addURLS(conn, job_id, tweet) :
	cursor = conn.cursor()

	query = "INSERT INTO url (tweet_id, job_id, url, expanded_url, display_url, index_start, index_end) " \
		"VALUES(%s, %s, %s, %s, %s, %s, %s)"

	for url in tweet['entities']['urls'] :
		values = [
			tweet["id_str"], 
			job_id, 
			url["url"], 
			url["expanded_url"] if "expanded_url" in url else "", 
			url["display_url"] if "display_url" in url else "", 
			url["indices"][0],
			url["indices"][1] 
		]

		try :
			cursor.execute(query, values)
			conn.commit()
		except sql.Error as err :
			verbose(">>>> Warning: Could not add URL: " + str(err))
			# Convert unprintable utf8 strings to ascii bytes and decode back to a string
			verbose("     Query: " + cursor.statement.encode("ascii", "ignore").decode())
	
	cursor.close()

# Update the stored job's since_id to prevent retrieving previously processed tweets
def updateSinceId(conn, job_id, max_id_str, total_results) :
	cursor = conn.cursor()

	query = "UPDATE job SET since_id_str=%s, last_count=%s, last_run=%s WHERE job_id=%s"

	values = [
		max_id_str,
		total_results,
		datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
		job_id
	]

	try :
		cursor.execute(query, values)
		conn.commit()
	except sql.Error as err :
		verbose(">>>> Warning: Could not update job: " + str(err))
		# Convert unprintable utf8 strings to ascii bytes and decode back to a string
		verbose("     Query: " + cursor.statement.encode("ascii", "ignore").decode())
	finally:
		cursor.close()

# Main function
if __name__ == '__main__' :
	# Handle command line arguments
	parser = argparse.ArgumentParser(description="A Python adaptation of the PHP program \
				\"Twitter Zombie\", originally developed for the Twitter Search API version \
				1.0. This new project is built for the Twitter Search API version 1.1.")
	parser.add_argument('head', type=int, help="Specify the head #")
	parser.add_argument('-v','--verbose', default=False, action="store_true", help="Show additional logs")
	parser.add_argument('-d','--delay', type=int, default=0, help="Delay execution by DELAY seconds")
	args = parser.parse_args()

	# Display startup info
	print("vvvvv Start:", datetime.now().strftime('%Y-%m-%d %H:%M:%S'))
	verbose("Verbose Mode: Enabled")
	print("Head:", args.head)
	print("Delay:", args.delay)

	epoch_min = math.floor(time.time() / 60)
	verbose("Epoch Minutes: " + str(epoch_min))

	if (args.delay > 0) :
		time.sleep(args.delay)

	print("Connecting to database...")

	try :
		conn = connect()
		print("Connected")

		# Get all of the jobs for this head
		jobs = getJobs(conn)

		# Iterate over all of the jobs found
		run_total_count = 0
		for (job_id, zombie_head, state, query, since_id_str, description, 
				consumer_key, consumer_secret, access_token, access_token_secret) in jobs :
			
			# Throttle the job frequency
			if (epoch_min % state != 0) :
				verbose("Throttled frequency for job: " + str(job_id))
				continue
			
			print("+++++ Job ID:", job_id, "\tDescription:", description, "\tQuery:", query)

			oauth = OAuth1(client_key=consumer_key,
						client_secret=consumer_secret,
						resource_owner_key=access_token,
						resource_owner_secret=access_token_secret)
			
			since_id_str = since_id_str.decode('utf8')

			# Get the Tweets
			results = search(getFullQuery(query, since_id_str), oauth)

			# Make sure that we didn't receive an error instead of an actual result
			if "errors" in results :
				for error in results["errors"] :
					verbose("      Error response received: " + error["message"])

				print("***** Error: Unable to query Twitter. Ending job.")
				continue

			tweets = collections.deque()

			tweets.extend(results["statuses"])

			# Search results are returned in a most-recent first order, so we only need the inital max
			max_id_str =  results["search_metadata"]["max_id_str"]
			total_results = 0
			while tweets :
				total_results = total_results + 1
				tweet = tweets.popleft()

				# Insert the tweet in the DB
				success = addTweet(conn, job_id, tweet)

				# Insert the tweet entities in the DB
				if success :
					addHashtags(conn, job_id, tweet)
					addUserMentions(conn, job_id, tweet)
					addURLS(conn, job_id, tweet)

				# If we have no more tweets to process, but Twitter says there are more to get
				if not tweets and "next_results" in results["search_metadata"] :
					next_results = results["search_metadata"]["next_results"]
					query = next_results + "&since_id=" + since_id_str + "&count=100"
					results = search(query, oauth)

					# Make sure that we didn't receive an error instead of an actual result
					if "errors" in results :
						for error in results["errors"] :
							verbose("      Error response received:" + error["message"])

						print("***** Error: Unable to query Twitter. Ending job.")

						# End this job early, since we've probably hit rate limits
						break

					# Add the newly retrieved tweets to the processing queue
					tweets.extend(results["statuses"])

			print("Total Results:", total_results)
			run_total_count = run_total_count + total_results

			# Update the since_id to use for future tweets
			updateSinceId(conn, job_id, max_id_str, total_results)
					
	except sql.Error as err :
		print(err)
		print("Terminating.")
		sys.exit(1)
	else :
		conn.close()
	finally :
		print("$$$$$ Run total count: " + str(run_total_count))
		print("^^^^^ Stop:", datetime.now().strftime('%Y-%m-%d %H:%M:%S'))