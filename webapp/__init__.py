from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask.ext.login import LoginManager
from flask.ext.security import Security

app = Flask(__name__)
app.config.from_object('rrvs_config')

db = SQLAlchemy(app)

import webapp.views
db.init_app(app)


if __name__== "__main__":
    app.run(host="0.0.0.0")

    @login_manager.user_loader
    def load_user(user_id):
        return User.get(user_id)

