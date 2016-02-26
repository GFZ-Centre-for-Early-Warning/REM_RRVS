'''
---------------------------
    runserver.py
---------------------------
Created on 24.04.2015
Last modified on 12.01.2016
Author: Marc Wieland
Description: Starts the application using a local flask server (NOT RECOMMENDED: use wsgi implementation instead see README.md)
----
'''
from webapp import app, db, models
from flask.ext.login import LoginManager
from flask.ext.security import Security,SQLAlchemyUserDatastore

#create database stuff
db.create_all()

#CHANGE THE SECRET KEY HERE:
app.secret_key = '42'
app.run(debug=True, use_reloader=False)
