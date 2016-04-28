'''
---------------------------
    forms.py
---------------------------
Created on 24.04.2015
Last modified on 24.04.2015
Author: Marc Wieland, Michael Haas
Description: Defines the WTForms fields
----
'''
import flask
from flask.ext.wtf import Form
from wtforms import TextField, BooleanField, SubmitField
from wtforms.ext.sqlalchemy.fields import QuerySelectField
import wtforms.validators as validators
from models import dic_attribute_value
from flask.ext.babel import lazy_gettext

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
    label='description'
    # Text fields
    gid_field = TextField(label=lazy_gettext("BuildingID"))
    height1_field = TextField(label=lazy_gettext("Height Value"), validators=[validators.Length(max=10), validators.Required()])
    yr_built_bp_field = TextField(label=lazy_gettext("Construction Date"), validators=[validators.Length(max=10), validators.Required()])
    # Select fields
    mat_type_field = QuerySelectField(lazy_gettext("Material Type"), query_factory=getMatType, get_label=label, allow_blank=True)
    mat_tech_field = QuerySelectField(lazy_gettext("Material Technology"), query_factory=getMatTech, get_label=label, allow_blank=True)
    mat_prop_field = QuerySelectField(lazy_gettext("Material Property"), query_factory=getMatProp, get_label=label, allow_blank=True)
    llrs_field = QuerySelectField(lazy_gettext("Lat. Load Res. Sys."), query_factory=getLlrs, get_label=label, allow_blank=True)
    height_field = QuerySelectField(lazy_gettext("Height Type"), query_factory=getHeight, get_label=label, allow_blank=True)
    yr_built_field = QuerySelectField(lazy_gettext("Construction Date Type"), query_factory=getYrBuilt, get_label=label, allow_blank=True)
    occupy_field = QuerySelectField(lazy_gettext("Occupancy Type"), query_factory=getOccupy, get_label=label, allow_blank=True)
    occupy_dt_field = QuerySelectField(lazy_gettext("Occupancy Detail"), query_factory=getOccupyDt, get_label=label, allow_blank=True)
    nonstrcexw_field = QuerySelectField(lazy_gettext("Exterior Walls Material"), query_factory=getNonstrcexw, get_label=label, allow_blank=True)
    # Checkbox fields
    rrvs_status_field = BooleanField(label=lazy_gettext("Completed"))
    # Submit field
    submit = SubmitField(lazy_gettext("Update building"))

class RrvsForm_ar(Form):
    """
    This Form class contains all of the fields in the RRVS form.
    """
    label='description_ar'
    # Text fields
    gid_field = TextField(label=lazy_gettext("BuildingID"))
    height1_field = TextField(label=lazy_gettext("Height Value"), validators=[validators.Length(max=10), validators.Required()])
    yr_built_bp_field = TextField(label=lazy_gettext("Construction Date"), validators=[validators.Length(max=10), validators.Required()])
    # Select fields
    mat_type_field = QuerySelectField(lazy_gettext("Material Type"), query_factory=getMatType, get_label=label, allow_blank=True)
    mat_tech_field = QuerySelectField(lazy_gettext("Material Technology"), query_factory=getMatTech, get_label=label, allow_blank=True)
    mat_prop_field = QuerySelectField(lazy_gettext("Material Property"), query_factory=getMatProp, get_label=label, allow_blank=True)
    llrs_field = QuerySelectField(lazy_gettext("Lat. Load Res. Sys."), query_factory=getLlrs, get_label=label, allow_blank=True)
    height_field = QuerySelectField(lazy_gettext("Height Type"), query_factory=getHeight, get_label=label, allow_blank=True)
    yr_built_field = QuerySelectField(lazy_gettext("Construction Date Type"), query_factory=getYrBuilt, get_label=label, allow_blank=True)
    occupy_field = QuerySelectField(lazy_gettext("Occupancy Type"), query_factory=getOccupy, get_label=label, allow_blank=True)
    occupy_dt_field = QuerySelectField(lazy_gettext("Occupancy Detail"), query_factory=getOccupyDt, get_label=label, allow_blank=True)
    nonstrcexw_field = QuerySelectField(lazy_gettext("Exterior Walls Material"), query_factory=getNonstrcexw, get_label=label, allow_blank=True)
    # Checkbox fields
    rrvs_status_field = BooleanField(label=lazy_gettext("Completed"))
    # Submit field
    submit = SubmitField(lazy_gettext("Update building"))

class LoginForm(Form):
    """
    This Form class contains the login in form of task_id
    """
    userid = TextField(label=lazy_gettext("UserID"), validators=[validators.Length(max=20)])
    taskid = TextField(label=lazy_gettext("TaskID"), validators=[validators.Length(max=20)])
