from flask import Flask
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:postgres@localhost:5432/rrvstool_v01'
app.config['WTF_CSRF_ENABLED'] = True
app.config['WTF_CSRF_SECRET_KEY'] = 'development key wtf'

db = SQLAlchemy(app)

import webapp.routes
db.init_app(app)

if __name__== "__main__":
    app.run(host="0.0.0.0")
