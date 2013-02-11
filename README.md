TwitterGoggles
==============
A Python 3.3 adaptation of the PHP program "Twitter Zombie", originally developed for the Twitter Search API 
version 1.0. This new project is built for the Twitter Search API version 1.1.

Dependencies
------------
- requests
- requests-oauthlib
- mysql-connector-python

Installation
------------
1. Install Python 3 on the computer you use.  Recognize that many standard installations of Python are currently
   2.x, and you may need to install Python 3 as well.  To execute with Python3, you type "python3"
2. Download the dependencies listed above and unzip them:
    1. Make sure you have "pip" installed on your system (this is a package manager for Python3) 
    2. From a command prompt, type:
```
pip install requests requests-oauthlib mysql-connector-python
```

Usage
-----
```
usage: TwitterGoggles.py [-h] [-v] [-d DELAY] head

positional arguments:
  head                  Specify the head #

optional arguments:
  -h, --help            show this help message and exit
  -v, --verbose         Show additional logs
  -d DELAY, --delay DELAY
                        Delay execution by DELAY seconds
```


