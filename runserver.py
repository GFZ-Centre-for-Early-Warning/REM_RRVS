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
from webapp import app, db

db.create_all()
app.run(debug=True)
