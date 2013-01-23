import configparser
import requests
from requests_oauthlib import OAuth1


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

search("test")
