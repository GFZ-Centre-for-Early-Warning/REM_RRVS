from webapp import db

class dic_attribute_value(db.Model):
	"""
	Holds dic_attribute_value from the taxonomy schema.
	"""
	__tablename__ = "dic_attribute_value"
	__table_args__ = {'schema':'taxonomy'}
	
	gid = db.Column(db.Integer, primary_key=True)
	attribute_type_code = db.Column(db.String(254))
	attribute_value = db.Column(db.String(254), unique=True)
	description = db.Column(db.String(254))
	extended_description = db.Column(db.String(1024))
	
class ve_resolution1(db.Model):
	"""
	Holds ve_resolution1 from the object schema.
	"""
	__tablename__ = "ve_resolution1"
	__table_args__ = {'schema':'object_res1'}
	
	gid = db.Column(db.Integer, primary_key=True)
	height_1 = db.Column(db.Integer)
	mat_prop = db.Column(db.String(254))
