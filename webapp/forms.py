'''
---------------------------
    forms.py
---------------------------
Created on 24.04.2015
Last modified on 24.04.2015
Author: Marc Wieland
Description: Defines the WTForms fields
----
'''
from flask.ext.wtf import Form
from wtforms import TextField, SubmitField
from wtforms.ext.sqlalchemy.fields import QuerySelectField
import wtforms.validators as validators
from models import ve_resolution1, dic_attribute_value

def getMatType():
	return dic_attribute_value.query.filter_by(attribute_type_code='MAT_TYPE')
def getMatTech():
	return dic_attribute_value.query.filter_by(attribute_type_code='MAT_TECH')
def getMatProp():
	return dic_attribute_value.query.filter_by(attribute_type_code='MAT_PROP')
def getLlrs():
	return dic_attribute_value.query.filter_by(attribute_type_code='LLRS')
def getHeight():
	return dic_attribute_value.query.filter_by(attribute_type_code='HEIGHT')
def getYrBuilt():
	return dic_attribute_value.query.filter_by(attribute_type_code='YR_BUILT')
def getOccupy():
	return dic_attribute_value.query.filter_by(attribute_type_code='OCCUPY')
def getOccupyDt():
	return dic_attribute_value.query.filter_by(attribute_type_code='OCCUPY_DT')
def getNonstrcexw():
	return dic_attribute_value.query.filter_by(attribute_type_code='NONSTRCEXW')

class RrvsForm(Form):
	"""
	This Form class contains all of the fields in the RRVS form.
	"""
	# Text fields
	gid_field = TextField(label="BuildingID")
	height1_field = TextField(label="Height Value", validators=[validators.Length(max=10), validators.Required()])
	# Select fields
	mat_type_field = QuerySelectField("Material Type", query_factory=getMatType, get_label='description', allow_blank=True)
	mat_tech_field = QuerySelectField("Material Technology", query_factory=getMatTech, get_label='description', allow_blank=True)
	mat_prop_field = QuerySelectField("Material Property", query_factory=getMatProp, get_label='description', allow_blank=True)
	llrs_field = QuerySelectField("Lat. Load Res. Sys.", query_factory=getLlrs, get_label='description', allow_blank=True)
	height_field = QuerySelectField("Height Type", query_factory=getHeight, get_label='description', allow_blank=True)
	yr_built_field = QuerySelectField("Construction Date Type", query_factory=getYrBuilt, get_label='description', allow_blank=True)
	occupy_field = QuerySelectField("Occupancy Type", query_factory=getOccupy, get_label='description', allow_blank=True)
	occupy_dt_field = QuerySelectField("Occupancy Detail", query_factory=getOccupyDt, get_label='description', allow_blank=True)
	nonstrcexw_field = QuerySelectField("Exterior Walls Material", query_factory=getNonstrcexw, get_label='description', allow_blank=True)

	# Submit field
	submit = SubmitField("Update building")

class LoginForm(Form):
    """
    This Form class contains the login in form of task_id
    """
    taskid = TextField("taskid",[validators.Length(max=20)])
