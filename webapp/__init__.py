from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask.ext.login import LoginManager
from flask.ext.security import Security,SQLAlchemyUserDatastore
from flask_kvsession import KVSessionExtension
import redis
from simplekv.memory.redisstore import RedisStore

store=RedisStore(redis.StrictRedis())

app = Flask(__name__)
app.config.from_object('rrvs_config')
KVSessionExtension(store, app)

db = SQLAlchemy(app)

import webapp.views
db.init_app(app)

#create login_manager
login_manager = LoginManager()
login_manager.init_app(app)
#setup flask security
user_datastore = SQLAlchemyUserDatastore(db, models.User, models.Role)
security = Security(app, user_datastore)

if __name__== "__main__":

    app.run(host="0.0.0.0")

    @login_manager.user_loader
    def load_user(user_id):
        return User.get(int(user_id))
