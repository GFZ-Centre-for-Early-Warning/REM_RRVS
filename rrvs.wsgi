import sys
import logging
logging.basicConfig(stream=sys.stderr)
sys.path.append("/var/www/html/rrvs")

from webapp import app as application,db

from werkzeug.debug import DebuggedApplication 

application.secret_key = "development key"
application = DebuggedApplication(application, True)
db.create_all()
