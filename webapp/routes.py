'''
---------------------------
    routes.py
---------------------------
Created on 24.04.2015
Last modified on 24.04.2015
Author: Marc Wieland
Description: The main routes file setting up the flask application layout
----
'''
from flask import render_template, request, jsonify
from webapp import app, db
from models import ve_resolution1, dic_attribute_value
from forms import RrvsForm

@app.route('/')
def home():
	"""
	This will render a template that holds the main pagelayout.
	"""
	return render_template('index.htm')

@app.route('/map')
def map():
	"""
	This will render a template that holds the map.
	"""
	return render_template('map.html')

@app.route('/pannellum')
def pannellum():
	"""
	This will render a template that holds the panoimage viewer.
	"""
	return render_template('pannellum.htm')

@app.route('/_update_rrvsform')
def update_rrvsform():
	"""
	This updates the values of the rrvsform fields using jQuery. Note that for
	QuerySelectFields the gid of the attribute_value needs to be returned by the function.
	"""
	# get building gid value for queries
	gid_val = request.args.get('gid_val', 0, type=int)
	# query attribute_value for select fields
	mat_type_val = ve_resolution1.query.filter_by(gid=gid_val).first().mat_type
	mat_tech_val = ve_resolution1.query.filter_by(gid=gid_val).first().mat_tech
	mat_prop_val = ve_resolution1.query.filter_by(gid=gid_val).first().mat_prop
	llrs_val = ve_resolution1.query.filter_by(gid=gid_val).first().llrs
	height_val = ve_resolution1.query.filter_by(gid=gid_val).first().height
	yr_built_val = ve_resolution1.query.filter_by(gid=gid_val).first().yr_built
	occupy_val = ve_resolution1.query.filter_by(gid=gid_val).first().occupy
	occupy_dt_val = ve_resolution1.query.filter_by(gid=gid_val).first().occupy_dt
	nonstrcexw_val = ve_resolution1.query.filter_by(gid=gid_val).first().nonstrcexw

	return jsonify(
		# query values for text fields
		height1_val = int(ve_resolution1.query.filter_by(gid=gid_val).first().height_1),
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

	if request.method == 'POST' and rrvs_form.validate():
		# update database with form content
		row = ve_resolution1.query.filter_by(gid=rrvs_form.gid_field.data)
		row.update({ve_resolution1.mat_type: rrvs_form.mat_type_field.data.attribute_value,
					ve_resolution1.mat_tech: rrvs_form.mat_tech_field.data.attribute_value,
					ve_resolution1.mat_prop: rrvs_form.mat_prop_field.data.attribute_value,
					ve_resolution1.llrs: rrvs_form.llrs_field.data.attribute_value,
					ve_resolution1.height: rrvs_form.height_field.data.attribute_value,
					ve_resolution1.height_1: rrvs_form.height1_field.data,
					ve_resolution1.yr_built: rrvs_form.yr_built_field.data.attribute_value,
					ve_resolution1.occupy: rrvs_form.occupy_field.data.attribute_value,
					ve_resolution1.occupy_dt: rrvs_form.occupy_dt_field.data.attribute_value,
					ve_resolution1.nonstrcexw: rrvs_form.nonstrcexw_field.data.attribute_value
					}, synchronize_session=False)
		db.session.commit()

	# if no post request is send the template is rendered normally
	return render_template(template_name_or_list='rrvsform.html', rrvs_form=rrvs_form)
