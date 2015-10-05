'''
---------------------------
    runserver.py
---------------------------
Created on 24.04.2015
Last modified on 24.04.2015
Author: Marc Wieland
Description: Starts the application
----
'''
from webapp import app, db, models
from flask.ext.login import LoginManager
from flask.ext.security import Security,SQLAlchemyUserDatastore


#create database stuff
db.create_all()

#create login_manager
login_manager = LoginManager()
login_manager.init_app(app)
#setup flask security
user_datastore = SQLAlchemyUserDatastore(db,models.User,models.Role)
security = Security(app, user_datastore)

app.secret_key = '42'
app.run(debug=True)
