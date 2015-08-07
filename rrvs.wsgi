#!/usr/bin/python
import sys
import logging
logging.basicConfig(stream=sys.stderr)
sys.path.insert(0,"/var/www/rrvs/")

from webapp import app as application,db

db.create_all()
application.secret_key = "development key"
