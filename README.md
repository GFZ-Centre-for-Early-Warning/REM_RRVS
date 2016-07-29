
#Remote Rapid Visual Screening (RRVS) Tool

Contact: Marc Wieland marc.wieland@gfz-potsdam.de 
         Michael Haas michael.haas@gfz-potsdam.de

##Structure
The main application is in the folder webapp. In the root directory are the
scripts for running the application (rrvs.wsgi/runserver.py and rrvs_config.py).
In scripts are some useful scripts for the application (creation of the database,
populating the database and creating tasks).

##Installation

The installation as described here for Ubuntu 14.04, but should be similar on other linux distributions.
In order to run the application locally do the following:

###A) Setup the project source code
We recommend using a virtual python environment, but you can also skip step 2-4.
1. Get a copy of the source code git clone https://github.com/GFZ-Centre-for-Early-Warning/REM_RRVS
2. $ sudo pip install virtualenv
3. go to root of project folder (usally the webfolder e.g. "/var/www/rrvs") and run $ virtualenv venv 
   this creates a new folder venv to hold the virtualenvironment
4. run $ venv/bin/activate to start the enviroment ($ deactivate to stop it)  
   now you can install python libraries localy in a virtual environment 
   not affecting the host systems python libraries.
5. sudo apt-get install redis (used for server-side caching)
6. Use $pip install -r python-requirements.txt 
7. Adjust the rrvs_config.py.example and save it as rrvs_config.py

###B) Setup the database
For production:
1. Create and connect to a database e.g. called rem on the server (or adjust the name accordingly in the rrvs_config.py)
2. run the templating script for a rem database from within the database (https://github.com/GFZ-Centre-for-Early-Warning/REM_DBschema)
3. run the extend_rem_db.sql script to extend the schema for the rrvs functionality
**THE ORDER FOR THE FOLLOWING MATTERS!**
4. populate the database with image and survey information (metadata.sql files as created with PERManEnt makalu.gfz-potsdam.de:/media/EWC/git/permanent.git)
5. populate the database with assets (building footprints) by using fp2rem_db.py and importing the resulting sql file fp2rem.sql
6. create users in the users schema of the database see e.g. Users.sql
7. create tasks for the analysis, there is an R-script for doing so based on a stratification available as a shapefile (rrvsTask.R)

For demo:
1. Create a new database 'rrvstool_db' in PostgreSQL >9.1 
   and run rrvstool_db.sql
2. Populate the database tables (you can use the rrvstool_testdata.sql script to add some testdata)

###C) OPTIONAL BUT RECOMMENDED: Run the application on an apache2 server with mod_wsgi
1.Install mod_wsgi for apache2 
   ```
   sudo apt-get install libapache2-mod-wsgi
   ```
2. Activate wsgi for apache2 
   ```
   sudo a2enmod wsgi
   ```
3. Create a virtual host for the app 
   ```
   sudo touch /etc/apache2/sites-available/rrvs
   ```
4.Add following content (e.g. to run on Port 8080 if you want to keep 80 free):

   ```
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
   ```

5. Activate the site  
   ```
   sudo a2ensite rrvs
   ```

6. Panoramic images are served to the app on a virtual directory called /pano which can be a different place 
   than document root, you'll have to write an Alias in the alias_module part of the apache httpd.conf 
   (add it to the virtual host you created above in Point 4):

   ```
    Alias /pano /path/to/your/directory  
    <Directory /path/to/your/directory/> 
    Options Indexes FollowSymLinks MultiViews 
        Require all granted 
    </Directory> 
   ```

Make sure the permissions for this directory (and all it's parents) are set to 755:
   ```
   chmod 755 /path
   chmod 755 /path/to 
   ...
   ```

The directory can also have it's own index.html
Make sure that in your database image.img.repository is the path to the images relative to /path/to/your/directory.
If for example your images are at /path/to/your/directory/survey image.img.repository would be '/survey'.

7. Reload apache2 
   ```
   sudo service apache2 restart
   ```

**WARNING:** 
1. Currently the app is designed as being open to all IP-Addresses!(webapp/__init__.py app.run(host="0.0.0.0"))
2. The default secret key is very weak change it to something more complex! (runserver.py or rrvs_config.py, depending how you run the app)

You can enter the site via the port you defined int the virtual host, e.g. localhost:8080 in a webbrowser

###D) If not implemented as recommended via wsgi you can have to run the application via
   ```
   python runserver.py
   ```

##Modifying the dataentry form

A short step-by-step guideline on how to add a new QuerySelectField to the dataentry form:

1. models.py: 
   define a new column in the db model 
   ```python 
   mat_type = db.Column(db.String(254))
   ```

2. forms.py: 
   define a new field in the form 
   ```python 
   mat_type_field = QuerySelectField("Material Type", query_factory=getMatType, get_label='description', allow_blank=True)
   ```
			 
   add a new query factory which fills the dropdown menu 
   ```python 
   def getMatType(): 
       return dic_attribute_value.query.filter_by(attribute_type_code='MAT_TYPE') 
   ```

3. rrvsform.html: 
   add the new field to the html template 
   ```javascript 
   {{ rrvs_form.mat_type_field.label }} 
   {{ rrvs_form.mat_type_field }}
   ```
			 
   add new return value from .getJSON function
   ```javascript 
   ('select[name="mat_type_field"]').val(data.mat_type_gid);
   ```

4. views.py: 
   in update_rrvsform() define the query attribute_value for the select fields 
   ```python 
   mat_type_val = ve_resolution1.query.filter_by(gid=gid_val).first().mat_type
   ```

   and the return gid
   ```python 
   mat_type_gid = dic_attribute_value.query.filter_by(attribute_value=mat_type_val).first().gid,
   ```

   in rrvsform() add a new entry to the row.update() function to update database with form content
   ```python 
   ve_resolution1.mat_type: rrvs_form.mat_type_field.data.attribute_value,
   ```

##Known issues
1. Each asset in a rem db asset.object_attribute.height_1 has to have an initial value (fp2rem_db.py assigns 99) in order 
   for the application to work properly.
2. Panoramic images are limited in size, if too large they will show up black in the pannellum viewer 
   recommended resolution is: 3500px*1750px
