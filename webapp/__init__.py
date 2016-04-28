from flask import Flask,request,session
from flask_sqlalchemy import SQLAlchemy
from flask.ext.login import LoginManager
from flask.ext.security import Security,SQLAlchemyUserDatastore
from flask.ext.babel import Babel
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

babel = Babel(app)
#app.config['BABEL_DEFAULT_LOCALE'] = 'ar'

#create login_manager
login_manager = LoginManager()
login_manager.init_app(app)
#setup flask security
user_datastore = SQLAlchemyUserDatastore(db, models.User, models.Role)
security = Security(app, user_datastore)

@babel.localeselector
def get_locale():
    lang = request.accept_languages.best_match(['ar','en'])
    session['lang']=lang
    return lang

if __name__== "__main__":

    @login_manager.user_loader
    def load_user(user_id):
        return User.get(int(user_id))
    @babel.localeselector
    def get_locale():
        #return request.accept_languages.best_match(['ar','en'])
       # return 'ar'
        lang = request.accept_languages.best_match(['ar','en'])
        session['lang']=lang
        return lang

    app.run(host="0.0.0.0")
