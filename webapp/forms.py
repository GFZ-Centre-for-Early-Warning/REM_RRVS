from flask.ext.wtf import Form
from wtforms.fields import TextField, SubmitField
from wtforms.ext.sqlalchemy.fields import QuerySelectField
import wtforms.validators as validators
from functools import partial
from sqlalchemy import orm
from models import dic_attribute_value

def getQuery(filter_attribute, columns=None):
    q = dic_attribute_value.query.filter_by(attribute_type_code=filter_attribute)
    if columns:
        q = q.options(orm.load_only(*columns))
    return q

def getQueryFactory(filter_attribute, columns=None):
    return partial(getQuery, filter_attribute, columns=columns)
      
class RrvsForm(Form):
	"""
	This Form class contains all of the fields in the RRVS form.
	"""
	# Text fields
	height_field = TextField(label="Height", validators=[validators.Length(max=10), validators.Required()])
	# Select fields
	mat_prop_field = QuerySelectField("Material Property", query_factory=getQueryFactory('MAT_PROP', ['attribute_value']), get_label='description', allow_blank=True)
	# Submit field
	submit = SubmitField("Send")
