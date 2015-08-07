
Remote Rapid Visual Screening (RRVS) Tool
=========================================

Contact: Marc Wieland marc.wieland@gfz-potsdam.de
         Michael Haas michael.haas@gfz-potsdam.de


INSTALLATION
------------

In order to run the application locally do the following:

A) Setup virtualenvironment and add the project source code
1. $ sudo pip install virtualenv
2. go to root of project folder and run $ virtualenv venv
   this creates a new folder venv to hold the virtualenvironment
3. run $ venv/bin/activate to start the enviroment ($ deactivate to stop it)
   now you can install python libraries localy in a virtual environment 
   not affecting the host systems python libraries.
4. $ venv/bin/pip install Flask Flask-WTF Flask-SQLAlchemy

B) Setup the database
1. Create a new database 'rrvstool_v01' in PostgreSQL >9.1
   and run rrvstool_db.sql
2. Populate the database tables (you can use the rrvstool_testdata.sql script to add some testdata)

C) Run the flask application on an apache2 server with mod_wsgi
1.Install mod_wsgi for apache2
  $ sudo apt-get install libapach2-mod-wsgi
2. Activate wsgi for apache2
  $ sudo a2enmod wsgi
3. Create a virtual host for the app
  $ sudo touch /etc/apache2/sites-available/rrvs
4.Add following content (to run on Port 8080):

Listen 8080
<VirtualHost *:8080>
        ServerName localhost
        WSGIScriptAlias / /var/www/rrvs/rrvs.wsgi
        <Directory /var/www/rrvs/webapp>
            Order allow,deny
            Allow from all
        </Directory>
        Alias /static /var/www/rrvs/webapp/static
        <Directory /var/www/rrvs/webapp/static/>
            Order allow,deny
            Allow from all
        </Directory>
        ErrorLog ${APACHE_LOG_DIR}/error.log
        LogLevel warn
        CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>

5. Activate the site
  $ sudo a2ensite rrvs

6. Reload apache2
$ sudo service apache2 restart

WARNING: Currently the app is designed as being open to all IP-Addresses!
webapp/__init__.py app.run(host="0.0.0.0")

You can enter the site via localhost:8080


MODIFYING DATAENTRY FORM
------------------------

A short step-by-step guideline on how to add a new QuerySelectField to the dataentry form:

1. models.py: 
#define a new column in the db model
mat_type = db.Column(db.String(254))

2. forms.py: 
#define a new field in the form
mat_type_field = QuerySelectField("Material Type", query_factory=getMatType, get_label='description', allow_blank=True)
			 
#add a new query factory which fills the dropdown menu
def getMatType(): 
	return dic_attribute_value.query.filter_by(attribute_type_code='MAT_TYPE') 

3. rrvsform.html: 
#add the new field to the html template
{{ rrvs_form.mat_type_field.label }}
{{ rrvs_form.mat_type_field }}
			 
#add new return value from .getJSON function
$('select[name="mat_type_field"]').val(data.mat_type_gid);

4. routes.py:
#in update_rrvsform() define the query attribute_value for the select fields
mat_type_val = ve_resolution1.query.filter_by(gid=gid_val).first().mat_type

# and the return gid
mat_type_gid = dic_attribute_value.query.filter_by(attribute_value=mat_type_val).first().gid,

#in rrvsform() add a new entry to the row.update() function to update database with form content
ve_resolution1.mat_type: rrvs_form.mat_type_field.data.attribute_value,
