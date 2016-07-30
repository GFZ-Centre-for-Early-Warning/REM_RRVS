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
from wtforms import TextField, TextAreaField, BooleanField, SubmitField
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
def getLlrsDuct():
	return dic_attribute_value.query.filter_by(attribute_type_code='LLRS_DUCT')
def getHeight():
	return dic_attribute_value.query.filter_by(attribute_type_code='HEIGHT')
def getYrBuilt():
	return dic_attribute_value.query.filter_by(attribute_type_code='YR_BUILT')
def getOccupy():
	return dic_attribute_value.query.filter_by(attribute_type_code='OCCUPY')
def getOccupyDt():
	return dic_attribute_value.query.filter_by(attribute_type_code='OCCUPY_DT')
def getPosition():
	return dic_attribute_value.query.filter_by(attribute_type_code='POSITION')
def getPlanShape():
	return dic_attribute_value.query.filter_by(attribute_type_code='PLAN_SHAPE')
#NOTE: choices for secondary str.irreg. are for now the same as for primary
def getStrIrreg():
	return dic_attribute_value.query.filter_by(attribute_type_code='STR_IRREG')
def getStrIrreg2():
	return dic_attribute_value.query.filter_by(attribute_type_code='STR_IRREG')
def getStrIrregDt():
	return dic_attribute_value.query.filter_by(attribute_type_code='STR_IRREG_DT')
def getStrIrregDt2():
	return dic_attribute_value.query.filter_by(attribute_type_code='STR_IRREG_DT')
def getStrIrregType():
	return dic_attribute_value.query.filter_by(attribute_type_code='STR_IRREG_TYPE')
def getStrIrregType2():
	return dic_attribute_value.query.filter_by(attribute_type_code='STR_IRREG_TYPE')
def getNonstrcexw():
	return dic_attribute_value.query.filter_by(attribute_type_code='NONSTRCEXW')
def getRoofShape():
	return dic_attribute_value.query.filter_by(attribute_type_code='ROOF_SHAPE')
def getRoofCovMat():
	return dic_attribute_value.query.filter_by(attribute_type_code='ROOFCOVMAT')
def getRoofSysMat():
	return dic_attribute_value.query.filter_by(attribute_type_code='ROOFSYSMAT')
def getRoofSysType():
	return dic_attribute_value.query.filter_by(attribute_type_code='ROOFSYSTYPE')
def getRoofConn():
	return dic_attribute_value.query.filter_by(attribute_type_code='ROOF_CONN')
def getFloorMat():
	return dic_attribute_value.query.filter_by(attribute_type_code='FLOOR_MAT')
def getFloorType():
	return dic_attribute_value.query.filter_by(attribute_type_code='FLOOR_TYPE')
def getFloorConn():
	return dic_attribute_value.query.filter_by(attribute_type_code='FLOOR_CONN')
def getFoundnSys():
	return dic_attribute_value.query.filter_by(attribute_type_code='FOUNDN_SYS')

class RrvsForm(Form):
    """
    This Form class contains all of the fields in the RRVS form.
    """
    label='description'
    # Text fields
    gid_field = TextField(label=lazy_gettext("BuildingID"))
    height_val_1_field = TextField(label=lazy_gettext("Height Value"), validators=[validators.Length(max=10), validators.Optional()])
    height_val_2_field = TextField(label=lazy_gettext("Height Value 2"), validators=[validators.Length(max=10), validators.Optional()])
    yr_built_bp_field = TextField(label=lazy_gettext("Construction Date"), validators=[validators.Length(max=10), validators.Optional()])
    comment_field = TextAreaField(label=lazy_gettext("Comment"), validators=[validators.Length(max=254), validators.Optional()])
    vuln_field = TextAreaField(label=lazy_gettext("Vulnerability"), validators=[validators.Length(max=10), validators.Optional()])

    # Select fields
    mat_type_field = QuerySelectField(lazy_gettext("Material Type"), query_factory=getMatType, get_label=label, allow_blank=True)
    mat_tech_field = QuerySelectField(lazy_gettext("Material Technology"), query_factory=getMatTech, get_label=label, allow_blank=True)
    mat_prop_field = QuerySelectField(lazy_gettext("Material Property"), query_factory=getMatProp, get_label=label, allow_blank=True)
    llrs_field = QuerySelectField(lazy_gettext("Lat. Load Res. Sys."), query_factory=getLlrs, get_label=label, allow_blank=True)
    llrs_duct_field = QuerySelectField(lazy_gettext("Lat. Load Res. Sys. Duct."), query_factory=getLlrsDuct, get_label=label, allow_blank=True)
    height_field = QuerySelectField(lazy_gettext("Height Type"), query_factory=getHeight, get_label=label, allow_blank=True)
    height2_field = QuerySelectField(lazy_gettext("Second Height Type"), query_factory=getHeight, get_label=label, allow_blank=True)
    yr_built_field = QuerySelectField(lazy_gettext("Construction Date Type"), query_factory=getYrBuilt, get_label=label, allow_blank=True)
    occupy_field = QuerySelectField(lazy_gettext("Occupancy Type"), query_factory=getOccupy, get_label=label, allow_blank=True)
    occupy_dt_field = QuerySelectField(lazy_gettext("Occupancy Detail"), query_factory=getOccupyDt, get_label=label, allow_blank=True)
    position_field = QuerySelectField(lazy_gettext("Position"), query_factory=getPosition, get_label=label, allow_blank=True)
    plan_shape_field = QuerySelectField(lazy_gettext("Plan Shape"), query_factory=getPlanShape, get_label=label, allow_blank=True)
    str_irreg_field = QuerySelectField(lazy_gettext("Structural Irregularity"), query_factory=getStrIrreg, get_label=label, allow_blank=True)
    str_irreg_2_field = QuerySelectField(lazy_gettext("Second Structural Irregularity"), query_factory=getStrIrreg2, get_label=label, allow_blank=True)
    str_irreg_dt_field = QuerySelectField(lazy_gettext("Structural Irregularity Detail"), query_factory=getStrIrregDt, get_label=label, allow_blank=True)
    str_irreg_dt_2_field = QuerySelectField(lazy_gettext("Second Structural Irregularity Detail"), query_factory=getStrIrregDt2, get_label=label, allow_blank=True)
    str_irreg_type_field = QuerySelectField(lazy_gettext("Structural Irregularity Type"), query_factory=getStrIrregType, get_label=label, allow_blank=True)
    str_irreg_type_2_field = QuerySelectField(lazy_gettext("Second Structural Irregularity Type"), query_factory=getStrIrregType2, get_label=label, allow_blank=True)
    nonstrcexw_field = QuerySelectField(lazy_gettext("Exterior Walls Material"), query_factory=getNonstrcexw, get_label=label, allow_blank=True)
    roof_shape_field = QuerySelectField(lazy_gettext("Roof Shape"), query_factory=getRoofShape, get_label=label, allow_blank=True)
    roof_covmat_field = QuerySelectField(lazy_gettext("Roof Covering Material"), query_factory=getRoofCovMat, get_label=label, allow_blank=True)
    roof_sysmat_field = QuerySelectField(lazy_gettext("Roof System Material"), query_factory=getRoofSysMat, get_label=label, allow_blank=True)
    roof_systype_field = QuerySelectField(lazy_gettext("Roof System Type"), query_factory=getRoofSysType, get_label=label, allow_blank=True)
    roof_conn_field = QuerySelectField(lazy_gettext("Roof Connections"), query_factory=getRoofConn, get_label=label, allow_blank=True)
    floor_mat_field = QuerySelectField(lazy_gettext("Floor Material"), query_factory=getFloorMat, get_label=label, allow_blank=True)
    floor_type_field = QuerySelectField(lazy_gettext("Floor Type"), query_factory=getFloorType, get_label=label, allow_blank=True)
    floor_conn_field = QuerySelectField(lazy_gettext("Floor Connections"), query_factory=getFloorConn, get_label=label, allow_blank=True)
    foundn_sys_field = QuerySelectField(lazy_gettext("Foundation System"), query_factory=getFoundnSys, get_label=label, allow_blank=True)

    # Checkbox fields
#    second_irreg_field = BooleanField(label=lazy_gettext("Second Irregularity"))
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
