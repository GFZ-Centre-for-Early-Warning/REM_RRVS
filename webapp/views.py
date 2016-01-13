'''
---------------------------
    views.py
---------------------------
Created on 24.04.2015
Last modified on 24.04.2015
Author: Marc Wieland, Michael Haas
Description: The main views file setting up the flask application layout, defining all routes
----
'''
import flask
from webapp import app, db
from models import ve_object, dic_attribute_value,gps,pan_imgs,User,task
from forms import RrvsForm,LoginForm
from flask.ext.security import login_required,login_user,logout_user
import geoalchemy2.functions as func
import json
from geojson import Feature, FeatureCollection, dumps


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

#######################################
# Login landing page
#######################################
@app.route("/", methods=["GET", "POST"])
def login():
    """For GET requests, display the login form. For POSTS, login the current user
    by processing the form and storing the taskid."""
    form = LoginForm()
    if form.validate_on_submit():
        user = User.query.get(form.userid.data)
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
            return flask.redirect(flask.url_for("main"))
    return flask.render_template("index.htm", form=form)

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
def map():
	"""
	This will render a template that holds the map.
        Displaying buildings with gids contained in taskid
	"""
        #get bdg_gids
        bdg_gids = flask.session['bdg_gids']
        #get FeatureCollection with corresponding building footprints
        rows = ve_object.query.filter(ve_object.gid.in_(bdg_gids)).all()
        bdgs = []
        for row in rows:
            geometry = json.loads(db.session.scalar(func.ST_AsGeoJSON(row.the_geom)))#func.ST_AsGeoJSON(row.the_geom)
            feature = Feature(id=row.gid,geometry=geometry,properties={"gid":row.gid})
            bdgs.append(feature)
        bdgs_json = dumps(FeatureCollection(bdgs))
        #get img_gids
        img_gids = flask.session['img_gids']
        rows = gps.query.filter(gps.img_id.in_(img_gids)).all()
        img_gps = []
        for row in rows:
            geometry = json.loads(db.session.scalar(func.ST_AsGeoJSON(row.the_geom)))
            feature = Feature(id=row.gid,geometry=geometry,properties={"img_id":row.img_id,"azimuth":row.azimuth})
            img_gps.append(feature)
        gps_json = dumps(FeatureCollection(img_gps))

        return flask.render_template('map.html',bdgs=bdgs_json,gps=gps_json)

@app.route('/pannellum')
def pannellum():
	"""
	This will render a template that holds the panoimage viewer.
	"""
	return flask.render_template('pannellum.htm')

@app.route('/_update_rrvsform')
def update_rrvsform():
	"""
	This updates the values of the rrvsform fields using jQuery. Note that for
	QuerySelectFields the gid of the attribute_value needs to be returned by the function.
	"""
	# get building gid value for queries
	gid_val = flask.request.args.get('gid_val', 0, type=int)
	# query attribute_value for select fields
	mat_type_val = ve_object.query.filter_by(gid=gid_val).first().mat_type
	mat_tech_val = ve_object.query.filter_by(gid=gid_val).first().mat_tech
	mat_prop_val = ve_object.query.filter_by(gid=gid_val).first().mat_prop
	llrs_val = ve_object.query.filter_by(gid=gid_val).first().llrs
	height_val = ve_object.query.filter_by(gid=gid_val).first().height
	yr_built_val = ve_object.query.filter_by(gid=gid_val).first().yr_built
	occupy_val = ve_object.query.filter_by(gid=gid_val).first().occupy
	occupy_dt_val = ve_object.query.filter_by(gid=gid_val).first().occupy_dt
	nonstrcexw_val = ve_object.query.filter_by(gid=gid_val).first().nonstrcexw

	return flask.jsonify(
		# query values for text fields
		height1_val = int(ve_object.query.filter_by(gid=gid_val).first().height_1),
		# query gid of attribute_values for select fields
		mat_type_gid = dic_attribute_value.query.filter_by(attribute_value=mat_type_val).first().gid,
		mat_tech_gid = dic_attribute_value.query.filter_by(attribute_value=mat_tech_val).first().gid,
		mat_prop_gid = dic_attribute_value.query.filter_by(attribute_value=mat_prop_val).first().gid,
		llrs_gid = dic_attribute_value.query.filter_by(attribute_value=llrs_val).first().gid,
		height_gid = dic_attribute_value.query.filter_by(attribute_value=height_val).first().gid,
		yr_built_gid = dic_attribute_value.query.filter_by(attribute_value=yr_built_val).first().gid,
		occupy_gid = dic_attribute_value.query.filter_by(attribute_value=occupy_val).first().gid,
		occupy_dt_gid = dic_attribute_value.query.filter_by(attribute_value=occupy_dt_val).first().gid,
		nonstrcexw_gid = dic_attribute_value.query.filter_by(attribute_value=nonstrcexw_val).first().gid
	)

@app.route('/rrvsform', methods=['GET', 'POST'])
def rrvsform():
	"""
	This renders a template that displays all of the form objects if it's
	a Get request. If the user is attempting to Post then this view will push
	the data to the database.
	"""
	rrvs_form = RrvsForm()

	if flask.request.method == 'POST' and rrvs_form.validate():
		# update database with form content
		row = ve_object.query.filter_by(gid=rrvs_form.gid_field.data)
		row.update({ve_object.mat_type: rrvs_form.mat_type_field.data.attribute_value,
					ve_object.mat_tech: rrvs_form.mat_tech_field.data.attribute_value,
					ve_object.mat_prop: rrvs_form.mat_prop_field.data.attribute_value,
					ve_object.llrs: rrvs_form.llrs_field.data.attribute_value,
					ve_object.height: rrvs_form.height_field.data.attribute_value,
					ve_object.height_1: rrvs_form.height1_field.data,
					ve_object.yr_built: rrvs_form.yr_built_field.data.attribute_value,
					ve_object.occupy: rrvs_form.occupy_field.data.attribute_value,
					ve_object.occupy_dt: rrvs_form.occupy_dt_field.data.attribute_value,
					ve_object.nonstrcexw: rrvs_form.nonstrcexw_field.data.attribute_value
					}, synchronize_session=False)
		db.session.commit()
                #update session variable for screened buildings
                flask.session['screened'][flask.session['bdg_gids'].index(int(rrvs_form.gid_field.data))]=True

	# if no post request is send the template is rendered normally showing numbers of completed bdgs
	return flask.render_template(template_name_or_list='rrvsform.html', rrvs_form=rrvs_form,n=len(flask.session['bdg_gids']),c=len([x for x in flask.session['screened'] if x==True]))
