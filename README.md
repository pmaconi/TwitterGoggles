TwitterGoggles
==============
A Python 3 adaptation of the PHP program "Twitter Zombie", originally developed for the Twitter Search API version 1.0. This new project is built for the Twitter Search API version 1.1.

Dependencies
------------
- requests
- requests-oauthlib
- mysql-connector-python

Usage
-----
usage: TwitterGoggles.py [-h] [-v] [-d DELAY] head

positional arguments:
  head                  Specify the head #

optional arguments:
  -h, --help            show this help message and exit
  -v, --verbose         Show additional logs
  -d DELAY, --delay DELAY
                        Delay execution by DELAY seconds

Installation
----------
Install Python 3 on the computer you use.  Recognize that many standard installations of Python are currently 2.x, and you may need to install python 3 as well.  To execute with Python3, you type "python3"

Download the dependencies listed above and unzip them:
   requests - http://pypi.python.org/pypi/requests
   python3 setup.py install 

   requests-oauthlib - http://pypi.python.org/pypi/requests-oauthlib/ or https://github.com/requests/requests-oauthlib
   python3 setup.py install

   mysql-connector-python - http://pypi.python.org/pypi/mysql-connector-python/
   python3 setup.py install



