import argparse, collections, configparser, json, math, mysql.connector as sql, requests, sys, time
from datetime import datetime
from mysql.connector import errorcode
from requests import HTTPError
from requests import ConnectionError
from requests_oauthlib import OAuth1

def verbose(info) :
	if args.verbose:
		print(info)

def connect() :
	# Connect to MySQL using config entries
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

def getJobs(conn) :
	cursor = conn.cursor() 

	query = ("SELECT job_id, zombie_head, state, query, since_id_str, description, \
				consumer_key, consumer_secret, access_token, access_token_secret \
			FROM job, oauth \
			WHERE job.oauth_id = oauth.oauth_id AND zombie_head = %s \
			ORDER BY job_id")

	cursor.execute(query,[args.head])
	return cursor

def search(query, since_id, oauth) :
	full_query = "&".join([query,"since_id=" + since_id, "rpp=100", "include_entities=1"])
	verbose("Query: " + full_query)

	attempt = 1
	while attempt <= 3 :
		try :
			r = requests.get("https://api.twitter.com/1.1/search/tweets.json?" + full_query, auth=oauth)
			return json.loads(r.text)

		except (ConnectionError, HTTPError) as err :
			sleep_time = 2**(attempt - 1)
			verbose("Connection attempt " + str(attempt) + " failed. "
				"Sleeping for " + str(sleep_time) + " second(s).")
			time.sleep(sleep_time)
			attempt = attempt + 1

	print("***** Error: Unable to query Twitter. Terminating.")
	sys.exit(1)

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

	if tweet['geo'] is not None and tweet['geo']['type'] == "Point" :		
		prefix = prefix + ", location_geo, location_geo_0, location_geo_1"
		suffix = suffix + ", %s, %s, %s"
		values.extend([
			"point(" + tweet["geo"]["coordinates"][0] + "," + tweet["geo"]["coordinates"][1] + ")",
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
		# Convert unprintable utf8 string to ascii bytes and decode to string
		verbose("     Query: " + cursor.statement.encode("ascii", "ignore").decode())
		return False
	finally :
		cursor.close()

if __name__ == '__main__' :
	# Handle command line arguments
	parser = argparse.ArgumentParser(description="A Python adaptation of the PHP program \
				\"Twitter Zombie\", originally developed for the Twitter Search API version \
				1.0. This new project is built for the Twitter Search API version 1.1.")
	parser.add_argument('head', type=int, help="Specify the head")
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
		for (job_id, zombie_head, state, query, since_id_str, description, 
				consumer_key, consumer_secret, access_token, access_token_secret) in jobs :
			
			# Throttle the job frequency
			#if (epoch_min % state != 0) :
			#	verbose("Throttled frequency for job: " + job_id)
			#	continue
			
			print("+++++ Job ID:", job_id, "\tDescription:", description, "\tQuery:", query)

			oauth = OAuth1(client_key=consumer_key,
						client_secret=consumer_secret,
						resource_owner_key=access_token,
						resource_owner_secret=access_token_secret)
			
			# Get the Tweets
			results = search(query, since_id_str.decode('utf8'), oauth)

			total_results = results["search_metadata"]["count"]
			max_id = results["search_metadata"]["max_id"]
			verbose("Max ID: " + str(max_id))

			tweets = collections.deque()
			tweets.extend(results["statuses"])

			while tweets :
				tweet = tweets.popleft()

				success = addTweet(conn, job_id, tweet)


	except sql.Error as err :
		print(err)
		print("Terminating.")
		sys.exit(1)
	else :
		conn.close()
	finally :
		print("^^^^^ Stop:", datetime.now().strftime('%Y-%m-%d %H:%M:%S'))