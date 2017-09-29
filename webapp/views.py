'''
---------------------------
    views.py
---------------------------
Created on 24.04.2015
Last modified on 15.01.2016
Author: Marc Wieland, Michael Haas
Description: The main views file setting up the flask application layout, defining all routes
----
'''
import flask
from webapp import app, db
from models import t_object, object_attribute, ve_object, dic_attribute_value, pan_imgs,gps, User, task, tasks_users
from forms import RrvsForm, LoginForm,RrvsForm_es,RrvsForm_ar
from flask.ext.security import login_required, login_user, logout_user
import geoalchemy2.functions as func
import json
from geojson import Feature, FeatureCollection, dumps
import time


########################################################
# REST interface getting task related buildings as json
########################################################
#@app.route("/bdgs/api/<int:taskid>",methods=["GET"])
#def get_task(taskid):
#    geom = ve_object.query.filter_by(gid=taskid).first().the_geom
#    #geom_json= json.loads(db.session.scalar(geoalchemy2.functions.ST_AsGeoJSON(geom)))
#    geom_json = json.loads(db.session.scalar(func.ST_AsGeoJSON(geom)))
#    geom_json["gid"]=taskid
#    print geom_json
#    return flask.jsonify(geom_json['coordinates'][0])

#def byteify(input):
#    if isinstance(input, dict):
#        return {byteify(key):byteify(value) for key,value in input.iteritems()}
#    elif isinstance(input, list):
#        return [byteify(element) for element in input]
#    elif isinstance(input, unicode):
#        return input.encode('utf-8')
#    else:
#        return input

@app.before_request
def check_login():
    if flask.request.endpoint == 'static' and not flask.current_user.is_authenticated():
        abort(401)
    return None

#######################################
# Login landing page
#######################################
@app.route("/", methods=["GET", "POST"])
def login():
    """For GET requests, display the login form. For POSTS, login the current user
    by processing the form and storing the taskid."""
    msg=''
    form = LoginForm()
    if form.validate_on_submit():
        try:
            user = User.query.get(int(form.userid.data))
        except:
            user = False
        #check if task id belongs to user
        try:
            task_id = tasks_users.query.filter_by(task_id=form.taskid.data).first()
            1/(task_id.user_id==user.id)
        except:
            user = False
        if user:
            user.authenticated = True
            db.session.add(user)
            db.session.commit()
            #log the user in
            login_user(user, remember=True)
            #set up task
            flask.session['taskid']=form.taskid.data
            #get all buildings gids from task and storing in session
            flask.session['bdg_gids'] = task.query.filter_by(id=flask.session['taskid']).first().bdg_gids
            #get all img gids from task and storing in session
            flask.session['img_gids'] = task.query.filter_by(id=flask.session['taskid']).first().img_ids
            #flags for screened buildings
            flask.session['screened'] = [False]*len(flask.session['bdg_gids'])
            #language is set in babel locale in __init__.py
            #get gid's of attribute values as defined in dic_attribute_value as python dictionary
            dic_attribute_val_query=dic_attribute_value.query.all()#.options(load_only("gid","attribute_value"))
            dic_attribute_val_py={}
            for attribute in dic_attribute_val_query:
                dic_attribute_val_py[attribute.attribute_value] = attribute.gid
            flask.session['dic_attribute_val_py']=dic_attribute_val_py
            return flask.redirect(flask.url_for("main"))
        else:
            msg='Wrong combination of UserID and TaskID'
    return flask.render_template("index.htm", form=form,msg=msg)

@app.route("/logout", methods=["GET"])
def logout():
    """Logout the current user."""
    user = current_user
    user.authenticated = False
    db.session.add(user)
    db.session.commit()
    logout_user()
    return flask.render_template("logout.html")

######################################
# Data entry/ Visualization interface
#####################################
@app.route('/main')
@login_required
def main():
    """
    This will render a template that holds the main pagelayout.
    """
    return flask.render_template('main.htm')

@app.route('/map')
@login_required
def map():
    """
	This will render a template that holds the map.
    Displaying buildings with gids contained in taskid
	"""
    #get bdg_gids
    bdg_gids = flask.session['bdg_gids']
    #get FeatureCollection with corresponding building footprints
    rows = object_attribute.query.filter(db.and_(object_attribute.object_id.in_(bdg_gids),object_attribute.attribute_type_code=='RRVS_STATUS')).all()
    bdgs = []
    for row in rows:
        geom = t_object.query.filter_by(gid=row.object_id).first().the_geom
        geometry = json.loads(db.session.scalar(func.ST_AsGeoJSON(geom)))
        feature = Feature(id=row.object_id,geometry=geometry,properties={"gid":row.object_id, "rrvs_status":row.attribute_value})
        bdgs.append(feature)
    bdgs_json = dumps(FeatureCollection(bdgs))
    #get img_gids
    img_gids = flask.session['img_gids']
    #get metadata related to these images
    image_rows = pan_imgs.query.filter(pan_imgs.gid.in_(img_gids)).all()
    gps_ids = [row.gps for row in image_rows]
    gps_rows = gps.query.filter(gps.gid.in_(gps_ids)).all()
    #create a json object
    img_gps = []
    for i,image in enumerate(image_rows):
        geometry = json.loads(db.session.scalar(func.ST_AsGeoJSON(gps_rows[i].the_geom)))
        feature = Feature(id=image.gid,geometry=geometry,properties={"img_id":image.gid,"repository":image.repository,"filename":image.filename,"frame_id":image.frame_id,"azimuth":gps_rows[i].azimuth})
        img_gps.append(feature)
    gps_json = dumps(FeatureCollection(img_gps))

    return flask.render_template('map.html',bdgs=bdgs_json,gps=gps_json)

@app.route('/pannellum')
@login_required
def pannellum():
    """
    This will render a template that holds the panoimage viewer.
    """
    return flask.render_template('pannellum.htm')

@app.route('/_update_rrvsform')
@login_required
def update_rrvsform():
    """
	This updates the values of the rrvsform fields using jQuery. The function sends a json
	string with all values to the rrvsform.html template for populating the fields.
	Note that for QuerySelectFields the gid of the attribute_value needs to be returned by the function.
	"""
    # get building gid value for queries
    gid_val = flask.request.args.get('gid_val', 0, type=int)
    dic_attribute_val_py = flask.session['dic_attribute_val_py']
    #query attribute values for select fields
    rows = object_attribute.query.filter_by(object_id=gid_val).all()
    height_fields = ['height','height2']
    age_fields = ['yr_built']
    text_fields = ['comment','rrvs_status']
    attribute_vals = {}
    for row in rows:
        key = str(row.attribute_type_code)
        if key.lower() in height_fields:
            #convert to integer and store separately
            attribute_vals['{}_1_val'.format(key.lower())]=int(row.attribute_numeric_1)
            #also take value for type of int value
            gid = dic_attribute_val_py[row.attribute_value]
        elif key.lower() in age_fields:
            #convert to integer and store separately
            attribute_vals['year_1_val']=int(row.attribute_numeric_1)
            #also take value for type of int value
            gid = dic_attribute_val_py[row.attribute_value]
        elif key.lower() in text_fields:
            #keep string
            attribute_vals['{}_val'.format(key.lower())]= row.attribute_value
            gid = None
        else:
            #return gid to corresponding value in table dic_attribute_val
            try:
                gid = dic_attribute_val_py[row.attribute_value]
            except KeyError:
                gid = None
        #add to dictionary
        if gid != None:
            attribute_vals['{}_gid'.format(key.lower())]=gid

    return flask.jsonify(**attribute_vals)

@app.route('/rrvsform', methods=['GET', 'POST'])
@login_required
def rrvsform():
    """
    This renders a template that displays all of the form objects if it's
    a Get request. If the user is attempting to Post then this view will push
    the data to the database.
    """
    lang=flask.session['lang']
    if lang == 'es':
        rrvs_form = RrvsForm_es()
    elif lang == 'ar':
        rrvs_form = RrvsForm_ar()
    else:
        rrvs_form = RrvsForm()

    if flask.request.method == 'POST' and rrvs_form.validate():
        print 'UPDATE: Building {} updated!'.format(rrvs_form.gid_field.data)
        # check if checkbox for rrvs status is ticked and assign values to be used for database update
        if rrvs_form.rrvs_status_field.data == True:
            rrvs_status_val = 'COMPLETED'
        else:
            rrvs_status_val = 'MODIFIED'
        # update database with form content
        rows = object_attribute.query.filter_by(object_id=rrvs_form.gid_field.data)
        height_fields = ['height','height2']
        age_fields = ['yr_built']
        text_fields = ['comment']
        for row in rows:
            key = str(row.attribute_type_code).lower()
            if key not in ['build_type','build_subtype']:#not implemented
                if key in height_fields:
                    row.attribute_value = rrvs_form.__dict__[key+'_field'].data.attribute_value
                    row.attribute_numeric_1 = rrvs_form.__dict__[key+'_1_val_field'].data
                elif key in age_fields:
                    row.attribute_value = rrvs_form.__dict__[key+'_field'].data.attribute_value
                    row.attribute_numeric_1 = rrvs_form.__dict__['year_1_val_field'].data
                elif key in text_fields:
                    row.attribute_value = rrvs_form.__dict__[key+'_field'].data
                elif key == 'rrvs_status':
                    row.attribute_value = rrvs_status_val
                else:
                    row.attribute_value = rrvs_form.__dict__[key+'_field'].data.attribute_value
        db.session.commit()
        #update session variable for screened buildings
        flask.session['screened'][flask.session['bdg_gids'].index(int(rrvs_form.gid_field.data))]=True

    # if no post request is send the template is rendered normally showing numbers of completed bdgs
    # get the data for the rrvsFormTable from the database
    bdg_gids = flask.session['bdg_gids']
    rows = object_attribute.query.filter(db.and_(object_attribute.object_id.in_(bdg_gids),object_attribute.attribute_type_code=='RRVS_STATUS')).all()
    bdgs = []
    for row in rows:
        data = [str(row.object_id), str(row.attribute_value)]
        bdgs.append(data)
    return flask.render_template(template_name_or_list='rrvsform.html',
                                 rrvs_form=rrvs_form,
                                 bdgs=bdgs,
                                 n=len(flask.session['bdg_gids']),
                                 c=len([x for x in flask.session['screened'] if x==True]))
