'''
---------------------------
    runserver.py 
---------------------------                         
Created on 24.04.2015
Last modified on 24.04.2015
Author: Marc Wieland
----
'''
from webapp import app, db

db.create_all()
app.run(debug=True)
