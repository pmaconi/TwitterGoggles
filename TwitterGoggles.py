import argparse, configparser, math, mysql.connector as sql, requests, sys, time
from datetime import datetime
from mysql.connector import errorcode
from requests import HTTPError
from requests import ConnectionError
from requests_oauthlib import OAuth1

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
	full_query = "&".join([query,"since_id=" + since_id, "rpp=100", "include_entities"])
	verbose("Query: " + full_query)

	attempt = 1
	while attempt <= 3 :
		try :
			r = requests.get("https://api.twitter.com/1.1/search/tweets.json?" + full_query, auth=oauth)
			return r.json
			
		except (ConnectionError, HTTPError) as err :
			sleep_time = 2**(attempt - 1)
			verbose("Connection attempt " + str(attempt) + " failed. "
				"Sleeping for " + str(sleep_time) + " second(s).")
			time.sleep(sleep_time)
			attempt = attempt + 1

	print("***** Error: Unable to query Twitter. Terminating.")
	sys.exit(1)

def getOAuth(consumer_key, consumer_secret, access_token, access_token_secret) : 
	oauth = OAuth1(client_key=consumer_key,
				client_secret=consumer_secret,
				resource_owner_key=access_token,
				resource_owner_secret=access_token_secret)

	return oauth

def verbose(info) :
	if args.verbose:
		print(info)

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

			oauth = getOAuth(consumer_key, consumer_secret, access_token, access_token_secret)
			
			search(query, since_id_str.decode('utf8'), oauth)
		#search("test")
	except sql.Error as err :
			print(err)
			print("Terminating.")
			sys.exit(1)
	else :
		conn.close()
	finally :
		print("^^^^^ Stop:", datetime.now().strftime('%Y-%m-%d %H:%M:%S'))