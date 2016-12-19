import sys
import logging
logging.basicConfig(stream=sys.stderr)
sys.path.append("/var/www/html/rrda")

from webapp import app as application,db,babel

from werkzeug.debug import DebuggedApplication 

db.create_all()
#application.secret_key = '42'
application = DebuggedApplication(application, True)
