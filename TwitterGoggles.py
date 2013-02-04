import argparse, configparser, json, math, mysql.connector as sql, requests, sys, time
from datetime import datetime
from mysql.connector import errorcode
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

def search(query) :
	r = requests.get("https://api.twitter.com/1.1/search/tweets.json?q=" + query, auth=getOAuth())
	print(r.text)

def getOAuth() : 
	config = configparser.ConfigParser()
	config.read("config/settings.cfg")

	consumer_key = config["OAuth"]["consumer_key"]
	consumer_secret = config["OAuth"]["consumer_secret"]
	access_token = config["OAuth"]["access_token"]
	access_token_secret = config["OAuth"]["access_token_secret"]

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
	print("vvvvv Start:", datetime.now().strftime('%Y-%m-%d %H:%M:%S'), "vvvvv")
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
		#search("test")
	except sql.Error as err :
			print(err)
			print("Terminating.")
			sys.exit(1)
	else :
		conn.close()
	print("^^^^^ Stop:", datetime.now().strftime('%Y-%m-%d %H:%M:%S'), "^^^^^")