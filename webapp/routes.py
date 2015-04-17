from flask import render_template, request, flash
from webapp import app, db
from models import ve_resolution1
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

@app.route('/rrvsform', methods=['GET', 'POST'])
def rrvsform():
	"""
	This renders a template that displays all of the form objects if it's
	a Get request. If the use is attempting to Post then this view will push
	the data to the database.
	"""
	rrvs_form = RrvsForm()
		
	if request.method == 'POST' and rrvs_form.validate():
		# Update database with form content
		row = ve_resolution1.query.filter_by(gid=rrvs_form.gid_field.data)
		row.update({ve_resolution1.height_1: rrvs_form.height_field.data, 
					ve_resolution1.mat_prop: rrvs_form.mat_prop_field.data.attribute_value}, synchronize_session=False)		
		db.session.commit()
		
	# If no post request is send the template is rendered normally.	
	return render_template(template_name_or_list='rrvsform.html', rrvs_form=rrvs_form)
