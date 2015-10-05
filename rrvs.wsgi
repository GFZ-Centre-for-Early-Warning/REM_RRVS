activate_this = '/srv/http/rrvs/venv/bin/activate_this.py'
execfile(activate_this, dict(__file__=activate_this))

import sys
import logging
logging.basicConfig(stream=sys.stderr)
sys.path.append("/srv/http/")
sys.path.append("/srv/http/rrvs/")

from webapp import app as application,db

from werkzeug.debug import DebuggedApplication 

application.secret_key = "development key"
application = DebuggedApplication(application, True)
db.create_all()
