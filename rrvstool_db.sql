-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
-- Name: SENSUM multi-resolution, multi-temporal database model 
-- Version: 0.9.2
-- Date: 02.12.14
-- Author: M. Wieland
-- DBMS: PostgreSQL9.2 / PostGIS2.0
-- Description: Adds the basic data model with hstore and postgis support.  
--		To activate multi-resolution support run sensum_db_AddMultiResolutionSupport.sql. 
--		To activate multi-temporal support run sensum_db_AddMultiTemporalSupport.sql.
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
CREATE EXTENSION IF NOT EXISTS postgis;

CREATE EXTENSION IF NOT EXISTS postgis_topology;

CREATE EXTENSION IF NOT EXISTS hstore;

CREATE SCHEMA taxonomy;

CREATE SCHEMA object_res1;

CREATE SCHEMA object_res2;

CREATE SCHEMA object_res3;

CREATE SCHEMA history;

CREATE TABLE taxonomy.dic_qualifier_type ( 
	gid                  serial NOT NULL,
	code                 varchar( 254 ),
	description          varchar( 254 ),
	extended_description varchar( 1024 ),
	CONSTRAINT pk_qualifier_type PRIMARY KEY ( gid ),
	CONSTRAINT pk_dic_qualifier_type UNIQUE ( code )
 );

COMMENT ON TABLE taxonomy.dic_qualifier_type IS 'The qualifier type dictionary table. Contains information about the qualifier types.';

COMMENT ON COLUMN taxonomy.dic_qualifier_type.gid IS 'Unique qualifier type identifier';

COMMENT ON COLUMN taxonomy.dic_qualifier_type.code IS 'Code of the qualifier type';

COMMENT ON COLUMN taxonomy.dic_qualifier_type.description IS 'Short textual description of the qualifier type';

COMMENT ON COLUMN taxonomy.dic_qualifier_type.extended_description IS 'Extended textual description of the qualifier type';

CREATE TABLE taxonomy.dic_qualifier_value ( 
	gid                  serial NOT NULL,
	qualifier_type_code  varchar( 254 ),
	qualifier_value      varchar( 254 ),
	description          varchar( 254 ),
	extended_description varchar( 1024 ),
	CONSTRAINT pk_dic_qualifier_value PRIMARY KEY ( gid ),
	CONSTRAINT pk_dic_qualifier_value_0 UNIQUE ( qualifier_value )
 );

CREATE INDEX idx_dic_qualifier_value ON taxonomy.dic_qualifier_value ( qualifier_type_code );

COMMENT ON TABLE taxonomy.dic_qualifier_value IS 'The qualifier value dictionary table. Contains information about the qualifier values.';

COMMENT ON COLUMN taxonomy.dic_qualifier_value.gid IS 'Unique qualifier value identifier';

COMMENT ON COLUMN taxonomy.dic_qualifier_value.qualifier_type_code IS 'Code of the qualifier type to which the value refers to';

COMMENT ON COLUMN taxonomy.dic_qualifier_value.qualifier_value IS 'Value of the qualifier';

COMMENT ON COLUMN taxonomy.dic_qualifier_value.description IS 'Short textual description of the qualifier value';

COMMENT ON COLUMN taxonomy.dic_qualifier_value.extended_description IS 'Extended textual description of the qualifier value';

CREATE TABLE taxonomy.dic_taxonomy ( 
	gid                  serial NOT NULL,
	code                 varchar( 254 ),
	description          varchar( 254 ),
	extended_description varchar( 1024 ),
	version_date         date,
	CONSTRAINT pk_dic_taxonomy PRIMARY KEY ( gid ),
	CONSTRAINT pk_dic_taxonomy_0 UNIQUE ( code )
 );

COMMENT ON TABLE taxonomy.dic_taxonomy IS 'The taxonomy dictionary table. Contains information about the taxonomy to which the attribute type is linked to.';

COMMENT ON COLUMN taxonomy.dic_taxonomy.gid IS 'Unique taxonomy identifier';

COMMENT ON COLUMN taxonomy.dic_taxonomy.code IS 'Code of the taxonomy';

COMMENT ON COLUMN taxonomy.dic_taxonomy.description IS 'Short textual description of the taxonomy';

COMMENT ON COLUMN taxonomy.dic_taxonomy.extended_description IS 'Extended textual description of the taxonomy';

COMMENT ON COLUMN taxonomy.dic_taxonomy.version_date IS 'Version of the taxonomy (date of the version)';

CREATE TABLE taxonomy.dic_attribute_type ( 
	gid                  serial NOT NULL,
	code                 varchar( 254 ),
	description          varchar( 254 ),
	extended_description varchar( 1024 ),
	taxonomy_code        varchar( 254 ),
	attribute_level      smallint,
	attribute_order      smallint,
	CONSTRAINT pk_dic_attribute_type PRIMARY KEY ( gid ),
	CONSTRAINT idx_dic_attribute_type UNIQUE ( code )
 );

CREATE INDEX idx_dic_attribute_type_0 ON taxonomy.dic_attribute_type ( taxonomy_code );

COMMENT ON TABLE taxonomy.dic_attribute_type IS 'The attribute type dictionary table. Contains information about the attribute types.';

COMMENT ON COLUMN taxonomy.dic_attribute_type.gid IS 'Unique attribute type identifier';

COMMENT ON COLUMN taxonomy.dic_attribute_type.code IS 'Code of the attribute type';

COMMENT ON COLUMN taxonomy.dic_attribute_type.description IS 'Short textual description of the attribute type';

COMMENT ON COLUMN taxonomy.dic_attribute_type.extended_description IS 'Extended textual description of the attribute type';

COMMENT ON COLUMN taxonomy.dic_attribute_type.taxonomy_code IS 'Code of the taxonomy';

COMMENT ON COLUMN taxonomy.dic_attribute_type.attribute_level IS 'Identifier of the attribute level (e.g. GEM taxonomy: 1 = main attribute, 2 = secondary attribute, 3 = tertiary attribute)';

COMMENT ON COLUMN taxonomy.dic_attribute_type.attribute_order IS 'Order of the attribute type. To be used for compiling a textual representation of the taxonomy attributes and their values which follows a predefined order (e.g. GEM Taxonomy TaxT strings)';

CREATE TABLE taxonomy.dic_attribute_value ( 
	gid                  serial NOT NULL,
	attribute_type_code  varchar( 254 ),
	attribute_value      varchar( 254 ),
	description          varchar( 254 ),
	extended_description varchar( 1024 ),
	CONSTRAINT pk_dic_attribute_value PRIMARY KEY ( gid ),
	CONSTRAINT pk_dic_attribute_value_0 UNIQUE ( attribute_value )
 );

CREATE INDEX idx_dic_attribute_value ON taxonomy.dic_attribute_value ( attribute_type_code );

COMMENT ON TABLE taxonomy.dic_attribute_value IS 'The attribute value dictionary table. Contains information about the attribute values.';

COMMENT ON COLUMN taxonomy.dic_attribute_value.gid IS 'Unique attribute value identifier';

COMMENT ON COLUMN taxonomy.dic_attribute_value.attribute_type_code IS 'Code of the attribute type to which the value refers to';

COMMENT ON COLUMN taxonomy.dic_attribute_value.attribute_value IS 'Value of the attribute';

COMMENT ON COLUMN taxonomy.dic_attribute_value.description IS 'Short textual description of the attribute value';

COMMENT ON COLUMN taxonomy.dic_attribute_value.extended_description IS 'Extended textual description of the attribute value';

CREATE TABLE taxonomy.dic_hazard ( 
	gid                  serial NOT NULL,
	code                 varchar( 254 ),
	description          varchar( 254 ),
	extended_description varchar( 1024 ),
	attribute_type_code  varchar( 254 ),
	CONSTRAINT pk_hazard PRIMARY KEY ( gid )
 );

CREATE INDEX idx_hazard ON taxonomy.dic_hazard ( attribute_type_code );

COMMENT ON TABLE taxonomy.dic_hazard IS 'The hazard dictionary table. Contains information about the hazard type to which the taxonomy attribute type is linked to.';

COMMENT ON COLUMN taxonomy.dic_hazard.gid IS 'Unique hazard identifier';

COMMENT ON COLUMN taxonomy.dic_hazard.code IS 'Identifier for the hazard type';

COMMENT ON COLUMN taxonomy.dic_hazard.description IS 'Short textual description of the hazard type';

COMMENT ON COLUMN taxonomy.dic_hazard.extended_description IS 'Extended textual description of the hazard type';

COMMENT ON COLUMN taxonomy.dic_hazard.attribute_type_code IS 'Code of the taxonomy attribute type to which the hazard type is linked to';

CREATE TABLE object_res1.main ( 
	gid                  serial NOT NULL,
	survey_gid           integer,
	description          varchar( 254 ),
	source               text,
	accuracy	     numeric,
	res2_id		     integer,
	res3_id       	     integer,
	the_geom             geometry,
	CONSTRAINT pk_main_0 PRIMARY KEY ( gid )
 );

COMMENT ON TABLE object_res1.main IS 'The main object table for resolution 1 (e.g. per building scale). Contains basic information about the object.';

COMMENT ON COLUMN object_res1.main.gid IS 'Unique object identifier';

COMMENT ON COLUMN object_res1.main.survey_gid IS 'Identifier for the survey';

COMMENT ON COLUMN object_res1.main.description IS 'Textual description of the object';

COMMENT ON COLUMN object_res1.main.source IS 'Source of the object (geometry)';

COMMENT ON COLUMN object_res1.main.accuracy IS 'Accuracy of the object (geometry)';

COMMENT ON COLUMN object_res1.main.res2_id IS 'gid of the object at resolution level 2 (e.g. neighbourhood scale)';

COMMENT ON COLUMN object_res1.main.res3_id IS 'gid of the object at resolution level 3 (e.g. settlement scale)';

COMMENT ON COLUMN object_res1.main.the_geom IS 'Spatial reference and geometry information';

CREATE TABLE object_res1.main_detail ( 
	gid                  serial NOT NULL,
	object_id            integer,
	attribute_type_code  varchar( 254 ),
	attribute_value      varchar( 254 ),
	attribute_numeric_1  numeric,
	attribute_numeric_2  numeric,
	attribute_text_1     varchar( 254 ),
	CONSTRAINT pk_object PRIMARY KEY ( gid )
 );

CREATE INDEX pk_main ON object_res1.main_detail ( attribute_type_code );

CREATE INDEX idx_main ON object_res1.main_detail ( attribute_value );

CREATE INDEX idx_main_detail ON object_res1.main_detail ( object_id );

COMMENT ON TABLE object_res1.main_detail IS 'The main object detail table. Contains information about the object details.';

COMMENT ON COLUMN object_res1.main_detail.gid IS 'Unique object detail identifier';

COMMENT ON COLUMN object_res1.main_detail.object_id IS 'Object identifier';

COMMENT ON COLUMN object_res1.main_detail.attribute_type_code IS 'Code of the taxonomy attribute type';

COMMENT ON COLUMN object_res1.main_detail.attribute_value IS 'Value of the taxonomy attribute type (from look up table in taxonomy scheme)';

COMMENT ON COLUMN object_res1.main_detail.attribute_numeric_1 IS 'Value of the taxonomy attribute type (numeric)';

COMMENT ON COLUMN object_res1.main_detail.attribute_numeric_2 IS 'Value of the taxonomy attribute type (numeric)';

COMMENT ON COLUMN object_res1.main_detail.attribute_text_1 IS 'Value of the taxonomy attribute type (textual)';

CREATE TABLE object_res1.main_detail_qualifier ( 
	gid                  serial NOT NULL,
	detail_id            integer,
	qualifier_type_code  varchar( 254 ),
	qualifier_value      varchar( 254 ),
	qualifier_numeric_1  numeric,
	qualifier_text_1     varchar( 254 ),
	qualifier_timestamp_1 timestamptz,
	CONSTRAINT pk_main_detail_qualifier PRIMARY KEY ( gid )
 );

CREATE INDEX idx_main_detail_qualifier ON object_res1.main_detail_qualifier ( detail_id );

CREATE INDEX idx_main_detail_qualifier_0 ON object_res1.main_detail_qualifier ( qualifier_type_code );

CREATE INDEX idx_main_detail_qualifier_1 ON object_res1.main_detail_qualifier ( qualifier_value );

COMMENT ON TABLE object_res1.main_detail_qualifier IS 'The main object detail qualifier table. Contains information about the object qualifiers.';

COMMENT ON COLUMN object_res1.main_detail_qualifier.gid IS 'Unique object detail qualifier identifier';

COMMENT ON COLUMN object_res1.main_detail_qualifier.detail_id IS 'Object detail identifier';

COMMENT ON COLUMN object_res1.main_detail_qualifier.qualifier_type_code IS 'Code of the taxonomy qualifier type';

COMMENT ON COLUMN object_res1.main_detail_qualifier.qualifier_value IS 'Value of the taxonomy qualifier type (from look up table in taxonomy scheme)';

COMMENT ON COLUMN object_res1.main_detail_qualifier.qualifier_numeric_1 IS 'Value of the taxonomy qualifier type (numeric)';

COMMENT ON COLUMN object_res1.main_detail_qualifier.qualifier_text_1 IS 'Value of the taxonomy qualifier type (textual)';

COMMENT ON COLUMN object_res1.main_detail_qualifier.qualifier_timestamp_1 IS 'Value of the taxonomy qualifier type (timestamp)';

CREATE TABLE object_res2.main ( 
	gid                  serial NOT NULL,
	survey_gid           integer,
	description          varchar( 254 ),
	source               text,
	accuracy	     numeric,
	res3_id       	     integer,
	the_geom             geometry,
	CONSTRAINT pk_main_0 PRIMARY KEY ( gid )
 );

COMMENT ON TABLE object_res2.main IS 'The main object table for resolution 2 (e.g. neighbourhood scale). Contains basic information about the object.';

COMMENT ON COLUMN object_res2.main.gid IS 'Unique object identifier';

COMMENT ON COLUMN object_res2.main.survey_gid IS 'Identifier for the survey';

COMMENT ON COLUMN object_res2.main.description IS 'Textual description of the object';

COMMENT ON COLUMN object_res2.main.source IS 'Source of the object content (e.g. remote sensing, in-situ)';

COMMENT ON COLUMN object_res2.main.accuracy IS 'Accuracy of the object content';

COMMENT ON COLUMN object_res2.main.res3_id IS 'gid of the object at resolution level 3 (e.g. settlement scale)';

COMMENT ON COLUMN object_res2.main.the_geom IS 'Spatial reference and geometry information';

CREATE TABLE object_res2.main_detail ( 
	gid                  serial NOT NULL,
	object_id            integer,
	attribute_type_code  varchar( 254 ),
	attribute_value      varchar( 254 ),
	attribute_numeric_1  numeric,
	attribute_numeric_2  numeric,
	attribute_text_1     varchar( 254 ),
	CONSTRAINT pk_object PRIMARY KEY ( gid )
 );

CREATE INDEX pk_main ON object_res2.main_detail ( attribute_type_code );

CREATE INDEX idx_main ON object_res2.main_detail ( attribute_value );

CREATE INDEX idx_main_detail ON object_res2.main_detail ( object_id );

COMMENT ON TABLE object_res2.main_detail IS 'The main object detail table. Contains information about the object details.';

COMMENT ON COLUMN object_res2.main_detail.gid IS 'Unique object detail identifier';

COMMENT ON COLUMN object_res2.main_detail.object_id IS 'Object identifier';

COMMENT ON COLUMN object_res2.main_detail.attribute_type_code IS 'Code of the taxonomy attribute type';

COMMENT ON COLUMN object_res2.main_detail.attribute_value IS 'Value of the taxonomy attribute type (from look up table in taxonomy scheme)';

COMMENT ON COLUMN object_res2.main_detail.attribute_numeric_1 IS 'Value of the taxonomy attribute type (numeric)';

COMMENT ON COLUMN object_res2.main_detail.attribute_numeric_2 IS 'Value of the taxonomy attribute type (numeric)';

COMMENT ON COLUMN object_res2.main_detail.attribute_text_1 IS 'Value of the taxonomy attribute type (textual)';

CREATE TABLE object_res2.main_detail_qualifier ( 
	gid                  serial NOT NULL,
	detail_id            integer,
	qualifier_type_code  varchar( 254 ),
	qualifier_value      varchar( 254 ),
	qualifier_numeric_1  numeric,
	qualifier_text_1     varchar( 254 ),
	qualifier_timestamp_1 timestamptz,
	CONSTRAINT pk_main_detail_qualifier PRIMARY KEY ( gid )
 );

CREATE INDEX idx_main_detail_qualifier ON object_res2.main_detail_qualifier ( detail_id );

CREATE INDEX idx_main_detail_qualifier_0 ON object_res2.main_detail_qualifier ( qualifier_type_code );

CREATE INDEX idx_main_detail_qualifier_1 ON object_res2.main_detail_qualifier ( qualifier_value );

COMMENT ON TABLE object_res2.main_detail_qualifier IS 'The main object detail qualifier table. Contains information about the object qualifiers.';

COMMENT ON COLUMN object_res2.main_detail_qualifier.gid IS 'Unique object detail qualifier identifier';

COMMENT ON COLUMN object_res2.main_detail_qualifier.detail_id IS 'Object detail identifier';

COMMENT ON COLUMN object_res2.main_detail_qualifier.qualifier_type_code IS 'Code of the taxonomy qualifier type';

COMMENT ON COLUMN object_res2.main_detail_qualifier.qualifier_value IS 'Value of the taxonomy qualifier type (from look up table in taxonomy scheme)';

COMMENT ON COLUMN object_res2.main_detail_qualifier.qualifier_numeric_1 IS 'Value of the taxonomy qualifier type (numeric)';

COMMENT ON COLUMN object_res2.main_detail_qualifier.qualifier_text_1 IS 'Value of the taxonomy qualifier type (textual)';

COMMENT ON COLUMN object_res2.main_detail_qualifier.qualifier_timestamp_1 IS 'Value of the taxonomy qualifier type (timestamp)';

CREATE TABLE object_res3.main ( 
	gid                  serial NOT NULL,
	survey_gid           integer,
	description          varchar( 254 ),
	source               text,
	accuracy	     numeric,
	the_geom             geometry,
	CONSTRAINT pk_main_0 PRIMARY KEY ( gid )
 );

COMMENT ON TABLE object_res3.main IS 'The main object table for resolution 3 (e.g. settlement scale). Contains basic information about the object.';

COMMENT ON COLUMN object_res3.main.gid IS 'Unique object identifier';

COMMENT ON COLUMN object_res3.main.survey_gid IS 'Identifier for the survey';

COMMENT ON COLUMN object_res3.main.description IS 'Textual description of the object';

COMMENT ON COLUMN object_res3.main.source IS 'Source of the object content (e.g. remote sensing, in-situ)';

COMMENT ON COLUMN object_res3.main.accuracy IS 'Accuracy of the object content';

COMMENT ON COLUMN object_res3.main.the_geom IS 'Spatial reference and geometry information';

CREATE TABLE object_res3.main_detail ( 
	gid                  serial NOT NULL,
	object_id            integer,
	attribute_type_code  varchar( 254 ),
	attribute_value      varchar( 254 ),
	attribute_numeric_1  numeric,
	attribute_numeric_2  numeric,
	attribute_text_1     varchar( 254 ),
	CONSTRAINT pk_object PRIMARY KEY ( gid )
 );

CREATE INDEX pk_main ON object_res3.main_detail ( attribute_type_code );

CREATE INDEX idx_main ON object_res3.main_detail ( attribute_value );

CREATE INDEX idx_main_detail ON object_res3.main_detail ( object_id );

COMMENT ON TABLE object_res3.main_detail IS 'The main object detail table. Contains information about the object details.';

COMMENT ON COLUMN object_res3.main_detail.gid IS 'Unique object detail identifier';

COMMENT ON COLUMN object_res3.main_detail.object_id IS 'Object identifier';

COMMENT ON COLUMN object_res3.main_detail.attribute_type_code IS 'Code of the taxonomy attribute type';

COMMENT ON COLUMN object_res3.main_detail.attribute_value IS 'Value of the taxonomy attribute type (from look up table in taxonomy scheme)';

COMMENT ON COLUMN object_res3.main_detail.attribute_numeric_1 IS 'Value of the taxonomy attribute type (numeric)';

COMMENT ON COLUMN object_res3.main_detail.attribute_numeric_2 IS 'Value of the taxonomy attribute type (numeric)';

COMMENT ON COLUMN object_res3.main_detail.attribute_text_1 IS 'Value of the taxonomy attribute type (textual)';

CREATE TABLE object_res3.main_detail_qualifier ( 
	gid                  serial NOT NULL,
	detail_id            integer,
	qualifier_type_code  varchar( 254 ),
	qualifier_value      varchar( 254 ),
	qualifier_numeric_1  numeric,
	qualifier_text_1     varchar( 254 ),
	qualifier_timestamp_1 timestamptz,
	CONSTRAINT pk_main_detail_qualifier PRIMARY KEY ( gid )
 );

CREATE INDEX idx_main_detail_qualifier ON object_res3.main_detail_qualifier ( detail_id );

CREATE INDEX idx_main_detail_qualifier_0 ON object_res3.main_detail_qualifier ( qualifier_type_code );

CREATE INDEX idx_main_detail_qualifier_1 ON object_res3.main_detail_qualifier ( qualifier_value );

COMMENT ON TABLE object_res3.main_detail_qualifier IS 'The main object detail qualifier table. Contains information about the object qualifiers.';

COMMENT ON COLUMN object_res3.main_detail_qualifier.gid IS 'Unique object detail qualifier identifier';

COMMENT ON COLUMN object_res3.main_detail_qualifier.detail_id IS 'Object detail identifier';

COMMENT ON COLUMN object_res3.main_detail_qualifier.qualifier_type_code IS 'Code of the taxonomy qualifier type';

COMMENT ON COLUMN object_res3.main_detail_qualifier.qualifier_value IS 'Value of the taxonomy qualifier type (from look up table in taxonomy scheme)';

COMMENT ON COLUMN object_res3.main_detail_qualifier.qualifier_numeric_1 IS 'Value of the taxonomy qualifier type (numeric)';

COMMENT ON COLUMN object_res3.main_detail_qualifier.qualifier_text_1 IS 'Value of the taxonomy qualifier type (textual)';

COMMENT ON COLUMN object_res3.main_detail_qualifier.qualifier_timestamp_1 IS 'Value of the taxonomy qualifier type (timestamp)';

CREATE TABLE history.logged_actions ( 
	gid                  bigserial NOT NULL,
	schema_name          text NOT NULL,
	table_name           text NOT NULL,
	table_id             oid NOT NULL,
	transaction_id       bigint,
	transaction_user     text,
	transaction_time     timestamptz NOT NULL,
	transaction_query    text,
	transaction_type     text NOT NULL,
	old_record           hstore,
	new_record           hstore,
	changed_fields       hstore,
	CONSTRAINT logged_actions_pkey PRIMARY KEY ( gid )
 );

ALTER TABLE history.logged_actions ADD CONSTRAINT logged_actions_transaction_type_check CHECK ( transaction_type = ANY (ARRAY['I'::text, 'D'::text, 'U'::text, 'T'::text]) );

CREATE INDEX logged_changes_action_idx ON history.logged_actions ( transaction_type );

CREATE INDEX logged_changes_table_id_idx ON history.logged_actions ( table_id );

COMMENT ON TABLE history.logged_actions IS 'History of transactions on activated tables, from history.if_modified_func().';

COMMENT ON COLUMN history.logged_actions.gid IS 'Unique log identifier';

COMMENT ON COLUMN history.logged_actions.schema_name IS 'Textual reference to the database schema which contains the modified table';

COMMENT ON COLUMN history.logged_actions.table_name IS 'Name of the modified table';

COMMENT ON COLUMN history.logged_actions.table_id IS 'OID of the modified table';

COMMENT ON COLUMN history.logged_actions.transaction_id IS 'Identifier of the transaction (may differ from gid when more than one row is affected by a transaction query)';

COMMENT ON COLUMN history.logged_actions.transaction_time IS 'Timestamp when transaction was started (current_timestamp)';

COMMENT ON COLUMN history.logged_actions.transaction_user IS 'Session user name who caused the transaction';

COMMENT ON COLUMN history.logged_actions.transaction_query IS 'Transaction query';

COMMENT ON COLUMN history.logged_actions.transaction_type IS 'Transaction type (I = insert, D = delete, U = update, T = truncate)';

COMMENT ON COLUMN history.logged_actions.old_record IS 'The old record before the modification containing all the values as hstore (for DELETE and UPDATE statements)';

COMMENT ON COLUMN history.logged_actions.new_record IS 'The new record after the modification containing all the values as hstore (for INSERT and UPDATE statements)';

COMMENT ON COLUMN history.logged_actions.changed_fields IS 'The modified fields only, including the new values, stored as hstore';

ALTER TABLE taxonomy.dic_attribute_type ADD CONSTRAINT fk_dic_attribute_type FOREIGN KEY ( taxonomy_code ) REFERENCES taxonomy.dic_taxonomy( code );

ALTER TABLE taxonomy.dic_attribute_value ADD CONSTRAINT fk_attribute_type_code FOREIGN KEY ( attribute_type_code ) REFERENCES taxonomy.dic_attribute_type( code );

ALTER TABLE taxonomy.dic_hazard ADD CONSTRAINT fk_attribute_type_code FOREIGN KEY ( attribute_type_code ) REFERENCES taxonomy.dic_attribute_type( code );

ALTER TABLE taxonomy.dic_qualifier_value ADD CONSTRAINT fk_dic_qualifier_value FOREIGN KEY ( qualifier_type_code ) REFERENCES taxonomy.dic_qualifier_type( code );

ALTER TABLE object_res1.main_detail ADD CONSTRAINT fk_attribute_type FOREIGN KEY ( attribute_type_code ) REFERENCES taxonomy.dic_attribute_type( code );

ALTER TABLE object_res1.main_detail ADD CONSTRAINT fk_attribute_value FOREIGN KEY ( attribute_value ) REFERENCES taxonomy.dic_attribute_value( attribute_value );

ALTER TABLE object_res1.main_detail ADD CONSTRAINT fk_object_gid FOREIGN KEY ( object_id ) REFERENCES object_res1.main( gid );

ALTER TABLE object_res1.main_detail_qualifier ADD CONSTRAINT fk_detail_gid FOREIGN KEY ( detail_id ) REFERENCES object_res1.main_detail( gid );

ALTER TABLE object_res1.main_detail_qualifier ADD CONSTRAINT fk_qualifier_value FOREIGN KEY ( qualifier_value ) REFERENCES taxonomy.dic_qualifier_value( qualifier_value );

ALTER TABLE object_res1.main_detail_qualifier ADD CONSTRAINT fk_qualifier_type_code FOREIGN KEY ( qualifier_type_code ) REFERENCES taxonomy.dic_qualifier_type( code );

ALTER TABLE object_res2.main_detail ADD CONSTRAINT fk_attribute_type FOREIGN KEY ( attribute_type_code ) REFERENCES taxonomy.dic_attribute_type( code );

ALTER TABLE object_res2.main_detail ADD CONSTRAINT fk_attribute_value FOREIGN KEY ( attribute_value ) REFERENCES taxonomy.dic_attribute_value( attribute_value );

ALTER TABLE object_res2.main_detail ADD CONSTRAINT fk_object_gid FOREIGN KEY ( object_id ) REFERENCES object_res2.main( gid );

ALTER TABLE object_res2.main_detail_qualifier ADD CONSTRAINT fk_detail_gid FOREIGN KEY ( detail_id ) REFERENCES object_res2.main_detail( gid );

ALTER TABLE object_res2.main_detail_qualifier ADD CONSTRAINT fk_qualifier_value FOREIGN KEY ( qualifier_value ) REFERENCES taxonomy.dic_qualifier_value( qualifier_value );

ALTER TABLE object_res2.main_detail_qualifier ADD CONSTRAINT fk_qualifier_type_code FOREIGN KEY ( qualifier_type_code ) REFERENCES taxonomy.dic_qualifier_type( code );

ALTER TABLE object_res3.main_detail ADD CONSTRAINT fk_attribute_type FOREIGN KEY ( attribute_type_code ) REFERENCES taxonomy.dic_attribute_type( code );

ALTER TABLE object_res3.main_detail ADD CONSTRAINT fk_attribute_value FOREIGN KEY ( attribute_value ) REFERENCES taxonomy.dic_attribute_value( attribute_value );

ALTER TABLE object_res3.main_detail ADD CONSTRAINT fk_object_gid FOREIGN KEY ( object_id ) REFERENCES object_res3.main( gid );

ALTER TABLE object_res3.main_detail_qualifier ADD CONSTRAINT fk_detail_gid FOREIGN KEY ( detail_id ) REFERENCES object_res3.main_detail( gid );

ALTER TABLE object_res3.main_detail_qualifier ADD CONSTRAINT fk_qualifier_value FOREIGN KEY ( qualifier_value ) REFERENCES taxonomy.dic_qualifier_value( qualifier_value );

ALTER TABLE object_res3.main_detail_qualifier ADD CONSTRAINT fk_qualifier_type_code FOREIGN KEY ( qualifier_type_code ) REFERENCES taxonomy.dic_qualifier_type( code );

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
-- Name: SENSUM multi-resolution database support
-- Version: 0.9.2
-- Date: 02.12.14
-- Author: M. Wieland
-- DBMS: PostgreSQL9.2 / PostGIS2.0
-- Description: Adds the multi-resolution support to the basic SENSUM data model.
--		1. Create editable views for three resolution levels with basic table structure
--		2. Auto-update resolution ids based on spatial join between resolution levels
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------

-------------------------------------------
-- resolution 1 view (e.g. per-building) --
-------------------------------------------
CREATE OR REPLACE VIEW object_res1.ve_resolution1 AS
SELECT 
a.gid,
a.survey_gid,
a.description,
a.source,
a.accuracy,
a.res2_id,
a.res3_id,
a.the_geom,
b.object_id,
b.attribute_type_code,
b.attribute_value,
b.attribute_numeric_1,
b.attribute_numeric_2,
b.attribute_text_1,
c.detail_id,
c.qualifier_type_code,
c.qualifier_value,
c.qualifier_numeric_1,
c.qualifier_text_1,
c.qualifier_timestamp_1
FROM object_res1.main AS a
JOIN object_res1.main_detail AS b ON (a.gid = b.object_id)
JOIN object_res1.main_detail_qualifier AS c ON (b.gid = c.detail_id)
ORDER BY a.gid ASC;

--------------------------------------------
-- resolution 2 view (e.g. neighbourhood) --
--------------------------------------------
CREATE OR REPLACE VIEW object_res2.ve_resolution2 AS
SELECT 
a.gid,
a.survey_gid,
a.description,
a.source,
a.accuracy,
a.res3_id,
a.the_geom,
b.object_id,
b.attribute_type_code,
b.attribute_value,
b.attribute_numeric_1,
b.attribute_numeric_2,
b.attribute_text_1,
c.detail_id,
c.qualifier_type_code,
c.qualifier_value,
c.qualifier_numeric_1,
c.qualifier_text_1,
c.qualifier_timestamp_1
FROM object_res2.main AS a
JOIN object_res2.main_detail AS b ON (a.gid = b.object_id)
JOIN object_res2.main_detail_qualifier AS c ON (b.gid = c.detail_id)
ORDER BY a.gid ASC;

-----------------------------------------
-- resolution 3 view (e.g. settlement) --
-----------------------------------------
CREATE OR REPLACE VIEW object_res3.ve_resolution3 AS
SELECT 
a.gid,
a.survey_gid,
a.description,
a.source,
a.accuracy,
a.the_geom,
b.attribute_type_code,
b.attribute_value,
b.attribute_numeric_1,
b.attribute_numeric_2,
b.attribute_text_1,
c.detail_id,
c.qualifier_type_code,
c.qualifier_value,
c.qualifier_numeric_1,
c.qualifier_text_1,
c.qualifier_timestamp_1
FROM object_res3.main AS a
JOIN object_res3.main_detail AS b ON (a.gid = b.object_id)
JOIN object_res3.main_detail_qualifier AS c ON (b.gid = c.detail_id)
ORDER BY a.gid ASC;


-------------------------------------
-- make resolution 1 view editable --
-------------------------------------
CREATE OR REPLACE FUNCTION object_res1.edit_resolution_view()
RETURNS TRIGGER AS 
$BODY$
BEGIN
      IF TG_OP = 'INSERT' THEN
       INSERT INTO object_res1.main (gid, survey_gid, description, source, accuracy, res2_id, res3_id, the_geom) VALUES (DEFAULT, NEW.survey_gid, NEW.description, NEW. source, NEW.accuracy, NEW.res2_id, NEW.res3_id, NEW.the_geom);
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value, attribute_numeric_1, attribute_numeric_2, attribute_text_1) VALUES ((SELECT max(gid) FROM object_res1.main), NEW.attribute_type_code, NEW.attribute_value, NEW.attribute_numeric_1, NEW.attribute_numeric_2, NEW.attribute_text_1);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1, qualifier_text_1, qualifier_timestamp_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail), NEW.qualifier_type_code, NEW.qualifier_value, NEW.qualifier_numeric_1, NEW.qualifier_text_1, NEW.qualifier_timestamp_1);
       RETURN NEW;
      ELSIF TG_OP = 'UPDATE' THEN
       UPDATE object_res1.main SET gid=NEW.gid, survey_gid=NEW.survey_gid, description=NEW.description, source=NEW.source, accuracy=NEW.accuracy, res2_id=NEW.res2_id, res3_id=NEW.res3_id, the_geom=NEW.the_geom WHERE gid=OLD.gid;
       UPDATE object_res1.main_detail SET attribute_type_code=NEW.attribute_type_code, attribute_value=NEW.attribute_value, attribute_numeric_1=NEW.attribute_numeric_1, attribute_numeric_2=NEW.attribute_numeric_2, attribute_text_1=NEW.attribute_text_1 WHERE object_id=OLD.gid;
       UPDATE object_res1.main_detail_qualifier SET qualifier_type_code=NEW.qualifier_type_code, qualifier_value=NEW.qualifier_value, qualifier_numeric_1=NEW.qualifier_numeric_1, qualifier_text_1=NEW.qualifier_text_1, qualifier_timestamp_1=NEW.qualifier_timestamp_1 WHERE detail_id=OLD.gid;
       RETURN NEW;
      ELSIF TG_OP = 'DELETE' THEN
       DELETE FROM object_res1.main_detail_qualifier WHERE detail_id IN (SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid);
       DELETE FROM object_res1.main_detail WHERE object_id=OLD.gid;
       DELETE FROM object_res1.main WHERE gid=OLD.gid;
       --workaround to log row information after delete if transaction logging on view is active (because it is not possible to define a AFTER FOR EACH ROW trigger on a view)
       IF EXISTS (SELECT event_object_schema, trigger_name FROM information_schema.triggers WHERE event_object_schema = 'object_res1' AND trigger_name = 'zhistory_trigger_row') THEN
       	       INSERT INTO history.logged_actions VALUES(
	        NEXTVAL('history.logged_actions_gid_seq'),    -- gid
		TG_TABLE_SCHEMA::text,                        -- schema_name
		TG_TABLE_NAME::text,                          -- table_name
		TG_RELID,                                     -- relation OID for much quicker searches
		txid_current(),                               -- transaction_id
		session_user::text,                           -- transaction_user
		current_timestamp,                            -- transaction_time
		NULL,                              	      -- top-level query or queries (if multistatement) from client
		'D',					      -- transaction_type
		hstore(OLD.*), NULL, NULL);                   -- old_record, new_record, changed_fields
	END IF;
       RETURN NULL;
      END IF;
      RETURN NEW;
END;
$BODY$ 
LANGUAGE 'plpgsql';

COMMENT ON FUNCTION object_res1.edit_resolution_view() IS $body$
This function makes the resolution 1 view editable and forwards the edits to the underlying tables.
$body$;

DROP TRIGGER IF EXISTS res1_trigger ON object_res1.ve_resolution1;
CREATE TRIGGER res1_trigger
    INSTEAD OF INSERT OR UPDATE OR DELETE ON object_res1.ve_resolution1 
      FOR EACH ROW 
      EXECUTE PROCEDURE object_res1.edit_resolution_view();


-------------------------------------
-- make resolution 2 view editable --
-------------------------------------
CREATE OR REPLACE FUNCTION object_res2.edit_resolution_view()
RETURNS TRIGGER AS 
$BODY$
BEGIN
      IF TG_OP = 'INSERT' THEN
       INSERT INTO object_res2.main (gid, survey_gid, description, source, accuracy, res3_id, the_geom) VALUES (DEFAULT, NEW.survey_gid, NEW.description, NEW. source, NEW.accuracy, NEW.res3_id, NEW.the_geom);
       INSERT INTO object_res2.main_detail (object_id, attribute_type_code, attribute_value, attribute_numeric_1, attribute_numeric_2, attribute_text_1) VALUES ((SELECT max(gid) FROM object_res2.main), NEW.attribute_type_code, NEW.attribute_value, NEW.attribute_numeric_1, NEW.attribute_numeric_2, NEW.attribute_text_1);
       INSERT INTO object_res2.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1, qualifier_text_1, qualifier_timestamp_1) VALUES ((SELECT max(gid) FROM object_res2.main_detail), NEW.qualifier_type_code, NEW.qualifier_value, NEW.qualifier_numeric_1, NEW.qualifier_text_1, NEW.qualifier_timestamp_1);
       RETURN NEW;
      ELSIF TG_OP = 'UPDATE' THEN
       UPDATE object_res2.main SET gid=NEW.gid, survey_gid=NEW.survey_gid, description=NEW.description, source=NEW.source, accuracy=NEW.accuracy, res3_id=NEW.res3_id, the_geom=NEW.the_geom WHERE gid=OLD.gid;
       UPDATE object_res2.main_detail SET attribute_type_code=NEW.attribute_type_code, attribute_value=NEW.attribute_value, attribute_numeric_1=NEW.attribute_numeric_1, attribute_numeric_2=NEW.attribute_numeric_2, attribute_text_1=NEW.attribute_text_1 WHERE object_id=OLD.gid;
       UPDATE object_res2.main_detail_qualifier SET qualifier_type_code=NEW.qualifier_type_code, qualifier_value=NEW.qualifier_value, qualifier_numeric_1=NEW.qualifier_numeric_1, qualifier_text_1=NEW.qualifier_text_1, qualifier_timestamp_1=NEW.qualifier_timestamp_1 WHERE detail_id=OLD.gid;
       RETURN NEW;
      ELSIF TG_OP = 'DELETE' THEN
       DELETE FROM object_res2.main_detail_qualifier WHERE detail_id IN (SELECT gid FROM object_res2.main_detail WHERE object_id=OLD.gid);
       DELETE FROM object_res2.main_detail WHERE object_id=OLD.gid;
       DELETE FROM object_res2.main WHERE gid=OLD.gid;
       --workaround to log row information after delete if transaction logging on view is active (because it is not possible to define a AFTER FOR EACH ROW trigger on a view)
       IF EXISTS (SELECT event_object_schema, trigger_name FROM information_schema.triggers WHERE event_object_schema = 'object_res2' AND trigger_name = 'zhistory_trigger_row') THEN
	       INSERT INTO history.logged_actions VALUES(
	        NEXTVAL('history.logged_actions_gid_seq'),    -- gid
		TG_TABLE_SCHEMA::text,                        -- schema_name
		TG_TABLE_NAME::text,                          -- table_name
		TG_RELID,                                     -- relation OID for much quicker searches
		txid_current(),                               -- transaction_id
		session_user::text,                           -- transaction_user
		current_timestamp,                            -- transaction_time
		NULL,                              	      -- top-level query or queries (if multistatement) from client
		'D',					      -- transaction_type
		hstore(OLD.*), NULL, NULL);                   -- old_record, new_record, changed_fields
	END IF;
       RETURN NULL;
      END IF;
      RETURN NEW;
END;
$BODY$ 
LANGUAGE 'plpgsql';

COMMENT ON FUNCTION object_res2.edit_resolution_view() IS $body$
This function makes the resolution 2 view editable and forwards the edits to the underlying tables.
$body$;

DROP TRIGGER IF EXISTS res2_trigger ON object_res2.ve_resolution2;
CREATE TRIGGER res2_trigger
    INSTEAD OF INSERT OR UPDATE OR DELETE ON object_res2.ve_resolution2 
      FOR EACH ROW 
      EXECUTE PROCEDURE object_res2.edit_resolution_view();

-------------------------------------
-- make resolution 3 view editable --
-------------------------------------
CREATE OR REPLACE FUNCTION object_res3.edit_resolution_view()
RETURNS TRIGGER AS 
$BODY$
BEGIN
      IF TG_OP = 'INSERT' THEN
       INSERT INTO object_res3.main (gid, survey_gid, description, source, accuracy, the_geom) VALUES (DEFAULT, NEW.survey_gid, NEW.description, NEW. source, NEW.accuracy, NEW.the_geom);
       INSERT INTO object_res3.main_detail (object_id, attribute_type_code, attribute_value, attribute_numeric_1, attribute_numeric_2, attribute_text_1) VALUES ((SELECT max(gid) FROM object_res3.main), NEW.attribute_type_code, NEW.attribute_value, NEW.attribute_numeric_1, NEW.attribute_numeric_2, NEW.attribute_text_1);
       INSERT INTO object_res3.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1, qualifier_text_1, qualifier_timestamp_1) VALUES ((SELECT max(gid) FROM object_res3.main_detail), NEW.qualifier_type_code, NEW.qualifier_value, NEW.qualifier_numeric_1, NEW.qualifier_text_1, NEW.qualifier_timestamp_1);
       RETURN NEW;
      ELSIF TG_OP = 'UPDATE' THEN
       UPDATE object_res3.main SET gid=NEW.gid, survey_gid=NEW.survey_gid, description=NEW.description, source=NEW.source, accuracy=NEW.accuracy, the_geom=NEW.the_geom WHERE gid=OLD.gid;
       UPDATE object_res3.main_detail SET attribute_type_code=NEW.attribute_type_code, attribute_value=NEW.attribute_value, attribute_numeric_1=NEW.attribute_numeric_1, attribute_numeric_2=NEW.attribute_numeric_2, attribute_text_1=NEW.attribute_text_1 WHERE object_id=OLD.gid;
       UPDATE object_res3.main_detail_qualifier SET qualifier_type_code=NEW.qualifier_type_code, qualifier_value=NEW.qualifier_value, qualifier_numeric_1=NEW.qualifier_numeric_1, qualifier_text_1=NEW.qualifier_text_1, qualifier_timestamp_1=NEW.qualifier_timestamp_1 WHERE detail_id=OLD.gid;
       RETURN NEW;
      ELSIF TG_OP = 'DELETE' THEN
       DELETE FROM object_res3.main_detail_qualifier WHERE detail_id IN (SELECT gid FROM object_res3.main_detail WHERE object_id=OLD.gid);
       DELETE FROM object_res3.main_detail WHERE object_id=OLD.gid;
       DELETE FROM object_res3.main WHERE gid=OLD.gid;
       --workaround to log row information after delete if transaction logging on view is active (because it is not possible to define a AFTER FOR EACH ROW trigger on a view)
       IF EXISTS (SELECT event_object_schema, trigger_name FROM information_schema.triggers WHERE event_object_schema = 'object_res3' AND trigger_name = 'zhistory_trigger_row') THEN
	       INSERT INTO history.logged_actions VALUES(
	        NEXTVAL('history.logged_actions_gid_seq'),    -- gid
		TG_TABLE_SCHEMA::text,                        -- schema_name
		TG_TABLE_NAME::text,                          -- table_name
		TG_RELID,                                     -- relation OID for much quicker searches
		txid_current(),                               -- transaction_id
		session_user::text,                           -- transaction_user
		current_timestamp,                            -- transaction_time
		NULL,                              	      -- top-level query or queries (if multistatement) from client
		'D',					      -- transaction_type
		hstore(OLD.*), NULL, NULL);                   -- old_record, new_record, changed_fields
	END IF;
       RETURN NULL;
      END IF;
      RETURN NEW;
END;
$BODY$ 
LANGUAGE 'plpgsql';

COMMENT ON FUNCTION object_res3.edit_resolution_view() IS $body$
This function makes the resolution 3 view editable and forwards the edits to the underlying tables.
$body$;

DROP TRIGGER IF EXISTS res3_trigger ON object_res3.ve_resolution3;
CREATE TRIGGER res3_trigger
    INSTEAD OF INSERT OR UPDATE OR DELETE ON object_res3.ve_resolution3 
      FOR EACH ROW 
      EXECUTE PROCEDURE object_res3.edit_resolution_view();


-----------------------------------------------------------------------------------------
-- Link resolutions: Update once the resolution_ids in case some records already exist --
-----------------------------------------------------------------------------------------
-- Update res2_ids for resolution1 records based on spatial join
UPDATE object_res1.main SET res2_id=a.res2_id 
  FROM (SELECT res2.gid AS res2_id, res1.gid AS res1_id FROM (SELECT gid, the_geom FROM object_res1.main) res1 
    LEFT JOIN (SELECT gid, the_geom FROM object_res2.main) res2 
    ON ST_Contains(res2.the_geom, (SELECT ST_PointOnSurface(res1.the_geom)))) AS a
WHERE object_res1.main.gid=a.res1_id;

-- Update res3_ids for resolution1 records based on spatial join
UPDATE object_res1.main SET res3_id=a.res3_id 
  FROM (SELECT res3.gid AS res3_id, res1.gid AS res1_id FROM (SELECT gid, the_geom FROM object_res1.main) res1
    LEFT JOIN (SELECT gid, the_geom FROM object_res3.main) res3 
    ON ST_Contains(res3.the_geom, (SELECT ST_PointOnSurface(res1.the_geom)))) AS a
WHERE object_res1.main.gid=a.res1_id;

-- Update res3_ids for resolution2 records based on spatial join
UPDATE object_res2.main SET res3_id=a.res3_id 
  FROM (SELECT res3.gid AS res3_id, res2.gid AS res2_id FROM (SELECT gid, the_geom FROM object_res2.main) res2
    LEFT JOIN (SELECT gid, the_geom FROM object_res3.main) res3 
    ON ST_Contains(res3.the_geom, (SELECT ST_PointOnSurface(res2.the_geom)))) AS a
WHERE object_res2.main.gid=a.res2_id;


-----------------------------------------------------------------------------------------
-- Link resolutions: Update resolution_ids on INSERT and UPDATE (main.the_geom) --
-----------------------------------------------------------------------------------------
-- Trigger function and trigger to update resolution_ids for each INSERT and UPDATE OF the_geom ON object_res1.main
CREATE OR REPLACE FUNCTION object_res1.update_resolution_ids() 
RETURNS TRIGGER AS
$BODY$
BEGIN 
     IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN	
	-- Update res2_ids for resolution1 records based on spatial join
	UPDATE object_res1.main SET res2_id=a.res2_id 
	  FROM (SELECT res2.gid AS res2_id, res1.gid AS res1_id FROM (SELECT gid, res2_id, res3_id, the_geom FROM object_res1.main) res1 
	    LEFT JOIN (SELECT gid, the_geom FROM object_res2.main) res2 
	    ON ST_Contains(res2.the_geom, (SELECT ST_PointOnSurface(res1.the_geom))) 
		WHERE res1.gid=NEW.gid	-- if resolution1 record is updated
		OR res1.res2_id=NEW.gid	-- if resolution2 record is updated
		OR res1.res3_id=NEW.gid	-- if resolution3 record is updated
		OR ST_Intersects(res1.the_geom, NEW.the_geom)	-- update ids also for resolution1 records that intersect with the newly updated resolution2 or resolution3 records
		) AS a
	WHERE object_res1.main.gid=a.res1_id OR object_res1.main.gid=NEW.gid;

	-- Update res3_ids for resolution1 records based on spatial join
	UPDATE object_res1.main SET res3_id=a.res3_id 
	  FROM (SELECT res3.gid AS res3_id, res1.gid AS res1_id FROM (SELECT gid, res2_id, res3_id, the_geom FROM object_res1.main) res1
	    LEFT JOIN (SELECT gid, the_geom FROM object_res3.main) res3 
	    ON ST_Contains(res3.the_geom, (SELECT ST_PointOnSurface(res1.the_geom))) 
		WHERE res1.gid=NEW.gid 
		OR res1.res2_id=NEW.gid 
		OR res1.res3_id=NEW.gid 
		OR ST_Intersects(res1.the_geom, NEW.the_geom)
		) AS a
	WHERE object_res1.main.gid=a.res1_id OR object_res1.main.gid=NEW.gid;

	-- Update res3_ids for resolution2 records based on spatial join
	UPDATE object_res2.main SET res3_id=a.res3_id 
	  FROM (SELECT res3.gid AS res3_id, res2.gid AS res2_id FROM (SELECT gid, res3_id, the_geom FROM object_res2.main) res2
	    LEFT JOIN (SELECT gid, the_geom FROM object_res3.main) res3 
	    ON ST_Contains(res3.the_geom, (SELECT ST_PointOnSurface(res2.the_geom))) 
		WHERE res2.gid=NEW.gid 
		OR res2.res3_id=NEW.gid 
		OR ST_Intersects(res2.the_geom, NEW.the_geom)
		) AS a
	WHERE object_res2.main.gid=a.res2_id OR object_res2.main.gid=NEW.gid;
	
     RETURN NEW;

     ELSIF TG_OP = 'DELETE' THEN
	-- Update res2_ids for resolution1 records based on spatial join
	UPDATE object_res1.main SET res2_id=a.res2_id 
	  FROM (SELECT res2.gid AS res2_id, res1.gid AS res1_id FROM (SELECT gid, res2_id, res3_id, the_geom FROM object_res1.main) res1 
	    LEFT JOIN (SELECT gid, the_geom FROM object_res2.main) res2 
	    ON ST_Contains(res2.the_geom, (SELECT ST_PointOnSurface(res1.the_geom))) 
		WHERE res1.res2_id=OLD.gid	-- if resolution2 record is deleted
		OR res1.res3_id=OLD.gid	-- if resolution3 record is deleted
		) AS a
	WHERE object_res1.main.gid=a.res1_id;

	-- Update res3_ids for resolution1 records based on spatial join
	UPDATE object_res1.main SET res3_id=a.res3_id 
	  FROM (SELECT res3.gid AS res3_id, res1.gid AS res1_id FROM (SELECT gid, res2_id, res3_id, the_geom FROM object_res1.main) res1
	    LEFT JOIN (SELECT gid, the_geom FROM object_res3.main) res3 
	    ON ST_Contains(res3.the_geom, (SELECT ST_PointOnSurface(res1.the_geom))) 
		WHERE res1.res2_id=OLD.gid 
		OR res1.res3_id=OLD.gid
		) AS a
	WHERE object_res1.main.gid=a.res1_id;

	-- Update res3_ids for resolution2 records based on spatial join
	UPDATE object_res2.main SET res3_id=a.res3_id 
	  FROM (SELECT res3.gid AS res3_id, res2.gid AS res2_id FROM (SELECT gid, res3_id, the_geom FROM object_res2.main) res2
	    LEFT JOIN (SELECT gid, the_geom FROM object_res3.main) res3 
	    ON ST_Contains(res3.the_geom, (SELECT ST_PointOnSurface(res2.the_geom))) 
		WHERE res2.gid=OLD.gid 
		OR res2.res3_id=OLD.gid 
		OR ST_Intersects(res2.the_geom, OLD.the_geom)
		) AS a
	WHERE object_res2.main.gid=a.res2_id;
     
     RETURN NULL;

     END IF;
     RETURN NEW;
END;
$BODY$
LANGUAGE 'plpgsql';

COMMENT ON FUNCTION object_res1.update_resolution_ids() IS $body$
This function updates the resolution_ids for an object when its geometry is updated or an object is inserted or deleted.
$body$;

DROP TRIGGER IF EXISTS resolution_id_trigger ON object_res1.main;
CREATE TRIGGER resolution_id_trigger
    AFTER INSERT OR UPDATE OF the_geom ON object_res1.main 
      FOR EACH ROW 
      WHEN (pg_trigger_depth() = 1)	-- current nesting level of trigger (1 if called once from inside a trigger)
      EXECUTE PROCEDURE object_res1.update_resolution_ids();

DROP TRIGGER IF EXISTS resolution_id_trigger_del ON object_res1.main;
CREATE TRIGGER resolution_id_trigger_del
    AFTER DELETE ON object_res1.main 
      FOR EACH ROW 
      WHEN (pg_trigger_depth() = 1)	-- current nesting level of trigger (1 if called once from inside a trigger)
      EXECUTE PROCEDURE object_res1.update_resolution_ids();

DROP TRIGGER IF EXISTS resolution_id_trigger ON object_res2.main;
CREATE TRIGGER resolution_id_trigger
    AFTER INSERT OR UPDATE OF the_geom ON object_res2.main 
      FOR EACH ROW 
      WHEN (pg_trigger_depth() = 1)	-- current nesting level of trigger (1 if called once from inside a trigger)
      EXECUTE PROCEDURE object_res1.update_resolution_ids();

DROP TRIGGER IF EXISTS resolution_id_trigger_del ON object_res2.main;
CREATE TRIGGER resolution_id_trigger_del
    AFTER DELETE ON object_res2.main 
      FOR EACH ROW 
      WHEN (pg_trigger_depth() = 1)	-- current nesting level of trigger (1 if called once from inside a trigger)
      EXECUTE PROCEDURE object_res1.update_resolution_ids();

DROP TRIGGER IF EXISTS resolution_id_trigger ON object_res3.main;
CREATE TRIGGER resolution_id_trigger
    AFTER INSERT OR UPDATE OF the_geom ON object_res3.main 
      FOR EACH ROW 
      WHEN (pg_trigger_depth() = 1)	-- current nesting level of trigger (1 if called once from inside a trigger)
      EXECUTE PROCEDURE object_res1.update_resolution_ids();

DROP TRIGGER IF EXISTS resolution_id_trigger_del ON object_res3.main;
CREATE TRIGGER resolution_id_trigger_del
    AFTER DELETE ON object_res3.main 
      FOR EACH ROW 
      WHEN (pg_trigger_depth() = 1)	-- current nesting level of trigger (1 if called once from inside a trigger)
      EXECUTE PROCEDURE object_res1.update_resolution_ids();

----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
-- Name: SENSUM multi-temporal database support
-- Version: 0.91
-- Date: 03.08.14
-- Author: M. Wieland
-- DBMS: PostgreSQL9.2 / PostGIS2.0
-- Description: Adds the multi-temporal support to the basic SENSUM data model.
--		1. Adds trigger functions to log database transactions for selected tables or views
--		   (reference: http://wiki.postgresql.org/wiki/Audit_trigger_91plus)
--		2. Adds temporal query functions for transaction time and valid time
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------

------------------------------------------------
-- Create trigger function to log transactions--
------------------------------------------------
CREATE OR REPLACE FUNCTION history.if_modified() 
RETURNS TRIGGER AS 
$body$
DECLARE
    history_row history.logged_actions;
    include_values BOOLEAN;
    log_diffs BOOLEAN;
    h_old hstore;
    h_new hstore;
    excluded_cols text[] = ARRAY[]::text[];
BEGIN
    history_row = ROW(
        NEXTVAL('history.logged_actions_gid_seq'),    -- gid
        TG_TABLE_SCHEMA::text,                        -- schema_name
        TG_TABLE_NAME::text,                          -- table_name
        TG_RELID,                                     -- relation OID for much quicker searches
        txid_current(),                               -- transaction_id
        session_user::text,                           -- transaction_user
        current_timestamp,                            -- transaction_time
        current_query(),                              -- top-level query or queries (if multistatement) from client
        substring(TG_OP,1,1),                         -- transaction_type
        NULL, NULL, NULL                             -- old_record, new_record, changed_fields
        );
 
    IF NOT TG_ARGV[0]::BOOLEAN IS DISTINCT FROM 'f'::BOOLEAN THEN
        history_row.transaction_query = NULL;
    END IF;
 
    IF TG_ARGV[1] IS NOT NULL THEN
        excluded_cols = TG_ARGV[1]::text[];
    END IF;
 
    IF (TG_OP = 'UPDATE' AND TG_LEVEL = 'ROW') THEN
	history_row.old_record = hstore(OLD.*);
        history_row.new_record = hstore(NEW.*);
        history_row.changed_fields = (hstore(NEW.*) - history_row.old_record) - excluded_cols;
        IF history_row.changed_fields = hstore('') THEN
        -- All changed fields are ignored. Skip this update.
            RETURN NULL;
        END IF;
    ELSIF (TG_OP = 'DELETE' AND TG_LEVEL = 'ROW') THEN
	history_row.old_record = hstore(OLD.*);
    ELSIF (TG_OP = 'INSERT' AND TG_LEVEL = 'ROW') THEN
	history_row.new_record = hstore(NEW.*);
    ELSE
        RAISE EXCEPTION '[history.if_modified_func] - Trigger func added as trigger for unhandled case: %, %',TG_OP, TG_LEVEL;
        RETURN NULL;
    END IF;
    INSERT INTO history.logged_actions VALUES (history_row.*);
    RETURN NULL;
END;
$body$
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public;

COMMENT ON FUNCTION history.if_modified() IS $body$
Track changes TO a TABLE or a VIEW at the row level.
Optional parameters TO TRIGGER IN CREATE TRIGGER call:
param 0: BOOLEAN, whether TO log the query text. DEFAULT 't'.
param 1: text[], COLUMNS TO IGNORE IN updates. DEFAULT [].

         Note: Updates TO ignored cols are included in new_record.
         Updates WITH only ignored cols changed are NOT inserted
         INTO the history log.
         There IS no parameter TO disable logging of VALUES. ADD this TRIGGER AS
         a 'FOR EACH STATEMENT' rather than 'FOR EACH ROW' TRIGGER IF you do NOT
         want TO log row VALUES.
$body$;

-------------------------------------------------------------------------------------------
-- Create trigger function to update inserts in logged transactions when a view is logged--
-------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION history.if_modified_view()
RETURNS TRIGGER AS 
$BODY$
DECLARE
    tbl regclass;
BEGIN
    IF NEW.transaction_type = 'I' THEN
	FOR tbl IN
	    --get table name
	    SELECT schema_name::text || '.' || table_name::text FROM history.logged_actions WHERE gid=(SELECT max(gid) FROM history.logged_actions)
	LOOP
	    EXECUTE '
	    UPDATE history.logged_actions SET 
		new_record = (SELECT hstore('|| tbl ||'.*) FROM '|| tbl ||' WHERE gid=(SELECT max(gid) FROM '|| tbl ||' ))
		WHERE gid=(SELECT max(gid) FROM history.logged_actions);
	    ';
	END LOOP;
    END IF;
    RETURN NULL;
END;
$BODY$
LANGUAGE plpgsql;
COMMENT ON FUNCTION history.if_modified_view() IS $body$
This function updates the gid of a view in the logged actions table for the INSERT statement.
$body$;

---------------------------------------------------------------------------------
-- Create function to activate transaction logging for a specific table or view--
---------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION history.history_table(target_table regclass, history_view BOOLEAN, history_query_text BOOLEAN, ignored_cols text[]) 
RETURNS void AS 
$body$
DECLARE
  _q_txt text;
  _ignored_cols_snip text = '';
BEGIN
    IF history_view THEN
	    --create trigger on view (use instead of trigger) - note: in case of multiple triggers on the same table/view the execution order is alphabetical
	    IF array_length(ignored_cols,1) > 0 THEN
		_ignored_cols_snip = ', ' || quote_literal(ignored_cols);
	    END IF;
	    
	    EXECUTE 'DROP TRIGGER IF EXISTS zhistory_trigger_row ON ' || target_table::text;
	    _q_txt = 'CREATE TRIGGER zhistory_trigger_row INSTEAD OF INSERT OR UPDATE ON ' ||
		     target_table::text ||
		     ' FOR EACH ROW EXECUTE PROCEDURE history.if_modified(' || 
			quote_literal(history_query_text) || _ignored_cols_snip || ');';
	    RAISE NOTICE '%',_q_txt;
	    EXECUTE _q_txt;
	    --workaround to update all columns after insert on view (instead of trigger on view does not capture all inserts like gid)
	    EXECUTE 'DROP TRIGGER IF EXISTS zhistory_trigger_row_modified ON history.logged_actions';
	    _q_txt = 'CREATE TRIGGER zhistory_trigger_row_modified AFTER INSERT ON history.logged_actions 
			FOR EACH ROW EXECUTE PROCEDURE history.if_modified_view();';
	    RAISE NOTICE '%',_q_txt;
	    EXECUTE _q_txt;
    ELSE
	    --create trigger on table (use after trigger)
	    IF array_length(ignored_cols,1) > 0 THEN
		_ignored_cols_snip = ', ' || quote_literal(ignored_cols);
	    END IF;

	    EXECUTE 'DROP TRIGGER IF EXISTS history_trigger_row ON ' || target_table::text;
            _q_txt = 'CREATE TRIGGER history_trigger_row AFTER INSERT OR UPDATE OR DELETE ON ' || 
                     target_table::text || 
                     ' FOR EACH ROW EXECUTE PROCEDURE history.if_modified(' ||
                     quote_literal(history_query_text) || _ignored_cols_snip || ');';
            RAISE NOTICE '%',_q_txt;
            EXECUTE _q_txt;
    END IF;
END;
$body$
LANGUAGE 'plpgsql';
 
COMMENT ON FUNCTION history.history_table(regclass, BOOLEAN, BOOLEAN, text[]) IS $body$
ADD transaction logging support TO a TABLE.

Arguments:
   target_table:       TABLE name, schema qualified IF NOT ON search_path
   history_view:       Activate trigger for view (true) or for table (false)
   history_query_text: Record the text of the client query that triggered the history event?
   ignored_cols:       COLUMNS TO exclude FROM UPDATE diffs, IGNORE updates that CHANGE only ignored cols.
$body$;

---------------------------------------------------------------------------------
-- Provide a wrapper because Pg does not allow variadic calls with 0 parameters--
---------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION history.history_table(target_table regclass, history_view BOOLEAN, history_query_text BOOLEAN) 
RETURNS void AS 
$body$
SELECT history.history_table($1, $2, $3, ARRAY[]::text[]);
$body$ 
LANGUAGE SQL;

------------------------------------------------------------------------------------------------------------------------------------------
-- Provide a convenience call wrapper for the simplest case (row-level logging on table with no excluded cols and query logging enabled)--
------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION history.history_table(target_table regclass) 
RETURNS void AS 
$$
SELECT history.history_table($1, BOOLEAN 'f', BOOLEAN 't');
$$ 
LANGUAGE 'sql';
 
COMMENT ON FUNCTION history.history_table(regclass) IS $body$
ADD auditing support TO the given TABLE. Row-level changes will be logged WITH FULL query text. No cols are ignored.
$body$;

------------------------------------------------------
-- Add transaction time query function (getHistory) --
------------------------------------------------------
CREATE OR REPLACE FUNCTION history.ttime_gethistory(tbl character varying)
RETURNS SETOF RECORD AS
$BODY$
BEGIN
    RETURN QUERY EXECUTE '
	--query1: query new_record column to get the UPDATE and INSERT records
	(SELECT (populate_record(null::' ||tbl|| ', b.new_record)).*, b.transaction_time, b.transaction_type FROM history.logged_actions AS b 
		WHERE b.table_name = split_part('''||tbl||''', ''.'', 2) 
		AND b.transaction_type=''U''
		OR b.table_name = split_part('''||tbl||''', ''.'', 2) 
		AND b.transaction_type=''I''
	ORDER BY b.transaction_time DESC)	

	UNION ALL

	--query2: query old_record column to get the DELETE records
	(SELECT (populate_record(null::' ||tbl|| ', b.old_record)).*, b.transaction_time, b.transaction_type FROM history.logged_actions AS b 
		WHERE b.table_name = split_part('''||tbl||''', ''.'', 2) 
		AND b.transaction_type=''D''
	ORDER BY b.transaction_time DESC);
	';
END;
$BODY$
LANGUAGE plpgsql;
COMMENT ON FUNCTION history.ttime_gethistory(tbl character varying) IS $body$
This function searches history.logged_actions to get all transactions of object primitives. Results table structure needs to be defined manually. Returns set of records.
Arguments:
   tbl:		schema.table character varying
$body$;

--Convenience call wrapper that gets dynamic column structure of results and writes them to view
CREATE OR REPLACE FUNCTION history.ttime_gethistory(tbl_in character varying, tbl_out character varying)
RETURNS void AS 
$BODY$
DECLARE 
  tbl_struct text;
BEGIN
tbl_struct := string_agg(column_name || ' ' || udt_name, ',') FROM information_schema.columns WHERE table_name = split_part(tbl_in, '.', 2);
EXECUTE '
	CREATE OR REPLACE VIEW '|| tbl_out ||' AS
		SELECT ROW_NUMBER() OVER (ORDER BY transaction_timestamp ASC) AS rowid, * 
		FROM history.ttime_gethistory('''|| tbl_in ||''') 
			main ('|| tbl_struct ||', transaction_timestamp timestamptz, transaction_type text);
	';
END;
$BODY$  
LANGUAGE plpgsql;
COMMENT ON FUNCTION history.ttime_gethistory(tbl_in character varying, tbl_out character varying) IS $body$
This function searches history.logged_actions to get all transactions of object primitives. Results table structure is defined dynamically from input table/view. Returns view.
Arguments:
   tbl_in:		schema.table character varying
   tbl_out:		schema.table character varying
$body$;

-------------------------------------------------
-- Add transaction time query function (Equal) --
-------------------------------------------------
CREATE OR REPLACE FUNCTION history.ttime_equal(tbl character varying, ttime timestamp)
RETURNS SETOF RECORD AS
$BODY$
BEGIN
    RETURN QUERY EXECUTE '
	--query1: query new_record column to get the UPDATE and INSERT records
	(SELECT (populate_record(null::'||tbl||', b.new_record)).*, b.transaction_time, b.transaction_type FROM history.logged_actions AS b 
		WHERE b.table_name = split_part('''||tbl||''', ''.'', 2) 
		AND b.transaction_time = '''||ttime||''' 
		AND b.transaction_type = ''U''
	OR b.table_name = split_part('''||tbl||''', ''.'', 2) AND b.transaction_time = '''||ttime||''' AND b.transaction_type = ''I''
	ORDER BY b.new_record->''gid'', b.transaction_time DESC)
	
	UNION ALL

	--query2: query old_record column to get the DELETE records
	(SELECT (populate_record(null::'||tbl||', b.old_record)).*, b.transaction_time, b.transaction_type FROM history.logged_actions AS b 
		WHERE b.table_name = split_part('''||tbl||''', ''.'', 2) 
		AND b.transaction_time = '''||ttime||''' 
		AND b.transaction_type = ''D''
	ORDER BY b.old_record->''gid'', b.transaction_time DESC);
	';
END;
$BODY$
LANGUAGE plpgsql;
COMMENT ON FUNCTION history.ttime_equal(tbl character varying, ttime timestamp) IS $body$
This function searches history.logged_actions to get the latest version of each object primitive whose transaction time equals the queried timestamp.
Arguments:
   tbl:		schema.table character varying
   ttime:	transaction time yyy-mm-dd hh:mm:ss
$body$;

--Convenience call wrapper that gets dynamic column structure of results and writes them to view
CREATE OR REPLACE FUNCTION history.ttime_equal(tbl_in character varying, tbl_out character varying, ttime timestamp)
RETURNS void AS 
$BODY$
DECLARE 
  tbl_struct text;
BEGIN
tbl_struct := string_agg(column_name || ' ' || udt_name, ',') FROM information_schema.columns WHERE table_name = split_part(tbl_in, '.', 2);
EXECUTE '
	CREATE OR REPLACE VIEW '|| tbl_out ||' AS
		SELECT ROW_NUMBER() OVER (ORDER BY transaction_timestamp ASC) AS rowid, * 
		FROM history.ttime_equal('''|| tbl_in ||''', '''|| ttime ||''') 
			main ('|| tbl_struct ||', transaction_timestamp timestamptz, transaction_type text);
	';
END;
$BODY$  
LANGUAGE plpgsql;
COMMENT ON FUNCTION history.ttime_equal(tbl_in character varying, tbl_out character varying, ttime timestamp) IS $body$
This function searches history.logged_actions to get the latest version of each object primitive whose transaction time equals the queried timestamp. 
Results table structure is defined dynamically from input table/view. Returns view.
Arguments:
   tbl_in:		schema.table character varying
   tbl_out:		schema.table character varying
   ttime:	transaction time yyy-mm-dd hh:mm:ss
$body$;

--------------------------------------------------
-- Add transaction time query function (Inside) --
--------------------------------------------------
CREATE OR REPLACE FUNCTION history.ttime_inside(tbl character varying, ttime_from timestamp DEFAULT '0001-01-01 00:00:00', ttime_to timestamp DEFAULT now()) 
RETURNS SETOF RECORD AS
$BODY$
BEGIN
    RETURN QUERY EXECUTE '
	--query1: query new_record column to get the UPDATE and INSERT objects
	(SELECT (populate_record(null::'||tbl||', b.new_record)).*, b.transaction_time, b.transaction_type FROM history.logged_actions AS b 
		WHERE b.table_name = split_part('''||tbl||''', ''.'', 2) 
		AND b.transaction_time >= '''||ttime_from||''' AND b.transaction_time <= '''||ttime_to||''' 
		AND b.transaction_type = ''U''
		OR b.table_name = split_part('''||tbl||''', ''.'', 2) 
		AND b.transaction_time >= '''||ttime_from||''' 
		AND b.transaction_time <= '''||ttime_to||''' 
		AND b.transaction_type = ''I''
	ORDER BY b.new_record->''gid'', b.transaction_time DESC)
	
	UNION ALL

	--query2: query old_record column to get the DELETE objects
	(SELECT (populate_record(null::'||tbl||', b.old_record)).*, b.transaction_time, b.transaction_type FROM history.logged_actions AS b 
		WHERE b.table_name = split_part('''||tbl||''', ''.'', 2) 
		AND b.transaction_time >= '''||ttime_from||''' AND b.transaction_time <= '''||ttime_to||''' 
		AND b.transaction_type = ''D''
	ORDER BY b.old_record->''gid'', b.transaction_time DESC);
	';
END;
$BODY$
LANGUAGE plpgsql;
COMMENT ON FUNCTION history.ttime_inside(tbl character varying, ttime_from timestamp, ttime_to timestamp) IS $body$
This function searches history.logged_actions to get the latest version of each object primitive that has been modified only within the queried transaction time.
Results table structure needs to be defined manually. Returns set of records.
Arguments:
   tbl:		schema.table character varying
   ttime_from:	transaction time from yyy-mm-dd hh:mm:ss
   ttime_to:	transaction time to yyy-mm-dd hh:mm:ss
$body$;

--Convenience call wrapper that gets dynamic column structure of results and writes them to view
CREATE OR REPLACE FUNCTION history.ttime_inside(tbl_in character varying, tbl_out character varying, ttime_from timestamp, ttime_to timestamp)
RETURNS void AS 
$BODY$
DECLARE 
  tbl_struct text;
BEGIN
tbl_struct := string_agg(column_name || ' ' || udt_name, ',') FROM information_schema.columns WHERE table_name = split_part(tbl_in, '.', 2);
EXECUTE '
	CREATE OR REPLACE VIEW '|| tbl_out ||' AS
		SELECT ROW_NUMBER() OVER (ORDER BY transaction_timestamp ASC) AS rowid, * 
		FROM history.ttime_inside('''|| tbl_in ||''', '''|| ttime_from ||''', '''|| ttime_to ||''') 
			main ('|| tbl_struct ||', transaction_timestamp timestamptz, transaction_type text);
	';
END;
$BODY$  
LANGUAGE plpgsql;
COMMENT ON FUNCTION history.ttime_inside(tbl_in character varying, tbl_out character varying, ttime_from timestamp, ttime_to timestamp) IS $body$
This function searches history.logged_actions to get the latest version of each object primitive that has been modified only within the queried transaction time.
Results table structure is defined dynamically from input table/view. Returns view.
Arguments:
   tbl_in:		schema.table character varying
   tbl_out:		schema.table character varying
   ttime_from:	transaction time from yyy-mm-dd hh:mm:ss
   ttime_to:	transaction time to yyy-mm-dd hh:mm:ss
$body$;

------------------------------------------------
-- Add valid time query function (getHistory) --
------------------------------------------------
CREATE OR REPLACE FUNCTION history.vtime_gethistory(tbl character varying, col_value character varying, col_vtime character varying)
RETURNS SETOF RECORD AS
$BODY$
BEGIN
    RETURN QUERY EXECUTE '
	--query1: query new_record column to get the INSERT records
	(SELECT DISTINCT ON (b.new_record->''gid'') (populate_record(null::' ||tbl|| ', b.new_record)).*, b.transaction_time, b.transaction_type FROM history.logged_actions AS b 
		WHERE b.table_name = split_part('''||tbl||''', ''.'', 2) 
		AND (populate_record(null::' ||tbl|| ', b.new_record)).'||col_value||'=''BUILT'' 
	ORDER BY b.new_record->''gid'', b.transaction_time DESC)

	UNION ALL

	--query2: query new_record column to get the UPDATE records
	(SELECT DISTINCT ON (b.new_record->''gid'', b.new_record->'''||col_vtime||''') (populate_record(null::' ||tbl|| ', b.new_record)).*, b.transaction_time, b.transaction_type FROM history.logged_actions AS b 
		WHERE b.table_name = split_part('''||tbl||''', ''.'', 2) 
		AND (populate_record(null::' ||tbl|| ', b.new_record)).'||col_value||'=''MODIF''
	ORDER BY b.new_record->''gid'', b.new_record->'''||col_vtime||''', b.transaction_time DESC)

	UNION ALL
	
	--query3: query old_record column to get the DELETE records
	(SELECT DISTINCT ON (b.old_record->''gid'') (populate_record(null::' ||tbl|| ', b.old_record)).*, b.transaction_time, b.transaction_type FROM history.logged_actions AS b 
		WHERE b.table_name = split_part('''||tbl||''', ''.'', 2) 
		AND (populate_record(null::' ||tbl|| ', b.old_record)).'||col_value||'=''DESTR'' 
	ORDER BY b.old_record->''gid'', b.transaction_time DESC)
	';
END;
$BODY$
LANGUAGE plpgsql;
COMMENT ON FUNCTION history.vtime_gethistory(tbl character varying, col_value character varying, col_vtime character varying) IS $body$
This function searches history.logged_actions to get all real world changes with the corresponding latest version for each object primitive at each valid time.
Results table structure needs to be defined manually. Returns set of records.

Arguments:
   tbl:			table/view that holds the valid time columns character varying
   col_value:		column that holds the qualifier values (BUILT, MODIF, DESTR) character varying
   col_vtime:		column that holds the actual valid time character varying
$body$;

--Convenience call wrapper that gets dynamic column structure of results and writes them to view
CREATE OR REPLACE FUNCTION history.vtime_gethistory(tbl_in character varying, tbl_out character varying, col_value character varying, col_vtime character varying)
RETURNS void AS 
$BODY$
DECLARE 
  tbl_struct text;
BEGIN
tbl_struct := string_agg(column_name || ' ' || udt_name, ',') FROM information_schema.columns WHERE table_name = split_part(tbl_in, '.', 2);
EXECUTE '
	CREATE OR REPLACE VIEW '|| tbl_out ||' AS
		SELECT ROW_NUMBER() OVER (ORDER BY transaction_timestamp ASC) AS rowid, * 
		FROM history.vtime_gethistory('''|| tbl_in ||''', '''|| col_value ||''', '''|| col_vtime ||''') 
			main ('|| tbl_struct ||', transaction_timestamp timestamptz, transaction_type text);
	';
END;
$BODY$  
LANGUAGE plpgsql;
COMMENT ON FUNCTION history.vtime_gethistory(tbl_in character varying, tbl_out character varying, col_value character varying, col_vtime character varying) IS $body$
This function searches history.logged_actions to get all real world changes with the corresponding latest version for each object primitive at each valid time.
Results table structure is defined dynamically from input table/view. Returns view.
Arguments:
   tbl_in:		schema.table character varying
   tbl_out:		schema.table character varying
   col_value:		column that holds the qualifier values (BUILT, MODIF, DESTR) character varying
   col_vtime:		column that holds the actual valid time character varying
$body$;


-----------------------------------------------
-- Add valid time query function (Intersect) --
-----------------------------------------------
CREATE OR REPLACE FUNCTION history.vtime_intersect(tbl character varying, col_value character varying, col_vtime character varying, vtime_from text DEFAULT '0001-01-01 00:00:00', vtime_to text DEFAULT now())
RETURNS SETOF RECORD AS
$BODY$
BEGIN
    RETURN QUERY EXECUTE '
	SELECT DISTINCT ON (a.gid) * FROM (
		--query1: query new_record column to get the INSERT records
		(SELECT DISTINCT ON (b.new_record->''gid'') (populate_record(null::' ||tbl|| ', b.new_record)).*, b.transaction_time, b.transaction_type FROM history.logged_actions AS b 
			WHERE b.table_name = split_part('''||tbl||''', ''.'', 2) 
			AND (populate_record(null::' ||tbl|| ', b.new_record)).'||col_value||'=''BUILT'' 
			AND b.new_record->'''||col_vtime||''' <= '''||vtime_to||''' AND b.new_record->'''||col_vtime||''' >= '''||vtime_from||'''
		ORDER BY b.new_record->''gid'', b.transaction_time DESC)

		UNION ALL

		--query2: query new_record column to get the UPDATE records
		(SELECT DISTINCT ON (b.new_record->''gid'', b.new_record->'''||col_vtime||''') (populate_record(null::' ||tbl|| ', b.new_record)).*, b.transaction_time, b.transaction_type FROM history.logged_actions AS b 
			WHERE b.table_name = split_part('''||tbl||''', ''.'', 2) 
			AND (populate_record(null::' ||tbl|| ', b.new_record)).'||col_value||'=''MODIF''
			AND b.new_record->'''||col_vtime||''' <= '''||vtime_to||''' AND b.new_record->'''||col_vtime||''' >= '''||vtime_from||'''
		ORDER BY b.new_record->''gid'', b.new_record->'''||col_vtime||''', b.transaction_time DESC)

		UNION ALL
		
		--query3: query old_record column to get the DELETE records
		(SELECT DISTINCT ON (b.old_record->''gid'') (populate_record(null::' ||tbl|| ', b.old_record)).*, b.transaction_time, b.transaction_type FROM history.logged_actions AS b 
			WHERE b.table_name = split_part('''||tbl||''', ''.'', 2) 
			AND (populate_record(null::' ||tbl|| ', b.old_record)).'||col_value||'=''DESTR'' 
			AND b.old_record->'''||col_vtime||''' <= '''||vtime_to||''' AND b.old_record->'''||col_vtime||''' >= '''||vtime_from||'''
		ORDER BY b.old_record->''gid'', b.transaction_time DESC)
	) a ORDER BY a.gid, a.'||col_vtime||' DESC;
	';
END;
$BODY$
LANGUAGE plpgsql;
COMMENT ON FUNCTION history.vtime_intersect(tbl character varying, col_value character varying, col_vtime character varying, vtime_from text, vtime_to text) IS $body$
This function searches history.logged_actions to get the latest version of each object primitive whose valid time intersects with the queried timerange.
Results table structure needs to be defined manually. Returns set of records.

Arguments:
   tbl:			table/view that holds the valid time columns character varying
   col_value:		column that holds the qualifier values (BUILT, MODIF, DESTR) character varying
   col_vtime:		column that holds the actual valid time character varying
   vtime_from:		valid time from text
   vtime_to:		valid time to text
$body$;

--Convenience call wrapper that gets dynamic column structure of results and writes them to view
CREATE OR REPLACE FUNCTION history.vtime_intersect(tbl_in character varying, tbl_out character varying, col_value character varying, col_vtime character varying, vtime_from text DEFAULT '0001-01-01 00:00:00', vtime_to text DEFAULT now())
RETURNS void AS 
$BODY$
DECLARE 
  tbl_struct text;
BEGIN
tbl_struct := string_agg(column_name || ' ' || udt_name, ',') FROM information_schema.columns WHERE table_name = split_part(tbl_in, '.', 2);
EXECUTE '
	CREATE OR REPLACE VIEW '|| tbl_out ||' AS
		SELECT ROW_NUMBER() OVER (ORDER BY transaction_timestamp ASC) AS rowid, * 
		FROM history.vtime_intersect('''|| tbl_in ||''', '''|| col_value ||''', '''|| col_vtime ||''', '''|| vtime_from ||''', '''|| vtime_to ||''') 
			main ('|| tbl_struct ||', transaction_timestamp timestamptz, transaction_type text);
	';
END;
$BODY$  
LANGUAGE plpgsql;
COMMENT ON FUNCTION history.vtime_intersect(tbl_in character varying, tbl_out character varying, col_value character varying, col_vtime character varying, vtime_from text, vtime_to text) IS $body$
This function searches history.logged_actions to get the latest version of each object primitive whose valid time intersects with the queried timerange.
Results table structure is defined dynamically from input table/view. Returns view.
Arguments:
   tbl_in:		schema.table character varying
   tbl_out:		schema.table character varying
   col_value:		column that holds the qualifier values (BUILT, MODIF, DESTR) character varying
   col_vtime:		column that holds the actual valid time character varying
   vtime_from:		valid time from text
   vtime_to:		valid time to text
$body$;


--------------------------------------------
-- Add valid time query function (Inside) --
--------------------------------------------
CREATE OR REPLACE FUNCTION history.vtime_inside(tbl character varying, col_value character varying, col_vtime character varying, vtime_from text DEFAULT '0001-01-01 00:00:00', vtime_to text DEFAULT now())
RETURNS SETOF RECORD AS
$BODY$
BEGIN
    RETURN QUERY EXECUTE '
	SELECT DISTINCT ON (a.gid) * FROM (
		--query1: query old_record (from) and new_record (to) column to get the INSERT records
		(SELECT DISTINCT ON (b.old_record->''gid'') (populate_record(null::' ||tbl|| ', b.old_record)).*, (populate_record(null::' ||tbl|| ', b.old_record)).'||col_vtime||' as vtime_from, (populate_record(null::' ||tbl|| ', b.new_record)).'||col_vtime||' as vtime_to, b.transaction_time, b.transaction_type FROM history.logged_actions AS b 
			WHERE b.table_name = split_part('''||tbl||''', ''.'', 2) 
			AND (populate_record(null::' ||tbl|| ', b.old_record)).'||col_value||'=''BUILT''
			AND exist(b.changed_fields,'''||col_vtime||''') 
			AND b.new_record->'''||col_vtime||''' <= '''||vtime_to||''' AND b.old_record->'''||col_vtime||''' >= '''||vtime_from||'''
		ORDER BY b.old_record->''gid'', b.transaction_time DESC)

		UNION ALL

		--query2: query old_record (from) and new_record (to) column to get the UPDATE records
		(SELECT DISTINCT ON (b.old_record->''gid'', b.old_record->'''||col_vtime||''') (populate_record(null::' ||tbl|| ', b.old_record)).*, (populate_record(null::' ||tbl|| ', b.old_record)).'||col_vtime||' as vtime_from, (populate_record(null::' ||tbl|| ', b.new_record)).'||col_vtime||' as vtime_to, b.transaction_time, b.transaction_type FROM history.logged_actions AS b 
			WHERE b.table_name = split_part('''||tbl||''', ''.'', 2) 
			AND (populate_record(null::' ||tbl|| ', b.old_record)).'||col_value||'=''MODIF''
			AND exist(b.changed_fields,'''||col_vtime||''')
			AND b.new_record->'''||col_vtime||''' <= '''||vtime_to||''' AND b.old_record->'''||col_vtime||''' >= '''||vtime_from||'''
		ORDER BY b.old_record->''gid'', b.old_record->'''||col_vtime||''', b.transaction_time DESC)

		UNION ALL
		
		--query3: query old_record (from) and new_record (to) column to get the DELETE records
		(SELECT DISTINCT ON (b.new_record->''gid'') (populate_record(null::' ||tbl|| ', b.new_record)).*, (populate_record(null::' ||tbl|| ', b.old_record)).'||col_vtime||' as vtime_from, (populate_record(null::' ||tbl|| ', b.new_record)).'||col_vtime||' as vtime_to, b.transaction_time, b.transaction_type FROM history.logged_actions AS b 
			WHERE b.table_name = split_part('''||tbl||''', ''.'', 2) 
			AND (populate_record(null::' ||tbl|| ', b.new_record)).'||col_value||'=''DESTR'' 
			AND exist(b.changed_fields,'''||col_vtime||''') 
			AND b.new_record->'''||col_vtime||''' <= '''||vtime_to||''' AND b.old_record->'''||col_vtime||''' >= '''||vtime_from||'''
		ORDER BY b.new_record->''gid'', b.transaction_time DESC)
	) a ORDER BY a.gid, a.'||col_vtime||' DESC;
	';
END;
$BODY$
LANGUAGE plpgsql;
COMMENT ON FUNCTION history.vtime_inside(tbl character varying, col_value character varying, col_vtime character varying, vtime_from text, vtime_to text) IS $body$
This function searches history.logged_actions to get the latest version of each object primitive whose valid time is completely inside the queried timerange.
Results table structure needs to be defined manually. Returns set of records.

Arguments:
   tbl:			table/view that holds the valid time columns character varying
   col_value:		column that holds the qualifier values (BUILT, MODIF, DESTR) character varying
   col_vtime:		column that holds the actual valid time character varying
   vtime_from:		valid time from text
   vtime_to:		valid time to text
$body$;

--Convenience call wrapper that gets dynamic column structure of results and writes them to view
CREATE OR REPLACE FUNCTION history.vtime_inside(tbl_in character varying, tbl_out character varying, col_value character varying, col_vtime character varying, vtime_from text DEFAULT '0001-01-01 00:00:00', vtime_to text DEFAULT now())
RETURNS void AS 
$BODY$
DECLARE 
  tbl_struct text;
BEGIN
tbl_struct := string_agg(column_name || ' ' || udt_name, ',') FROM information_schema.columns WHERE table_name = split_part(tbl_in, '.', 2);
EXECUTE '
	CREATE OR REPLACE VIEW '|| tbl_out ||' AS
		SELECT ROW_NUMBER() OVER (ORDER BY transaction_timestamp ASC) AS rowid, * 
		FROM history.vtime_inside('''|| tbl_in ||''', '''|| col_value ||''', '''|| col_vtime ||''', '''|| vtime_from ||''', '''|| vtime_to ||''') 
			main ('|| tbl_struct ||', vtime_from timestamptz, vtime_to timestamptz, transaction_timestamp timestamptz, transaction_type text);
	';
END;
$BODY$  
LANGUAGE plpgsql;
COMMENT ON FUNCTION history.vtime_inside(tbl_in character varying, tbl_out character varying, col_value character varying, col_vtime character varying, vtime_from text, vtime_to text) IS $body$
This function searches history.logged_actions to get the latest version of each object primitive whose valid time is completely inside the queried timerange.
Results table structure is defined dynamically from input table/view. Returns view.
Arguments:
   tbl_in:		schema.table character varying
   tbl_out:		schema.table character varying
   col_value:		column that holds the qualifier values (BUILT, MODIF, DESTR) character varying
   col_vtime:		column that holds the actual valid time character varying
   vtime_from:		valid time from text
   vtime_to:		valid time to text
$body$;


-------------------------------------------
-- Add valid time query function (Equal) --
-------------------------------------------
CREATE OR REPLACE FUNCTION history.vtime_equal(tbl character varying, col_value character varying, col_vtime character varying, vtime_from text DEFAULT '0001-01-01 00:00:00', vtime_to text DEFAULT now())
RETURNS SETOF RECORD AS
$BODY$
BEGIN
    RETURN QUERY EXECUTE '
	SELECT DISTINCT ON (a.gid) * FROM (
		--query1: query old_record (from) and new_record (to) column to get the INSERT records
		(SELECT DISTINCT ON (b.old_record->''gid'') (populate_record(null::' ||tbl|| ', b.old_record)).*, (populate_record(null::' ||tbl|| ', b.old_record)).'||col_vtime||' as vtime_from, (populate_record(null::' ||tbl|| ', b.new_record)).'||col_vtime||' as vtime_to, b.transaction_time, b.transaction_type FROM history.logged_actions AS b 
			WHERE b.table_name = split_part('''||tbl||''', ''.'', 2) 
			AND (populate_record(null::' ||tbl|| ', b.old_record)).'||col_value||'=''BUILT''
			AND exist(b.changed_fields,'''||col_vtime||''')  
			AND b.new_record->'''||col_vtime||''' = '''||vtime_to||''' AND b.old_record->'''||col_vtime||''' = '''||vtime_from||'''
		ORDER BY b.old_record->''gid'', b.transaction_time DESC)

		UNION ALL

		--query2: query old_record (from) and new_record (to) column to get the UPDATE records
		(SELECT DISTINCT ON (b.old_record->''gid'', b.old_record->'''||col_vtime||''') (populate_record(null::' ||tbl|| ', b.old_record)).*, (populate_record(null::' ||tbl|| ', b.old_record)).'||col_vtime||' as vtime_from, (populate_record(null::' ||tbl|| ', b.new_record)).'||col_vtime||' as vtime_to, b.transaction_time, b.transaction_type FROM history.logged_actions AS b 
			WHERE b.table_name = split_part('''||tbl||''', ''.'', 2) 
			AND (populate_record(null::' ||tbl|| ', b.old_record)).'||col_value||'=''MODIF''
			AND exist(b.changed_fields,'''||col_vtime||''') 
			AND b.new_record->'''||col_vtime||''' = '''||vtime_to||''' AND b.old_record->'''||col_vtime||''' = '''||vtime_from||'''
		ORDER BY b.old_record->''gid'', b.old_record->'''||col_vtime||''', b.transaction_time DESC)

		UNION ALL
		
		--query3: query old_record (from) and new_record (to) column to get the DELETE records
		(SELECT DISTINCT ON (b.new_record->''gid'') (populate_record(null::' ||tbl|| ', b.new_record)).*, (populate_record(null::' ||tbl|| ', b.old_record)).'||col_vtime||' as vtime_from, (populate_record(null::' ||tbl|| ', b.new_record)).'||col_vtime||' as vtime_to, b.transaction_time, b.transaction_type FROM history.logged_actions AS b 
			WHERE b.table_name = split_part('''||tbl||''', ''.'', 2) 
			AND (populate_record(null::' ||tbl|| ', b.new_record)).'||col_value||'=''DESTR'' 
			AND exist(b.changed_fields,'''||col_vtime||''')
			AND b.new_record->'''||col_vtime||''' = '''||vtime_to||''' AND b.old_record->'''||col_vtime||''' = '''||vtime_from||'''
		ORDER BY b.new_record->''gid'', b.transaction_time DESC)
	) a ORDER BY a.gid, a.'||col_vtime||' DESC;
	';
END;
$BODY$
LANGUAGE plpgsql;
COMMENT ON FUNCTION history.vtime_equal(tbl character varying, col_value character varying, col_vtime character varying, vtime_from text, vtime_to text) IS $body$
This function searches history.logged_actions to get the latest version of each object primitive whose valid time range equals the queried timerange.
Results table structure needs to be defined manually. Returns set of records.

Arguments:
   tbl:			table/view that holds the valid time columns character varying
   col_value:		column that holds the qualifier values (BUILT, MODIF, DESTR) character varying
   col_vtime:		column that holds the actual valid time character varying
   vtime_from:		valid time from text
   vtime_to:		valid time to text
$body$;

--Convenience call wrapper that gets dynamic column structure of results and writes them to view
CREATE OR REPLACE FUNCTION history.vtime_equal(tbl_in character varying, tbl_out character varying, col_value character varying, col_vtime character varying, vtime_from text DEFAULT '0001-01-01 00:00:00', vtime_to text DEFAULT now())
RETURNS void AS 
$BODY$
DECLARE 
  tbl_struct text;
BEGIN
tbl_struct := string_agg(column_name || ' ' || udt_name, ',') FROM information_schema.columns WHERE table_name = split_part(tbl_in, '.', 2);
EXECUTE '
	CREATE OR REPLACE VIEW '|| tbl_out ||' AS
		SELECT ROW_NUMBER() OVER (ORDER BY transaction_timestamp ASC) AS rowid, * 
		FROM history.vtime_equal('''|| tbl_in ||''', '''|| col_value ||''', '''|| col_vtime ||''', '''|| vtime_from ||''', '''|| vtime_to ||''') 
			main ('|| tbl_struct ||', vtime_from timestamptz, vtime_to timestamptz, transaction_timestamp timestamptz, transaction_type text);
	';
END;
$BODY$  
LANGUAGE plpgsql;
COMMENT ON FUNCTION history.vtime_equal(tbl_in character varying, tbl_out character varying, col_value character varying, col_vtime character varying, vtime_from text, vtime_to text) IS $body$
This function searches history.logged_actions to get the latest version of each object primitive whose valid time range equals the queried timerange.
Results table structure is defined dynamically from input table/view. Returns view.
Arguments:
   tbl_in:		schema.table character varying
   tbl_out:		schema.table character varying
   col_value:		column that holds the qualifier values (BUILT, MODIF, DESTR) character varying
   col_vtime:		column that holds the actual valid time character varying
   vtime_from:		valid time from text
   vtime_to:		valid time to text
$body$;

------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
-- Name: SENSUM multi-resolution database support for Remote Rapid Visual Screening (RRVS)
-- Version: 0.3.3
-- Date: 26.11.14
-- Author: M. Wieland
-- DBMS: PostgreSQL9.2 / PostGIS2.0
-- SENSUM data model: tested on version 0.9
-- Description: Adjusts the basic SENSUM data model to fit the SENSUM indicators used for a RRVS of buildings
--		1. Fills the taxonomy tables with attribute types and values, and according qualifier types and values
-- 		   Implemented attributes: GEM Taxonomy v2.0, EMCA building types, EMS-98 Vulnerability
-- 		   Implemented qualifiers: Belief, Quality, Source, Validtime
-- 		   Implemented resolutions: Resolution 1 (per-building)
--		2. Adjusts the editable view for resolution 1 from the basic SENSUM data model to the RRVS specifications
--		   Attributes in use: GEM Taxonomy, EMCA building types, Vulnerability
--		   Qualifiers in use: Belief, Validtime, Source
--		3. Creates views for data and metadata exchange
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------
---------- FILL TAXONOMY TABLES --------------
----------------------------------------------
--Load qualifier types to taxonomy tables
INSERT INTO taxonomy.dic_qualifier_type( gid, code, description, extended_description ) VALUES ( 1, 'BELIEF', 'Uncertainty measured as subjective degree of belief', null );
INSERT INTO taxonomy.dic_qualifier_type( gid, code, description, extended_description ) VALUES ( 2, 'QUALITY', 'Assessment of quality of attribute information', null ); 
INSERT INTO taxonomy.dic_qualifier_type( gid, code, description, extended_description ) VALUES ( 3, 'SOURCE', 'Source of information', null ); 
INSERT INTO taxonomy.dic_qualifier_type( gid, code, description, extended_description ) VALUES ( 4, 'VALIDTIME', 'Valid time of real-world object (e.g., construction period)', null );

--Load qualifier values to taxonomy tables
INSERT INTO taxonomy.dic_qualifier_value( gid, qualifier_type_code, qualifier_value, description, extended_description ) VALUES ( 1, 'BELIEF', 'BLOW', null, null ); 
INSERT INTO taxonomy.dic_qualifier_value( gid, qualifier_type_code, qualifier_value, description, extended_description ) VALUES ( 2, 'BELIEF', 'BHIGH', null, null ); 
INSERT INTO taxonomy.dic_qualifier_value( gid, qualifier_type_code, qualifier_value, description, extended_description ) VALUES ( 3, 'BELIEF', 'BP', 'Percentage 1-100 - use add_numeric_1 to enter belief value', null ); 
INSERT INTO taxonomy.dic_qualifier_value( gid, qualifier_type_code, qualifier_value, description, extended_description ) VALUES ( 4, 'BELIEF', 'B99', 'Unknown', null ); 
INSERT INTO taxonomy.dic_qualifier_value( gid, qualifier_type_code, qualifier_value, description, extended_description ) VALUES ( 5, 'QUALITY', 'QLOW', null, null ); 
INSERT INTO taxonomy.dic_qualifier_value( gid, qualifier_type_code, qualifier_value, description, extended_description ) VALUES ( 6, 'QUALITY', 'QMEDIUM', null, null ); 
INSERT INTO taxonomy.dic_qualifier_value( gid, qualifier_type_code, qualifier_value, description, extended_description ) VALUES ( 7, 'QUALITY', 'QHIGH', null, null ); 
INSERT INTO taxonomy.dic_qualifier_value( gid, qualifier_type_code, qualifier_value, description, extended_description ) VALUES ( 8, 'SOURCE', 'OSM', 'OpenStreetMap', null ); 
INSERT INTO taxonomy.dic_qualifier_value( gid, qualifier_type_code, qualifier_value, description, extended_description ) VALUES ( 9, 'SOURCE', 'RS', 'Remote Sensing', null ); 
INSERT INTO taxonomy.dic_qualifier_value( gid, qualifier_type_code, qualifier_value, description, extended_description ) VALUES ( 10, 'SOURCE', 'RVS', 'Rapid Visual Screening', null ); 
INSERT INTO taxonomy.dic_qualifier_value( gid, qualifier_type_code, qualifier_value, description, extended_description ) VALUES ( 11, 'SOURCE', 'RRVS', 'Remote Rapid Visual Screening', null ); 
INSERT INTO taxonomy.dic_qualifier_value( gid, qualifier_type_code, qualifier_value, description, extended_description ) VALUES ( 12, 'SOURCE', 'OF', 'Official Source (e.g. cadastral data or census)', null ); 
INSERT INTO taxonomy.dic_qualifier_value( gid, qualifier_type_code, qualifier_value, description, extended_description ) VALUES ( 13, 'VALIDTIME', 'BUILT', 'Start timestamp of lifetime', null ); 
INSERT INTO taxonomy.dic_qualifier_value( gid, qualifier_type_code, qualifier_value, description, extended_description ) VALUES ( 14, 'VALIDTIME', 'MODIF', 'Modification timestamp of lifetime', null ); 
INSERT INTO taxonomy.dic_qualifier_value( gid, qualifier_type_code, qualifier_value, description, extended_description ) VALUES ( 15, 'VALIDTIME', 'DESTR', 'End timestamp of lifetime', null ); 

--Load taxonomy values to taxonomy tables
INSERT INTO taxonomy.dic_taxonomy( gid, code, description, extended_description, version_date ) VALUES ( 1, 'GEM20', 'GEM Building Taxonomy V2.0', null, '2013-03-12' ); 
INSERT INTO taxonomy.dic_taxonomy( gid, code, description, extended_description, version_date ) VALUES ( 2, 'SENSUM', 'SENSUM Indicators', null, '2013-11-12' ); 
INSERT INTO taxonomy.dic_taxonomy( gid, code, description, extended_description, version_date ) VALUES ( 3, 'EMCA', 'EMCA Building Typology', null, '2013-04-16' ); 
INSERT INTO taxonomy.dic_taxonomy( gid, code, description, extended_description, version_date ) VALUES ( 4, 'EMS98', 'European Macroseismic Scale 1998', null, '1998-01-01' ); 

--Load GEM Taxonomy v2.0 attribute types to the taxonomy tables
INSERT INTO taxonomy.dic_attribute_type( gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order ) VALUES ( 19, 'ROOFSYSTYP', 'Roof System Type', null, 'GEM20', 4, null ); 
INSERT INTO taxonomy.dic_attribute_type( gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order ) VALUES ( 20, 'ROOF_CONN', 'Roof Connections', null, 'GEM20', 5, null ); 
INSERT INTO taxonomy.dic_attribute_type( gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order ) VALUES ( 1, 'MAT_TYPE', 'Material Type', null, 'GEM20', 1, null ); 
INSERT INTO taxonomy.dic_attribute_type( gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order ) VALUES ( 2, 'MAT_TECH', 'Material Technology', null, 'GEM20', 2, null ); 
INSERT INTO taxonomy.dic_attribute_type( gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order ) VALUES ( 3, 'MAT_PROP', 'Material Property', null, 'GEM20', 3, null ); 
INSERT INTO taxonomy.dic_attribute_type( gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order ) VALUES ( 21, 'FLOOR_MAT', 'Floor Material', null, 'GEM20', 1, null ); 
INSERT INTO taxonomy.dic_attribute_type( gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order ) VALUES ( 4, 'LLRS', 'Type of Lateral Load-Resisting System', null, 'GEM20', 1, null ); 
INSERT INTO taxonomy.dic_attribute_type( gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order ) VALUES ( 5, 'LLRS_DUCT', 'System Ductility', null, 'GEM20', 2, null ); 
INSERT INTO taxonomy.dic_attribute_type( gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order ) VALUES ( 22, 'FLOOR_TYPE', 'Floor System Type', null, 'GEM20', 2, null ); 
INSERT INTO taxonomy.dic_attribute_type( gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order ) VALUES ( 6, 'HEIGHT', 'Height', null, 'GEM20', 1, null ); 
INSERT INTO taxonomy.dic_attribute_type( gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order ) VALUES ( 23, 'FLOOR_CONN', 'Floor Connections', null, 'GEM20', 3, null ); 
INSERT INTO taxonomy.dic_attribute_type( gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order ) VALUES ( 7, 'YR_BUILT', 'Date of Construction or Retrofit', null, 'GEM20', 1, null ); 
INSERT INTO taxonomy.dic_attribute_type( gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order ) VALUES ( 24, 'FOUNDN_SYS', 'Foundation System', null, 'GEM20', 1, null ); 
INSERT INTO taxonomy.dic_attribute_type( gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order ) VALUES ( 8, 'OCCUPY', 'Building Occupancy Class - General', null, 'GEM20', 1, null ); 
INSERT INTO taxonomy.dic_attribute_type( gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order ) VALUES ( 9, 'OCCUPY_DT', 'Building Occupancy Class - Detail', null, 'GEM20', 2, null ); 
INSERT INTO taxonomy.dic_attribute_type( gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order ) VALUES ( 10, 'POSITION', 'Building Position within a Block', null, 'GEM20', 1, null );
INSERT INTO taxonomy.dic_attribute_type( gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order ) VALUES ( 11, 'PLAN_SHAPE', 'Shape of the Building Plan', null, 'GEM20', 1, null ); 
INSERT INTO taxonomy.dic_attribute_type( gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order ) VALUES ( 12, 'STR_IRREG', 'Regular or Irregular', null, 'GEM20', 1, null ); 
INSERT INTO taxonomy.dic_attribute_type( gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order ) VALUES ( 13, 'STR_IRREG_DT', 'Plan Irregularity or Vertical Irregularity', null, 'GEM20', 2, null ); 
INSERT INTO taxonomy.dic_attribute_type( gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order ) VALUES ( 14, 'STR_IRREG_TYPE', 'Type of Irregularity', null, 'GEM20', 3, null ); 
INSERT INTO taxonomy.dic_attribute_type( gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order ) VALUES ( 15, 'NONSTRCEXW', 'Exterior walls', null, 'GEM20', 1, null ); 
INSERT INTO taxonomy.dic_attribute_type( gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order ) VALUES ( 16, 'ROOF_SHAPE', 'Roof Shape', null, 'GEM20', 1, null ); 
INSERT INTO taxonomy.dic_attribute_type( gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order ) VALUES ( 17, 'ROOFCOVMAT', 'Roof Covering', null, 'GEM20', 2, null ); 
INSERT INTO taxonomy.dic_attribute_type( gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order ) VALUES ( 18, 'ROOFSYSMAT', 'Roof System Material', null, 'GEM20', 3, null ); 
INSERT INTO taxonomy.dic_attribute_type( gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order ) VALUES ( 25, 'BUILD_TYPE', 'Building Type', null, 'EMCA', 1, null ); 
INSERT INTO taxonomy.dic_attribute_type( gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order ) VALUES ( 26, 'BUILD_SUBTYPE', 'Building Subtype', null, 'EMCA', 2, null ); 
INSERT INTO taxonomy.dic_attribute_type( gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order ) VALUES ( 27, 'VULN', 'Structural Vulnerability Class', null, 'EMS98', 1, null ); 

--Load GEM Taxonomy v2.0 attribute values to the taxonomy tables
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 92, 'LLRS', 'LH', 'LH - Hybrid lateral load-resisting system', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 93, 'LLRS', 'LO', 'LO - Other lateral load-resisting system', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 94, 'LLRS_DUCT', 'DU99', 'DU99 - Ductility unknown', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 95, 'LLRS_DUCT', 'DUC', 'DUC - Ductile', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 96, 'LLRS_DUCT', 'DNO', 'DNO - Non-ductile', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 97, 'LLRS_DUCT', 'DBD', 'DBD - Equipped with base isolation and/or energy dissipation devices', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 1, 'MAT_TYPE', 'MAT99', 'MAT99 - Unknown material', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 2, 'MAT_TYPE', 'C99', 'C99 - Concrete, unknown reinforcement', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 3, 'MAT_TYPE', 'CU', 'CU - Concrete, unreinforced', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 4, 'MAT_TYPE', 'CR', 'CR - Concrete, reinforced', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 5, 'MAT_TYPE', 'SRC', 'SRC - Concrete, composite with steel section', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 6, 'MAT_TYPE', 'S', 'S - Steel', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 7, 'MAT_TYPE', 'ME', 'ME - Metal (except steel)', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 8, 'MAT_TYPE', 'M99', 'M99 - Masonry, unknown reinforcement', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 9, 'MAT_TYPE', 'MUR', 'MUR - Masonry, unreinforced', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 10, 'MAT_TYPE', 'MCF', 'MCF - Masonry, confined', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 11, 'MAT_TYPE', 'MR', 'MR - Masonry, reinforced', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 12, 'MAT_TYPE', 'E99', 'E99 - Earth, unknown reinforcement', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 13, 'MAT_TYPE', 'EU', 'EU - Earth, unreinforced', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 14, 'MAT_TYPE', 'ER', 'ER - Earth, reinforced', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 15, 'MAT_TYPE', 'W', 'W - Wood', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 32, 'MAT_TECH', 'STRUB', 'STRUB - Rubble (field stone) or semi-dressed stone', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 16, 'MAT_TYPE', 'MATO', 'MATO - Other material', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 31, 'MAT_TECH', 'ST99', 'ST99 - Stone, unknown technology', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 30, 'MAT_TECH', 'ADO', 'ADO - Adobe blocks', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 29, 'MAT_TECH', 'MUN99', 'MUN99 - Masonry unit, unknown', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 33, 'MAT_TECH', 'STDRE', 'STDRE - Dressed stone', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 34, 'MAT_TECH', 'CL99', 'CL99 - Fired clay unit, unknown type', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 35, 'MAT_TECH', 'CLBRS', 'CLBRS - Fired clay solid bricks', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 36, 'MAT_TECH', 'CLBRH', 'CLBRH - Fired clay hollow bricks', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 37, 'MAT_TECH', 'CLBLH', 'CLBLH - Fired clay hollow blocks or tiles', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 38, 'MAT_TECH', 'CB99', 'CB99 - Concrete blocks, unknown type', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 98, 'HEIGHT', 'H99', 'H99 - Number of storeys unknown', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 17, 'MAT_TECH', 'CT99', 'CT99 - Unknown concrete technology', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 18, 'MAT_TECH', 'CIP', 'CIP - Cast-in-place concrete', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 19, 'MAT_TECH', 'PC', 'PC - Precast concrete', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 20, 'MAT_TECH', 'CIPPS', 'CIPPS - Cast-in-place prestressed concrete', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 21, 'MAT_TECH', 'PCPS', 'PCPS - Precast prestressed concrete', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 22, 'MAT_TECH', 'S99', 'S99 - Steel, unknown', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 23, 'MAT_TECH', 'SL', 'SL - Cold-formed steel members', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 24, 'MAT_TECH', 'SR', 'SR - Hot-rolled steel members', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 25, 'MAT_TECH', 'SO', 'SO - Steel, other', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 26, 'MAT_TECH', 'ME99', 'ME99 - Metal, unknown', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 27, 'MAT_TECH', 'MEIR', 'MEIR - Iron', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 28, 'MAT_TECH', 'MEO', 'MEO - Metal, other', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 39, 'MAT_TECH', 'CBS', 'CBS - Concrete blocks, solid', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 40, 'MAT_TECH', 'CBH', 'CBH - Concrete blocks, hollow', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 41, 'MAT_TECH', 'MO', 'MO - Masonry unit, other', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 42, 'MAT_TECH', 'MR99', 'MR99 - Masonry reinforcement, unknown', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 43, 'MAT_TECH', 'RS', 'RS - Steel reinforced', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 99, 'HEIGHT', 'H', 'H - Number of storeys above ground', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 44, 'MAT_TECH', 'RW', 'RW - Wood-reinforced', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 45, 'MAT_TECH', 'RB', 'RB - Bamboo-, cane- or rope-reinforcement', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 46, 'MAT_TECH', 'RCM', 'RCM - Fibre reinforcing mesh', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 100, 'HEIGHT', 'HB', 'HB - Number of storeys below ground', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 47, 'MAT_TECH', 'RCB', 'RCB - Reinforced concrete bands', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 48, 'MAT_TECH', 'ET99', 'ET99 - Unknown earth technology', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 49, 'MAT_TECH', 'ETR', 'ETR - Rammed earth', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 101, 'HEIGHT', 'HF', 'HF - Height of ground floor level above grade', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 50, 'MAT_TECH', 'ETC', 'ETC - Cob or wet construction', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 51, 'MAT_TECH', 'ETO', 'ETO - Earth technology, other', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 52, 'MAT_TECH', 'W99', 'W99 - Wood, unknown', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 53, 'MAT_TECH', 'WHE', 'WHE - Heavy wood', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 54, 'MAT_TECH', 'WLI', 'WLI - Light wood members', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 55, 'MAT_TECH', 'WS', 'WS - Solid wood', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 56, 'MAT_TECH', 'WWD', 'WWD - Wattle and daub', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 57, 'MAT_TECH', 'WBB', 'WBB - Bamboo', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 58, 'MAT_TECH', 'WO', 'WO - Wood, other', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 103, 'YR_BUILT', 'Y99', 'Y99 - Year unknown', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 104, 'YR_BUILT', 'YEX', 'YEX - Exact  date of construction or retrofit', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 106, 'YR_BUILT', 'YPRE', 'YPRE - Latest possible date of construction or retrofit', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 60, 'MAT_PROP', 'SC99', 'SC99 - Steel connections, unknown', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 62, 'MAT_PROP', 'WEL', 'WEL - Welded connections', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 63, 'MAT_PROP', 'RIV', 'RIV - Riveted connections', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 64, 'MAT_PROP', 'BOL', 'BOL - Bolted connections', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 65, 'MAT_PROP', 'MO99', 'MO99 - Mortar type unknown', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 66, 'MAT_PROP', 'MON', 'MON - No mortar', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 67, 'MAT_PROP', 'MOM', 'MOM - Mud mortar', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 68, 'MAT_PROP', 'MOL', 'MOL - Lime mortar', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 69, 'MAT_PROP', 'MOC', 'MOC - Cement mortar', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 70, 'MAT_PROP', 'MOCL', 'MOCL - Cement: lime mortar', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 71, 'MAT_PROP', 'SP99', 'SP99 - Stone, unknown type', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 109, 'OCCUPY', 'RES', 'RES - Residential', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 72, 'MAT_PROP', 'SPLI', 'SPLI - Limestone', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 73, 'MAT_PROP', 'SPSA', 'SPSA - Sandstone', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 74, 'MAT_PROP', 'SPTU', 'SPTU - Tuff', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 75, 'MAT_PROP', 'SPSL', 'SPSL - Slate', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 76, 'MAT_PROP', 'SPGR', 'SPGR - Granite', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 77, 'MAT_PROP', 'SPBA', 'SPBA - Basalt', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 78, 'MAT_PROP', 'SPO', 'SPO - Stone, other type', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 80, 'MAT_TECH', 'MATT99', 'MATT99 - Unknown material technology', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 81, 'MAT_PROP', 'MATP99', 'MATP99 - Unknown material property', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 84, 'LLRS', 'LFM', 'LFM - Moment frame', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 82, 'LLRS', 'L99', 'L99 - Unknown lateral load-resisting system', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 83, 'LLRS', 'LN', 'LN - No lateral load-resisting system', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 85, 'LLRS', 'LFINF', 'LFINF - Infilled frame', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 86, 'LLRS', 'LFBR', 'LFBR - Braced frame', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 87, 'LLRS', 'LPB', 'LPN - Post and beam', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 88, 'LLRS', 'LWAL', 'LWAL - Wall', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 89, 'LLRS', 'LDUAL', 'LDUAL - Dual frame-wall system', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 90, 'LLRS', 'LFLS', 'LFLS - Flat slab/plate or infilled waffle slab', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 91, 'LLRS', 'LFLSINF', 'LFLSINF - Infilled flat slab/plate or infilled waffle slab', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 105, 'YR_BUILT', 'YBET', 'YBET - Upper and lower bound for the date of construction or retrofit', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 107, 'YR_BUILT', 'YAPP', 'YAPP - Approximate date of construction or retrofit', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 235, 'ROOFCOVMAT', 'RMT99', 'RMT99 - Unknown roof covering', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 147, 'OCCUPY_DT', 'MIX4', 'MIX4 - Mostly residential and industrial', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 148, 'OCCUPY_DT', 'MIX5', 'MIX5 - Mostly industrial and commercial', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 149, 'OCCUPY_DT', 'MIX6', 'MIX6 - Mostly industrial and residential', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 150, 'OCCUPY_DT', 'IND99', 'IND99 - Industiral, unknown type', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 236, 'ROOFCOVMAT', 'RMN', 'RMN - Concrete rood without additional covering', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 151, 'OCCUPY_DT', 'IND1', 'IND1 - Heavy industrial', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 152, 'OCCUPY_DT', 'IND2', 'IND2 - Light industrial', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 153, 'OCCUPY_DT', 'AGR99', 'AGR99 - Agriculture, unknown type', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 154, 'OCCUPY_DT', 'AGR1', 'AGR1 - Produce storage', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 155, 'OCCUPY_DT', 'AGR2', 'AGR2 - Animal shelter', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 156, 'OCCUPY_DT', 'AGR3', 'AGR3 - Agricultural processing', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 157, 'OCCUPY_DT', 'ASS99', 'ASS99 - Assembly, unknown type', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 158, 'OCCUPY_DT', 'ASS1', 'ASS1 - Religious gathering', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 159, 'OCCUPY_DT', 'ASS2', 'ASS2 - Arena', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 160, 'OCCUPY_DT', 'ASS3', 'ASS3 - Cinema or concert hall', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 161, 'OCCUPY_DT', 'ASS4', 'ASS4 - Other gatherings', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 162, 'OCCUPY_DT', 'GOV99', 'GOV99 - Government, unknown type', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 163, 'OCCUPY_DT', 'GOV1', 'GOV1 - Government, general services', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 164, 'OCCUPY_DT', 'GOV2', 'GOV2 - Government, emergency services', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 165, 'OCCUPY_DT', 'EDU99', 'EDU99 - Education, unknown type', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 166, 'OCCUPY_DT', 'EDU1', 'EDU1 - Pre-school facility', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 167, 'OCCUPY_DT', 'EDU2', 'EDU2 - School', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 196, 'STR_IRREG', 'IRIR', 'IRIR - Irregular structure', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 170, 'POSITION', 'BPD', 'BPD - Detached building', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 171, 'POSITION', 'BP1', 'BP1 - Adjoining building(s) on one side', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 197, 'STR_IRREG_DT', 'IRPP', 'IRPP - Plan irregularity - primary', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 172, 'POSITION', 'BP2', 'BP2 - Adjoining building(s) on two sides', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 173, 'POSITION', 'BP3', 'BP3 - Adjoining building(s) on three sides', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 198, 'STR_IRREG_DT', 'IRPS', 'IRPS - Plan irregularity - secondary', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 199, 'STR_IRREG_DT', 'IRVP', 'IRVP - Vertical irregularity - primary', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 200, 'STR_IRREG_DT', 'IRVS', 'IRVS - Vertical irregularity - secondary', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 201, 'STR_IRREG_TYPE', 'IRN', 'INR - No irregularity', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 202, 'STR_IRREG_TYPE', 'TOR', 'TOR - Torsion eccentricity', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 203, 'STR_IRREG_TYPE', 'REC', 'REC - Re-entrant corner', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 204, 'STR_IRREG_TYPE', 'IRHO', 'IRHO - Other plan irregularity', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 237, 'ROOFCOVMAT', 'RMT1', 'RMT1 - Clay or concrete tile roof covering', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 205, 'STR_IRREG_TYPE', 'SOS', 'SOS - Soft storey', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 206, 'STR_IRREG_TYPE', 'CRW', 'CRW - Cripple wall', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 207, 'STR_IRREG_TYPE', 'SHC', 'SHC - Short column', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 208, 'STR_IRREG_TYPE', 'POP', 'POP - Pounding potential', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 209, 'STR_IRREG_TYPE', 'SET', 'SET - Setback', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 210, 'STR_IRREG_TYPE', 'CHV', 'CHV - Change in vertical structure (includes large overhangs)', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 211, 'STR_IRREG_TYPE', 'IRVO', 'IRVO - Other vertical irregularity', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 238, 'ROOFCOVMAT', 'RMT2', 'RMT2 - Fibre cement or metal tile roof covering', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 239, 'ROOFCOVMAT', 'RMT3', 'RMT3 - Membrane roof covering', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 240, 'ROOFCOVMAT', 'RMT4', 'RMT4 - Slate roof covering', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 212, 'NONSTRCEXW', 'EW99', 'EW99 - Unknown material of exterior walls', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 213, 'NONSTRCEXW', 'EWC', 'EWC - Concrete exterior walls', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 214, 'NONSTRCEXW', 'EWG', 'EWG - Glass exterior walls', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 215, 'NONSTRCEXW', 'EWE', 'EWE - Earthen exterior walls', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 216, 'NONSTRCEXW', 'EWMA', 'EWMA - Masonry exterior walls', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 241, 'ROOFCOVMAT', 'RMT5', 'RMT5 - Stone slab roof covering', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 242, 'ROOFCOVMAT', 'RMT6', 'RMT6 - Metal or asbestos sheet roof covering', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 243, 'ROOFCOVMAT', 'RMT7', 'RMT7 - Wooden or asphalt shingle roof covering', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 244, 'ROOFCOVMAT', 'RMT8', 'RMT8 - Vegetative roof covering', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 245, 'ROOFCOVMAT', 'RMT9', 'RMT9 - Earthen roof covering', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 228, 'ROOF_SHAPE', 'RSH4', 'RSH4 - Pitched with dormers', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 229, 'ROOF_SHAPE', 'RSH5', 'RSH5 - Monopitch', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 230, 'ROOF_SHAPE', 'RSH6', 'RSH6 - Sawtooth', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 231, 'ROOF_SHAPE', 'RSH7', 'RSH7 - Curved', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 232, 'ROOF_SHAPE', 'RSH8', 'RSH8 - Complex regular', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 233, 'ROOF_SHAPE', 'RSH9', 'RSH9 - Complex irregular', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 234, 'ROOF_SHAPE', 'RSHO', 'RSHO - Roof shape, other', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 246, 'ROOFCOVMAT', 'RMT10', 'RMT10 - Solar panelled roofs', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 247, 'ROOFCOVMAT', 'RMT11', 'RMT11 - Tensile membrane or fabric roof', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 248, 'ROOFCOVMAT', 'RMTO', 'RMTO - Roof covering, other', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 249, 'ROOFSYSMAT', 'RM', 'RM - Masonry roof', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 250, 'ROOFSYSMAT', 'RE', 'RE - Earthen roof', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 251, 'ROOFSYSMAT', 'RC', 'RC - Concrete roof', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 252, 'ROOFSYSMAT', 'RME', 'RME - Metal roof', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 253, 'ROOFSYSMAT', 'RWO', 'RWO - Wooden roof', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 254, 'ROOFSYSMAT', 'RFA', 'RFA - Fabric roof', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 255, 'ROOFSYSMAT', 'RO', 'RO - Roof material, other', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 256, 'ROOFSYSTYP', 'RM99', 'RM99 - Masonry roof, unknown', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 257, 'ROOFSYSTYP', 'RM1', 'RM1 - Vaulted masonry roof', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 258, 'ROOFSYSTYP', 'RM2', 'RM2 - Shallow-arched masonry roof', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 259, 'ROOFSYSTYP', 'RM3', 'RM3 - Composite masonry and concrete roof system', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 260, 'ROOFSYSTYP', 'RE99', 'RE99 - Earthen roof, unknown', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 261, 'ROOFSYSTYP', 'RE1', 'RE1 - Vaulted earthen roof, unknown', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 281, 'ROOF_CONN', 'RWCP', 'RWCP - Roof-wall diaphragm connection present', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 283, 'ROOF_CONN', 'RTDN', 'RTDN - Roof tie-down not provided', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 282, 'ROOF_CONN', 'RTD99', 'RTD99 - Roof tie-down unknown', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 284, 'ROOF_CONN', 'RTDP', 'RTDP - Roof tie-down present', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 285, 'FLOOR_MAT', 'FN', 'FN - No elevated or suspended floor', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 286, 'FLOOR_MAT', 'F99', 'F99 - Floor material, unknown', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 288, 'FLOOR_MAT', 'FE', 'FE - Earthen floor', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 290, 'FLOOR_MAT', 'FME', 'FME - Metal floor', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 294, 'FLOOR_TYPE', 'FM1', 'FM1 - Vaulted masonry floor', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 297, 'FLOOR_TYPE', 'FE99', 'FE99 - Earthen floor, unknown', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 298, 'FLOOR_TYPE', 'FC99', 'FC99 - Concrete floor, unknown', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 134, 'OCCUPY_DT', 'COM3', 'COM3 - Offices, professional/technical services', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 135, 'OCCUPY_DT', 'COM4', 'COM4 - Hospital/medical clinic', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 136, 'OCCUPY_DT', 'COM5', 'COM5 - Entertainment', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 137, 'OCCUPY_DT', 'COM6', 'COM6 - Public building', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 138, 'OCCUPY_DT', 'COM7', 'COM7 - Covered parking garage', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 139, 'OCCUPY_DT', 'COM8', 'COM8 - Bus station', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 108, 'OCCUPY', 'OC99', 'OC99 - Unknown occupancy', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 110, 'OCCUPY', 'COM', 'COM - Commercial and public', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 111, 'OCCUPY', 'MIX', 'MIX - Mixed use', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 112, 'OCCUPY', 'IND', 'IND - Industrial', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 113, 'OCCUPY', 'AGR', 'AGR - Agriculture', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 114, 'OCCUPY', 'ASS', 'ASS - Assembly', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 115, 'OCCUPY', 'GOV', 'GOV - Government', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 116, 'OCCUPY', 'EDU', 'EDU - Education', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 117, 'OCCUPY', 'OCO', 'OCO - Other occupancy type', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 140, 'OCCUPY_DT', 'COM9', 'COM9 - Railway station', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 141, 'OCCUPY_DT', 'COM10', 'COM10 - Airport', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 142, 'OCCUPY_DT', 'COM11', 'COM11 - Recreation and leisure', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 143, 'OCCUPY_DT', 'MIX99', 'MIX99 - Mixed, unknown type', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 144, 'OCCUPY_DT', 'MIX1', 'MIX1 - Mostly residential and commercial', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 145, 'OCCUPY_DT', 'MIX2', 'MIX2 - Mostly commercial and residential', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 146, 'OCCUPY_DT', 'MIX3', 'MIX3 - Mostly commercial and industrial', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 176, 'PLAN_SHAPE', 'PLFSQO', 'PLFSQO - Square, with an opening in plan', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 177, 'PLAN_SHAPE', 'PLFR', 'PLFR - Rectangular, solid', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 178, 'PLAN_SHAPE', 'PLFRO', 'PLFRO - Rectangular, with an opening in plan', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 179, 'PLAN_SHAPE', 'PLFL', 'PLFL - L-shape', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 180, 'PLAN_SHAPE', 'PLFC', 'PLFC - Curved, solid', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 181, 'PLAN_SHAPE', 'PLFCO', 'PLFCO - Curved, with an opening in plan', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 182, 'PLAN_SHAPE', 'PLFD', 'PLFD - Triangular, solid', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 118, 'OCCUPY_DT', 'RES99', 'RES99 - Residential, unknown type', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 119, 'OCCUPY_DT', 'RES1', 'RES1 - Single dwelling', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 120, 'OCCUPY_DT', 'RES2', 'RES2 - Multi-unit, unknown type', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 121, 'OCCUPY_DT', 'RES2A', 'RES2A - 2 Units (duplex)', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 122, 'OCCUPY_DT', 'RES2B', 'RES2B - 3-4 Units', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 123, 'OCCUPY_DT', 'RES2C', 'RES2C - 5-9 Units', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 124, 'OCCUPY_DT', 'RES2D', 'RES2D - 10-19 Units', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 168, 'OCCUPY_DT', 'EDU3', 'EDU3 - College/university offices and/or classrooms', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 125, 'OCCUPY_DT', 'RES2E', 'RES2E - 20-49 Units', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 126, 'OCCUPY_DT', 'RES2F', 'RES2F - 50+ Units', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 127, 'OCCUPY_DT', 'RES3', 'RES3 - Temporary lodging', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 128, 'OCCUPY_DT', 'RES4', 'RES4 - Institutional housing', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 129, 'OCCUPY_DT', 'RES5', 'RES5 - Mobile home', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 130, 'OCCUPY_DT', 'RES6', 'RES6 - Informal housing', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 131, 'OCCUPY_DT', 'COM99', 'COM99 - Commercial and public, unknown type', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 132, 'OCCUPY_DT', 'COM1', 'COM1 - Retail trade', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 133, 'OCCUPY_DT', 'COM2', 'COM2 - Wholesale trade and storage (warehouse)', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 169, 'OCCUPY_DT', 'EDU4', 'EDU4 - College/university research facilities and/or labs', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 183, 'PLAN_SHAPE', 'PLFDO', 'PLFDO - Triangular, with an opening in plan', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 184, 'PLAN_SHAPE', 'PLFP', 'PLFP - Polygonal, solid (e.g. trapezoid, pentagon, hexagon)', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 262, 'ROOFSYSTYP', 'RC99', 'RC99 - Concrete roof, unknown', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 263, 'ROOFSYSTYP', 'RC1', 'RC1 - Cast-in-place beamless reinforced concrete roof', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 174, 'PLAN_SHAPE', 'PLF99', 'PLF99 - Unknown plan shape', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 175, 'PLAN_SHAPE', 'PLFSQ', 'PLFSQ - Square, solid', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 185, 'PLAN_SHAPE', 'PLFPO', 'PLFPO - Polygonal, with an opening in plan', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 217, 'NONSTRCEXW', 'EWME', 'EWME - Metal exterior walls', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 186, 'PLAN_SHAPE', 'PLFE', 'PLFE - E-shape', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 187, 'PLAN_SHAPE', 'PLFH', 'PLFH - H-shape', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 188, 'PLAN_SHAPE', 'PLFS', 'PLFS - S-shape', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 189, 'PLAN_SHAPE', 'PLFT', 'PLFT - T-shape', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 190, 'PLAN_SHAPE', 'PLFU', 'PLFU - U- or C-shape', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 191, 'PLAN_SHAPE', 'PLFX', 'PLFX - X-shape', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 192, 'PLAN_SHAPE', 'PLFY', 'PLFY - Y-shape', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 193, 'PLAN_SHAPE', 'PLFI', 'PLFI - Irregular plan shape', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 264, 'ROOFSYSTYP', 'RC2', 'RC2 - Cast-in-place beam-supported reinforced concrete roof', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 265, 'ROOFSYSTYP', 'RC3', 'RC3 - Precast concrete roof with reinforced concrete topping', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 194, 'STR_IRREG', 'IR99', 'IR99 - Unknown structural irregularity', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 195, 'STR_IRREG', 'IRRE', 'IRRE - Regular structure', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 266, 'ROOFSYSTYP', 'RC4', 'RC4 - Precast concrete roof without reinforced concrete topping', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 267, 'ROOFSYSTYP', 'RME99', 'RME99 - Metal roof, unknown', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 268, 'ROOFSYSTYP', 'RME1', 'RME1 - Metal beams or trusses supporting light roofing', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 269, 'ROOFSYSTYP', 'RME2', 'RME2 - Metal roof beams supporting precast concrete slabs', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 270, 'ROOFSYSTYP', 'RME3', 'RME3 - Composite steel roof deck and concrete slab', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 271, 'ROOFSYSTYP', 'RWO99', 'RWO99 - Wooden roof, unknown', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 218, 'NONSTRCEXW', 'EWV', 'EWV - Vegetative exterior walls', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 219, 'NONSTRCEXW', 'EWW', 'EWW - Wooden exterior walls', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 220, 'NONSTRCEXW', 'EWSL', 'EWSL - Stucco finish on light framing for exterior walls', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 221, 'NONSTRCEXW', 'EWPL', 'EWPL - Plastic/vinyl exterior walls, various', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 222, 'NONSTRCEXW', 'EWCB', 'EWCB - Cement-based boards for exterior walls', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 223, 'NONSTRCEXW', 'EWO', 'EWO - Material of exterior walls, other', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 272, 'ROOFSYSTYP', 'RWO1', 'RWO1 - Wooden structure with roof covering', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 273, 'ROOFSYSTYP', 'RWO2', 'RWO2 - Wooden beams or trusses with heavy roof covering', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 274, 'ROOFSYSTYP', 'RWO3', 'RWO3 - Wood-based sheets on rafters or purlins', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 224, 'ROOF_SHAPE', 'R99', 'R99 - Unknown roof shape', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 225, 'ROOF_SHAPE', 'RSH1', 'RSH1 - Flat', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 226, 'ROOF_SHAPE', 'RSH2', 'RSH2 - Pitched with gable ends', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 227, 'ROOF_SHAPE', 'RSH3', 'RSH3 - Pitched and hipped', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 275, 'ROOFSYSTYP', 'RWO4', 'RWO4 - Plywood panels or other light-weight panels for roof', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 276, 'ROOFSYSTYP', 'RWO5', 'RWO5 - Bamboo, straw or thatch roof', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 277, 'ROOFSYSTYP', 'RFA1', 'RFA1 - Inflatable or tensile membrane roof', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 278, 'ROOFSYSTYP', 'RFAO', 'RFAO - Fabric roof, other', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 279, 'ROOF_CONN', 'RWC99', 'RWC99 - Roof-wall diaphragm connection unknown', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 280, 'ROOF_CONN', 'RWCN', 'RWCN - Roof-wall diaphragm connection not provided', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 287, 'FLOOR_MAT', 'FM', 'FM - Masonry floor', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 289, 'FLOOR_MAT', 'FC', 'FC - Concrete floor', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 291, 'FLOOR_MAT', 'FW', 'FW - Wooden floor', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 292, 'FLOOR_MAT', 'FO', 'FO - Floor material, other', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 304, 'FLOOR_TYPE', 'FME1', 'FME1 - Metal beams, trusses or joists supporting light flooring', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 305, 'FLOOR_TYPE', 'FME2', 'FME2 - Metal floor beams supporting precast concrete slabs', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 306, 'FLOOR_TYPE', 'FME3', 'FME3 - Composite steel deck and concrete slab', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 293, 'FLOOR_TYPE', 'FM99', 'FM99 - Masonry floor, unknown', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 295, 'FLOOR_TYPE', 'FM2', 'FM2 - Shallow-arched masonry floor', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 296, 'FLOOR_TYPE', 'FM3', 'FM3 - Composite cast-in-place reinforced concrete and masonry floor system', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 299, 'FLOOR_TYPE', 'FC1', 'FC1 - Cast-in-place beamless reinforced concrete floor', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 300, 'FLOOR_TYPE', 'FC2', 'FC2 - Cast-in-place beam-supported reinforced concrete floor', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 301, 'FLOOR_TYPE', 'FC3', 'FC3 - Precast concrete flor with reinforced concrete topping', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 302, 'FLOOR_TYPE', 'FC4', 'FC4 - Precast concrete floor without reinforced concrete topping', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 303, 'FLOOR_TYPE', 'FME99', 'FME99 - Metal floor, unknown', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 307, 'FLOOR_TYPE', 'FW99', 'FW99 - Wooden floor, unknown', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 308, 'FLOOR_TYPE', 'FW1', 'FW1 - Wooden beams or trusses and joists supporting light flooring', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 309, 'FLOOR_TYPE', 'FW2', 'FW2 - Wooden beams or trusses and joists supporting heavy flooring', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 310, 'FLOOR_TYPE', 'FW3', 'FW3 - Wood-based sheets on joists or beams', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 311, 'FLOOR_TYPE', 'FW4', 'FW4 - Plywood panels or other light-weight panels for floor', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 312, 'FLOOR_CONN', 'FWC99', 'FWC99 - Floor-wall diaphragm connection unknown', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 313, 'FLOOR_CONN', 'FWCN', 'FWCN - Floor-wall diaphragm connection not provided', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 314, 'FLOOR_CONN', 'FWCP', 'FWCP - Floor-wall diaphragm connection present', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 315, 'FOUNDN_SYS', 'FOS99', 'FOS99 - Unknown foundation system', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 316, 'FOUNDN_SYS', 'FOSSL', 'FOSSL - Shallow foundation, with lateral capacity', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 317, 'FOUNDN_SYS', 'FOSN', 'FOSN - Shallow foundation, no lateral capacity', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 318, 'FOUNDN_SYS', 'FOSDL', 'FOSDL - Deep foundation, with lateral capacity', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 319, 'FOUNDN_SYS', 'FOSDN', 'FOSDN - Deep foundation, no lateral capacity', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 320, 'FOUNDN_SYS', 'FOSO', 'FOSO - Foundation, other', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 321, 'OCCUPY_DT', 'OCCDT99', 'OCCDT99 - Occupancy detail, unknown', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 322, 'POSITION', 'BP99', 'BP99 - Position, unknown', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 324, 'STR_IRREG_TYPE', 'IRT99', 'IRT99 - Structural irregularity type, unknown', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 323, 'STR_IRREG_DT', 'IRP99', 'IRP99 - Structural irregularity detail, unknown', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 357, 'ROOFSYSMAT', 'RSM99', 'RSM99 - Roof system material, unknown', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 358, 'ROOFSYSTYP', 'RST99', 'RST99 - Roof system type, unknown', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 360, 'ROOF_CONN', 'RCN99', 'RCN99 - Roof connection, unknown', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 361, 'FLOOR_TYPE', 'FT99', 'FT99 - Floor type, unknown', null ); 


--Load EMCA building type attribute values to the taxonomy tables
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 362, 'BUILD_TYPE', 'EMCA1', 'EMCA1 - Load bearing masonry wall buildings', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 363, 'BUILD_TYPE', 'EMCA2', 'EMCA2 - Monolithic reinforced concrete buildings', null );
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 364, 'BUILD_TYPE', 'EMCA3', 'EMCA3 - Precast concrete buildings', null );
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 365, 'BUILD_TYPE', 'EMCA4', 'EMCA4 - Non-engineered earthen buildings', null );
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 366, 'BUILD_TYPE', 'EMCA5', 'EMCA5 - Wooden buildings', null );
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 367, 'BUILD_TYPE', 'EMCA6', 'EMCA6 - Steel buildings', null );
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 368, 'BUILD_SUBTYPE', 'EMCA1_1', 'EMCA1.1 - Unreinforced masonry buildings with walls of brick masonry, stone, or blocks in cement or mixed mortar (no seismic design) - wooden floors', 'DX /MUR+CLBRS+MOC /LWAL+DNO /DY /MUR+CLBRS+MOC /LWAL+DNO /YAPP:1940-1955 /HBET:2,3 /RES+RES2E /BP3 /PLFR /IRRE /EWMA /RSH3+RMT4+RO+RWCP /FW /FOSS' );
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 369, 'BUILD_SUBTYPE', 'EMCA1_2', 'EMCA1.2 - Unreinforced masonry - buildings with walls of brick masonry, stone, or blocks in cement or mixed mortar (no seismic design) - precast concrete floors', 'DX /MUR+MOCL /LWAL+DNO /DY /MUR+MOCL /LWAL+DNO /YBET:1975,1990 /HBET:1,2+HBEX:0+HFBET:0.5,1.0+HD:0 /RES+RES2A / /PLFR /IRRE /EWMA /RSH3+RMT4+RWO+RWO3+RTDP /FC+FC3+FWCP /FOSS ' );
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 370, 'BUILD_SUBTYPE', 'EMCA1_3', 'EMCA1.3 - Confined masonry', 'DX /MCF+MOC /LWAL+DNO /DY /MCF+MOC /LWAL+DNO /YBET:1961,2012 /HBET:1,5+HBEX:0+HFBET:0.5,1.5+HD:0 /RES+RES2E / /PLFR /IRIR+IRVP:SOS /EWMA /RSH3+RMT4+RWO+RWO3+RTDP /FC+FC3+FWCP /FOSSL' );
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 371, 'BUILD_SUBTYPE', 'EMCA1_4', 'EMCA1.4 - Masonry with seismic provisions (e.g. seismic belts)', 'DX /MR+CLBRS+RCB+MOCL /LWAL+DNO /DY /MR+CLBRS+RCB+MOCL /LWAL+DNO /YBET:1948,1959 /HBET:1,3+HBEX:0+HFBET:0.3,0.8+HD:0 /RES+RES2D /BPD /PLFR /IRRE /EWMA /RSH3+RMT4+RWO+RWO3+RTDP /FW+FW3+FWCP /FOSSL' );
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 372, 'BUILD_SUBTYPE', 'EMCA2_1', 'EMCA2.1 - Buildings with monolithic concrete moment frames', 'DX /CR+CIP /LFM+DUC /DY /CR+CIP /LFM+DUC /YBET:1950,2012 /HBET:3,7+HBEX:0+HFBET:0.8,1.2+HD:0 /RES+RES2E /BPD /PLFR /IRRE /EWCB /RSH1+RMN+RC+RC3+RTDP /FC+FC3+FWCN /FOSDL' );
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 373, 'BUILD_SUBTYPE', 'EMCA2_2', 'EMCA2.2 - Buildings with monolithic concrete frame and shear walls (dual system)', 'DX /CR+CIP /LDUAL+DNO /DY /CR+CIP /LDUAL+DNO /YBET:1987,2012 /HBET:7,25+HBBET:1,3+HFBET:1.2,2.0+HD:0 /RES+RES2F /BPD /PLFR /IRIR+IRVP:CHV /EWMA /RSH1+RMN+RC+RC2+RTDP /FC+FC2+FWCP /FOSDL' );
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 374, 'BUILD_SUBTYPE', 'EMCA2_3', 'EMCA2.3 - Buildings with monolithic concrete frames and brick infill walls', 'DX /CR+CIP /LFINF+DNO /DY /CR+CIP /LFINF+DNO /YBET:1975,1995 /HBET:3,7+HBEX:0+HFBET:1,1.5+HD:0 /RES+RES2E /BPD /PLFR /IRRE /EWMA /RSH1+RMN+RC+RC3+RTDP /FC+FC3+FWCN /FOSDL' );
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 375, 'BUILD_SUBTYPE', 'EMCA2_4', 'EMCA2.4 - Buildings with monolithic reinforced concrete walls', 'DX /CR+CIP /LWAL+DNO /DY /CR+CIP /LWAL+DNO /YBET:1980,2012 /HBET:8,16+HBEX:1+HFBET:1,1.5+HD:0 /RES+RES2F /BPD /PLFR /IRIR+IRVP:SOS /EWC /RSH1+RMN+RC+RC3+RTDP /FC+FC3+FWCN /FOSDL' );
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 376, 'BUILD_SUBTYPE', 'EMCA3_1', 'EMCA3.1 - Precast concrete large panel buildings with monolithic panel joints - Seria 105', 'DX /CR+PC /LWAL+DUC /DY /CR+PC /LWAL+DUC /YBET:1964,2012 /HBET:1,16+HBEX:1+HFBET:1,1.8+HD:0 /RES+RES2F /BPD /PLFR /IRRE /EWC /RSH1+RMN+RC+RC3+RTDP /FC+FC3+FWCP /FOSDL' );
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 377, 'BUILD_SUBTYPE', 'EMCA3_2', 'EMCA3.2 - Precast concrete large panel buildings with panel connections achieved by welding of embedment plates - Seria 464', '' );
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 378, 'BUILD_SUBTYPE', 'EMCA3_3', 'EMCA3.3 - Precast concrete flat slab buildings (consisting of columns and slabs) - Seria KUB', 'DX /CR+PC /LFLS+DUC /DY /CR+PC /LFLS+DUC /YBET:1980,1990 /HBET:5,9+HBEX:1+HFBET:0.8,1.5+HD:0 /RES+RES2F /BPD /PLFR /IRRE /EWC /RSH1+RMN+RC+RC3+RTDP /FC+FC3+FWCP /FOSDL' );
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 379, 'BUILD_SUBTYPE', 'EMCA3_4', 'EMCA3.4 - Prefabricated RC frame with linear elements with welded joints in the zone of maximum loads or with rigid walls in one direction - Seria 111, IIS-04', 'DX /CR+PC /LFLS+DUC /DY /CR+PC /LFLS+DUC /YBET:1966,1970 /HBET:6,7+HBEX:1+HFBET:1,1.5+HD:0 /RES+RES2E /BPD /PLFR /IRRE /EWC /RSH1+RMN+RC+RC3+RTDP /FC+FC3+FWCP /FOSDL' );
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 380, 'BUILD_SUBTYPE', 'EMCA4_1', 'EMCA4.1 - Buildings with adobe or earthen walls', 'DX /MUR+ADO+MOM /LWAL+DNO /DY /MUR+ADO+MOM /LWAL+DNO /YBET:1850,2012 /HEX:1+HBEX:0+HFBET:0.3,0.5+HD:0 /RES+RES1 /BPD /PLFR /IRIR+IRPP:TOR /EWE /RSH2+RMT4+RWO+RWO3+RTDN /FW+FW3+FWCN /FOSSL' );
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 381, 'BUILD_SUBTYPE', 'EMCA5_1', 'EMCA5.1 - Buildings with load-bearing braced wooden frames', 'DX /W /LWAL+DUC /DY /W /LWAL+DUC /YBET:1950,1970 /HBET:1,2+HBEX:0+HFBET:0.3,0.5+HD:0 /RES+RES2C /BPD /PLFR /IRRE /EWW /RSH2+RMT4+RWO+RWO3+RTDP /FW+FW3+FWCP /FOSSL' );
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 382, 'BUILD_SUBTYPE', 'EMCA5_2', 'EMCA5.2 - Building with a wooden frame and mud infill', 'DX /W+WLI /LO+DUC /DY /W+WLI /LO+DUC /YBET:0,2012 /HBET:1,2+HBEX:0+HFBET:0.3,0.5+HD:0 /RES+RES1 /BPD /PLFR /IRRE /EWE /RSH2+RMT4+RWO+RWO3+RTDP /FW+FW3+FWCP /FOSSL' );
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 383, 'BUILD_SUBTYPE', 'EMCA6_1', 'EMCA6.1 - Steel buildings', 'DX /S+SL+RIV /LFM+DNO /DY /S+SL+RIV /LFM+DNO /YAPP:2008 /HEX:1+HFEX:3+HD:15 /RES+RES1 /BPD /PLFR /IRRE /EWPL /RSH3+RMT6+RME+RME1+RWCP /FME+FME3 /FOSSL' );

--Load EMS-98 vulnerability values to the taxonomy tables
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 384, 'VULN', 'VULN_EX', 'Exact vulnerability class', null );
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 385, 'VULN', 'VULN_BET', 'Lower and upper class of vulnerability', null );

--Load hazard types to the taxonomy tables
INSERT INTO taxonomy.dic_hazard( gid, code, description, extended_description, attribute_type_code ) VALUES ( 1, 'EQ', 'EQ - Earthquake', null, 'MAT_TYPE' ); 
INSERT INTO taxonomy.dic_hazard( gid, code, description, extended_description, attribute_type_code ) VALUES ( 2, 'EQ', 'EQ - Earthquake', null, 'MAT_TECH' ); 
INSERT INTO taxonomy.dic_hazard( gid, code, description, extended_description, attribute_type_code ) VALUES ( 3, 'EQ', 'EQ - Earthquake', null, 'MAT_PROP' ); 
INSERT INTO taxonomy.dic_hazard( gid, code, description, extended_description, attribute_type_code ) VALUES ( 4, 'EQ', 'EQ - Earthquake', null, 'LLRS' ); 
INSERT INTO taxonomy.dic_hazard( gid, code, description, extended_description, attribute_type_code ) VALUES ( 5, 'EQ', 'EQ - Earthquake', null, 'LLRS_DUCT' ); 
INSERT INTO taxonomy.dic_hazard( gid, code, description, extended_description, attribute_type_code ) VALUES ( 6, 'EQ', 'EQ - Earthquake', null, 'HEIGHT' ); 
INSERT INTO taxonomy.dic_hazard( gid, code, description, extended_description, attribute_type_code ) VALUES ( 7, 'EQ', 'EQ - Earthquake', null, 'YR_BUILT' ); 
INSERT INTO taxonomy.dic_hazard( gid, code, description, extended_description, attribute_type_code ) VALUES ( 8, 'EQ', 'EQ - Earthquake', null, 'OCCUPY' ); 
INSERT INTO taxonomy.dic_hazard( gid, code, description, extended_description, attribute_type_code ) VALUES ( 9, 'EQ', 'EQ - Earthquake', null, 'OCCUPY_DT' ); 
INSERT INTO taxonomy.dic_hazard( gid, code, description, extended_description, attribute_type_code ) VALUES ( 10, 'EQ', 'EQ - Earthquake', null, 'POSITION' ); 
INSERT INTO taxonomy.dic_hazard( gid, code, description, extended_description, attribute_type_code ) VALUES ( 11, 'EQ', 'EQ - Earthquake', null, 'PLAN_SHAPE' ); 
INSERT INTO taxonomy.dic_hazard( gid, code, description, extended_description, attribute_type_code ) VALUES ( 12, 'EQ', 'EQ - Earthquake', null, 'STR_IRREG' ); 
INSERT INTO taxonomy.dic_hazard( gid, code, description, extended_description, attribute_type_code ) VALUES ( 13, 'EQ', 'EQ - Earthquake', null, 'STR_IRREG_DT' ); 
INSERT INTO taxonomy.dic_hazard( gid, code, description, extended_description, attribute_type_code ) VALUES ( 14, 'EQ', 'EQ - Earthquake', null, 'STR_IRREG_TYPE' ); 
INSERT INTO taxonomy.dic_hazard( gid, code, description, extended_description, attribute_type_code ) VALUES ( 15, 'EQ', 'EQ - Earthquake', null, 'NONSTRCEXW' ); 
INSERT INTO taxonomy.dic_hazard( gid, code, description, extended_description, attribute_type_code ) VALUES ( 16, 'EQ', 'EQ - Earthquake', null, 'ROOF_SHAPE' ); 
INSERT INTO taxonomy.dic_hazard( gid, code, description, extended_description, attribute_type_code ) VALUES ( 17, 'EQ', 'EQ - Earthquake', null, 'ROOFCOVMAT' ); 
INSERT INTO taxonomy.dic_hazard( gid, code, description, extended_description, attribute_type_code ) VALUES ( 18, 'EQ', 'EQ - Earthquake', null, 'ROOFSYSMAT' ); 
INSERT INTO taxonomy.dic_hazard( gid, code, description, extended_description, attribute_type_code ) VALUES ( 19, 'EQ', 'EQ - Earthquake', null, 'ROOFSYSTYP' ); 
INSERT INTO taxonomy.dic_hazard( gid, code, description, extended_description, attribute_type_code ) VALUES ( 20, 'EQ', 'EQ - Earthquake', null, 'ROOF_CONN' ); 
INSERT INTO taxonomy.dic_hazard( gid, code, description, extended_description, attribute_type_code ) VALUES ( 21, 'EQ', 'EQ - Earthquake', null, 'FLOOR_MAT' ); 
INSERT INTO taxonomy.dic_hazard( gid, code, description, extended_description, attribute_type_code ) VALUES ( 22, 'EQ', 'EQ - Earthquake', null, 'FLOOR_TYPE' ); 
INSERT INTO taxonomy.dic_hazard( gid, code, description, extended_description, attribute_type_code ) VALUES ( 23, 'EQ', 'EQ - Earthquake', null, 'FLOOR_CONN' ); 
INSERT INTO taxonomy.dic_hazard( gid, code, description, extended_description, attribute_type_code ) VALUES ( 24, 'EQ', 'EQ - Earthquake', null, 'FOUNDN_SYS' ); 
INSERT INTO taxonomy.dic_hazard( gid, code, description, extended_description, attribute_type_code ) VALUES ( 25, 'EQ', 'EQ - Earthquake', null, 'BUILD_TYPE' ); 
INSERT INTO taxonomy.dic_hazard( gid, code, description, extended_description, attribute_type_code ) VALUES ( 26, 'EQ', 'EQ - Earthquake', null, 'BUILD_SUBTYPE' ); 
INSERT INTO taxonomy.dic_hazard( gid, code, description, extended_description, attribute_type_code ) VALUES ( 27, 'EQ', 'EQ - Earthquake', null, 'VULN' );

----------------------------------------------------------------
---------- ADJUST EDITABLE VIEWS FOR RESOLUTION 1 --------------
----------------------------------------------------------------
CREATE EXTENSION IF NOT EXISTS tablefunc;

--------------------------------------
-- resolution 1 view (per-building) --
--------------------------------------
DROP VIEW IF EXISTS object_res1.ve_resolution1;
CREATE OR REPLACE VIEW object_res1.ve_resolution1 AS
  SELECT
   a.*,
   b.*,
   f.vuln_1,
   f.vuln_2,
   c.height_1,
   c.height_2,
   d.*,
   e.yr_built_vt,
   e.yr_built_vt1,
   g.*
  FROM object_res1.main 
AS a
JOIN
  --get attribute values
  (SELECT * FROM crosstab(
	'SELECT object_id, attribute_type_code, attribute_value FROM object_res1.main_detail order by object_id', 'select code from taxonomy.dic_attribute_type order by gid') 
	AS ct(object_id integer, 
	      mat_type varchar, 
	      mat_tech varchar,
	      mat_prop varchar,
	      llrs varchar,
	      llrs_duct varchar,
	      height varchar,
	      yr_built varchar,
	      occupy varchar,
	      occupy_dt varchar,
	      "position" varchar,
	      plan_shape varchar,
	      str_irreg varchar,
	      str_irreg_dt varchar,
	      str_irreg_type varchar,
	      nonstrcexw varchar,
	      roof_shape varchar,
	      roofcovmat varchar,
	      roofsysmat varchar,
	      roofsystyp varchar,
	      roof_conn varchar,
	      floor_mat varchar,
	      floor_type varchar,
	      floor_conn varchar,
	      foundn_sys varchar,
	      build_type varchar,
	      build_subtype varchar,
	      vuln varchar))
AS b ON (a.gid = b.object_id)
LEFT OUTER JOIN  --do a left outer join because of the where statement in the select 
  --get height values
  (SELECT object_id, attribute_numeric_1 as height_1, attribute_numeric_2 as height_2 FROM object_res1.main_detail WHERE attribute_type_code = 'HEIGHT') 
AS c ON (a.gid = c.object_id)
JOIN
  --get belief values for the attribute values
  (SELECT * FROM crosstab(
	'SELECT object_id, attribute_type_code, qualifier_numeric_1 FROM (SELECT * FROM object_res1.main_detail as a
				JOIN (SELECT * FROM object_res1.main_detail_qualifier WHERE qualifier_type_code=''BELIEF'') as b
				ON (a.gid = b.detail_id)) sub ORDER BY object_id', 
	'SELECT code from taxonomy.dic_attribute_type order by gid') 
	AS a (object_id1 integer, 
	      mat_type_bp integer, 
	      mat_tech_bp integer,
	      mat_prop_bp integer,
	      llrs_bp integer,
	      llrs_duct_bp integer,
	      height_bp integer,
	      yr_built_bp integer,
	      occupy_bp integer,
	      occupy_dt_bp integer,
	      position_bp integer,
	      plan_shape_bp integer,
	      str_irreg_bp integer,
	      str_irreg_dt_bp integer,
	      str_irreg_type_bp integer,
	      nonstrcexw_bp integer,
	      roof_shape_bp integer,
	      roofcovmat_bp integer,
	      roofsysmat_bp integer,
	      roofsystyp_bp integer,
	      roof_conn_bp integer,
	      floor_mat_bp integer,
	      floor_type_bp integer,
	      floor_conn_bp integer,
	      foundn_sys_bp integer,
	      build_type_bp integer,
	      build_subtype_bp integer,
	      vuln_bp integer))
AS d ON (a.gid = d.object_id1)
LEFT OUTER JOIN --do a left outer join because of the where statement in the select crosstab()
  --get valid time values (yr_built_1, yr_built_2)
  (SELECT object_id, qualifier_value as yr_built_vt, qualifier_timestamp_1 as yr_built_vt1 FROM (SELECT * FROM object_res1.main_detail as a
				JOIN object_res1.main_detail_qualifier as b
				ON (a.gid = b.detail_id)) sub WHERE attribute_type_code = 'YR_BUILT' AND qualifier_type_code = 'VALIDTIME' ORDER BY object_id)  
AS e ON (a.gid = e.object_id)
LEFT OUTER JOIN  --do a left outer join because of the where statement in the select 
  --get vulnerability values
  (SELECT object_id, attribute_numeric_1 as vuln_1, attribute_numeric_2 as vuln_2 FROM object_res1.main_detail WHERE attribute_type_code = 'VULN') 
AS f ON (a.gid = f.object_id)
JOIN
  --get source values for the attribute values
  (SELECT * FROM crosstab(
	'SELECT object_id, attribute_type_code, qualifier_value FROM (SELECT * FROM object_res1.main_detail as a
				JOIN (SELECT * FROM object_res1.main_detail_qualifier WHERE qualifier_type_code=''SOURCE'') as b
				ON (a.gid = b.detail_id)) sub ORDER BY object_id', 
	'SELECT code from taxonomy.dic_attribute_type order by gid') 
	AS ct (object_id2 integer,
	      mat_type_src varchar, 
	      mat_tech_src varchar,
	      mat_prop_src varchar,
	      llrs_src varchar,
	      llrs_duct_src varchar,
	      height_src varchar,
	      yr_built_src varchar,
	      occupy_src varchar,
	      occupy_dt_src varchar,
	      position_src varchar,
	      plan_shape_src varchar,
	      str_irreg_src varchar,
	      str_irreg_dt_src varchar,
	      str_irreg_type_src varchar,
	      nonstrcexw_src varchar,
	      roof_shape_src varchar,
	      roofcovmat_src varchar,
	      roofsysmat_src varchar,
	      roofsystyp_src varchar,
	      roof_conn_src varchar,
	      floor_mat_src varchar,
	      floor_type_src varchar,
	      floor_conn_src varchar,
	      foundn_sys_src varchar,
	      build_type_src varchar,
	      build_subtype_src varchar,
	      vuln_src varchar))
AS g ON (a.gid = g.object_id2)
ORDER BY gid ASC;

--set default attribute values
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN MAT_TYPE SET DEFAULT 'MAT99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN MAT_TECH SET DEFAULT 'MATT99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN MAT_PROP SET DEFAULT 'MATP99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN LLRS SET DEFAULT 'L99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN LLRS_DUCT SET DEFAULT 'DU99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN HEIGHT SET DEFAULT 'H99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN YR_BUILT SET DEFAULT 'Y99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN OCCUPY SET DEFAULT 'OC99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN OCCUPY_DT SET DEFAULT 'OCCDT99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN POSITION SET DEFAULT 'BP99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN PLAN_SHAPE SET DEFAULT 'PLF99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN STR_IRREG SET DEFAULT 'IR99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN STR_IRREG_DT SET DEFAULT 'IRP99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN STR_IRREG_TYPE SET DEFAULT 'IRT99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN NONSTRCEXW SET DEFAULT 'EW99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN ROOF_SHAPE SET DEFAULT 'R99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN ROOFCOVMAT SET DEFAULT 'RMT99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN ROOFSYSMAT SET DEFAULT 'RSM99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN ROOFSYSTYP SET DEFAULT 'RST99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN ROOF_CONN SET DEFAULT 'RCN99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN FLOOR_MAT SET DEFAULT 'F99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN FLOOR_TYPE SET DEFAULT 'FT99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN FLOOR_CONN SET DEFAULT 'FWC99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN FOUNDN_SYS SET DEFAULT 'FOS99'::character varying;

------------------------------------
-- make resolution1 view editable --
------------------------------------
CREATE OR REPLACE FUNCTION object_res1.edit_resolution_view()
RETURNS TRIGGER AS 
$BODY$
BEGIN
      IF TG_OP = 'INSERT' THEN
       INSERT INTO object_res1.main (gid, survey_gid, source, accuracy, description, res2_id, res3_id, the_geom) VALUES (DEFAULT, NEW.survey_gid, NEW.source, NEW.accuracy, NEW.description, NEW.res2_id, NEW.res3_id, NEW.the_geom);
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'MAT_TYPE', NEW.mat_type);
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'MAT_TECH', NEW.mat_tech);
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'MAT_PROP', NEW.mat_prop);
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'LLRS', NEW.llrs);
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'LLRS_DUCT', NEW.llrs_duct);
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value, attribute_numeric_1, attribute_numeric_2) VALUES ((SELECT max(gid) FROM object_res1.main), 'HEIGHT', NEW.height, NEW.height_1, NEW.height_2);
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'YR_BUILT', NEW.yr_built);
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'OCCUPY', NEW.occupy);
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'OCCUPY_DT', NEW.occupy_dt);
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'POSITION', NEW."position");
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'PLAN_SHAPE', NEW.plan_shape);
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'STR_IRREG', NEW.str_irreg);
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'STR_IRREG_DT', NEW.str_irreg_dt);
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'STR_IRREG_TYPE', NEW.str_irreg_type);
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'NONSTRCEXW', NEW.nonstrcexw);
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'ROOF_SHAPE', NEW.roof_shape);
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'ROOFCOVMAT', NEW.roofcovmat);
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'ROOFSYSMAT', NEW.roofsysmat);	 
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'ROOFSYSTYP', NEW.roofsystyp);
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'ROOF_CONN', NEW.roof_conn);    
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'FLOOR_MAT', NEW.floor_mat);
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'FLOOR_TYPE', NEW.floor_type);
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'FLOOR_CONN', NEW.floor_conn);       
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'FOUNDN_SYS', NEW.foundn_sys);       
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'BUILD_TYPE', NEW.build_type);       
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'BUILD_SUBTYPE', NEW.build_subtype);       
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value, attribute_numeric_1, attribute_numeric_2) VALUES ((SELECT max(gid) FROM object_res1.main), 'VULN', NEW.vuln, NEW.vuln_1, NEW.vuln_2);       
       
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='MAT_TYPE'), 'BELIEF', 'BP', NEW.mat_type_bp);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='MAT_TECH'), 'BELIEF', 'BP', NEW.mat_tech_bp);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='MAT_PROP'), 'BELIEF', 'BP', NEW.mat_prop_bp);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='LLRS'), 'BELIEF', 'BP', NEW.llrs_bp);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='LLRS_DUCT'), 'BELIEF', 'BP', NEW.llrs_duct_bp);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='HEIGHT'), 'BELIEF', 'BP', NEW.height_bp);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='YR_BUILT'), 'BELIEF', 'BP', NEW.yr_built_bp);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='OCCUPY'), 'BELIEF', 'BP', NEW.occupy_bp);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='OCCUPY_DT'), 'BELIEF', 'BP', NEW.occupy_dt_bp);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='POSITION'), 'BELIEF', 'BP', NEW.position_bp);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='PLAN_SHAPE'), 'BELIEF', 'BP', NEW.plan_shape_bp);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='STR_IRREG'), 'BELIEF', 'BP', NEW.str_irreg_bp);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='STR_IRREG_DT'), 'BELIEF', 'BP', NEW.str_irreg_dt_bp);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='STR_IRREG_TYPE'), 'BELIEF', 'BP', NEW.str_irreg_type_bp);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='NONSTRCEXW'), 'BELIEF', 'BP', NEW.nonstrcexw_bp);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='ROOF_SHAPE'), 'BELIEF', 'BP', NEW.roof_shape_bp);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='ROOFCOVMAT'), 'BELIEF', 'BP', NEW.roofcovmat_bp);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='ROOFSYSMAT'), 'BELIEF', 'BP', NEW.roofsysmat_bp);	 
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='ROOFSYSTYP'), 'BELIEF', 'BP', NEW.roofsystyp_bp);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='ROOF_CONN'), 'BELIEF', 'BP', NEW.roof_conn_bp);    
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='FLOOR_MAT'), 'BELIEF', 'BP', NEW.floor_mat_bp);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='FLOOR_TYPE'), 'BELIEF', 'BP', NEW.floor_type_bp);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='FLOOR_CONN'), 'BELIEF', 'BP', NEW.floor_conn_bp);       
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='FOUNDN_SYS'), 'BELIEF', 'BP', NEW.foundn_sys_bp);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='BUILD_TYPE'), 'BELIEF', 'BP', NEW.build_type_bp);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='BUILD_SUBTYPE'), 'BELIEF', 'BP', NEW.build_subtype_bp);  
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='VULN'), 'BELIEF', 'BP', NEW.vuln_bp);      
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_timestamp_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='YR_BUILT'), 'VALIDTIME', NEW.yr_built_vt, NEW.yr_built_vt1);

       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='MAT_TYPE'), 'SOURCE', NEW.mat_type_src);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='MAT_TECH'), 'SOURCE', NEW.mat_tech_src);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='MAT_PROP'), 'SOURCE', NEW.mat_prop_src);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='LLRS'), 'SOURCE', NEW.llrs_src);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='LLRS_DUCT'), 'SOURCE', NEW.llrs_duct_src);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='HEIGHT'), 'SOURCE', NEW.height_src);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='YR_BUILT'), 'SOURCE', NEW.yr_built_src);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='OCCUPY'), 'SOURCE', NEW.occupy_src);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='OCCUPY_DT'), 'SOURCE', NEW.occupy_dt_src);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='POSITION'), 'SOURCE', NEW.position_src);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='PLAN_SHAPE'), 'SOURCE', NEW.plan_shape_src);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='STR_IRREG'), 'SOURCE', NEW.str_irreg_src);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='STR_IRREG_DT'), 'SOURCE', NEW.str_irreg_dt_src);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='STR_IRREG_TYPE'), 'SOURCE', NEW.str_irreg_type_src);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='NONSTRCEXW'), 'SOURCE', NEW.nonstrcexw_src);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='ROOF_SHAPE'), 'SOURCE', NEW.roof_shape_src);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='ROOFCOVMAT'), 'SOURCE', NEW.roofcovmat_src);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='ROOFSYSMAT'), 'SOURCE', NEW.roofsysmat_src);	 
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='ROOFSYSTYP'), 'SOURCE', NEW.roofsystyp_src);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='ROOF_CONN'), 'SOURCE', NEW.roof_conn_src);    
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='FLOOR_MAT'), 'SOURCE', NEW.floor_mat_src);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='FLOOR_TYPE'), 'SOURCE', NEW.floor_type_src);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='FLOOR_CONN'), 'SOURCE', NEW.floor_conn_src);       
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='FOUNDN_SYS'), 'SOURCE', NEW.foundn_sys_src);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='BUILD_TYPE'), 'SOURCE', NEW.build_type_src);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='BUILD_SUBTYPE'), 'SOURCE', NEW.build_subtype_src);  
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='VULN'), 'SOURCE', NEW.vuln_src);
 
       RETURN NEW;

      ELSIF TG_OP = 'UPDATE' THEN
       UPDATE object_res1.main SET survey_gid=NEW.survey_gid, source=NEW.source, accuracy=NEW.accuracy, description=NEW.description, res2_id=NEW.res2_id, res3_id=NEW.res3_id, the_geom=NEW.the_geom 
        WHERE gid=OLD.gid;
       --TODO: UPDATE ONLY IF DETAIL IS AVAILABLE, ELSE INSERT THE DETAIL
       UPDATE object_res1.main_detail SET attribute_value=NEW.mat_type WHERE object_id=OLD.gid AND attribute_type_code='MAT_TYPE';
       UPDATE object_res1.main_detail SET attribute_value=NEW.mat_tech WHERE object_id=OLD.gid AND attribute_type_code='MAT_TECH';
       UPDATE object_res1.main_detail SET attribute_value=NEW.mat_prop WHERE object_id=OLD.gid AND attribute_type_code='MAT_PROP';
       UPDATE object_res1.main_detail SET attribute_value=NEW.llrs WHERE object_id=OLD.gid AND attribute_type_code='LLRS';	
       UPDATE object_res1.main_detail SET attribute_value=NEW.llrs_duct WHERE object_id=OLD.gid AND attribute_type_code='LLRS_DUCT';
       UPDATE object_res1.main_detail SET attribute_value=NEW.height WHERE object_id=OLD.gid AND attribute_type_code='HEIGHT';
       UPDATE object_res1.main_detail SET attribute_value=NEW.yr_built WHERE object_id=OLD.gid AND attribute_type_code='YR_BUILT';
       UPDATE object_res1.main_detail SET attribute_value=NEW.occupy WHERE object_id=OLD.gid AND attribute_type_code='OCCUPY';
       UPDATE object_res1.main_detail SET attribute_value=NEW.occupy_dt WHERE object_id=OLD.gid AND attribute_type_code='OCCUPY_DT';
       UPDATE object_res1.main_detail SET attribute_value=NEW."position" WHERE object_id=OLD.gid AND attribute_type_code='POSITION';	
       UPDATE object_res1.main_detail SET attribute_value=NEW.plan_shape WHERE object_id=OLD.gid AND attribute_type_code='PLAN_SHAPE';
       UPDATE object_res1.main_detail SET attribute_value=NEW.str_irreg WHERE object_id=OLD.gid AND attribute_type_code='STR_IRREG';
       UPDATE object_res1.main_detail SET attribute_value=NEW.str_irreg_dt WHERE object_id=OLD.gid AND attribute_type_code='STR_IRREG_DT';
       UPDATE object_res1.main_detail SET attribute_value=NEW.str_irreg_type WHERE object_id=OLD.gid AND attribute_type_code='STR_IRREG_TYPE';
       UPDATE object_res1.main_detail SET attribute_value=NEW.nonstrcexw WHERE object_id=OLD.gid AND attribute_type_code='NONSTRCEXW';
       UPDATE object_res1.main_detail SET attribute_value=NEW.roof_shape WHERE object_id=OLD.gid AND attribute_type_code='ROOF_SHAPE';	
       UPDATE object_res1.main_detail SET attribute_value=NEW.roofcovmat WHERE object_id=OLD.gid AND attribute_type_code='ROOFCOVMAT';
       UPDATE object_res1.main_detail SET attribute_value=NEW.roofsystyp WHERE object_id=OLD.gid AND attribute_type_code='ROOFSYSTYP';
       UPDATE object_res1.main_detail SET attribute_value=NEW.roof_conn WHERE object_id=OLD.gid AND attribute_type_code='ROOF_CONN';
       UPDATE object_res1.main_detail SET attribute_value=NEW.floor_mat WHERE object_id=OLD.gid AND attribute_type_code='FLOOR_MAT';
       UPDATE object_res1.main_detail SET attribute_value=NEW.floor_type WHERE object_id=OLD.gid AND attribute_type_code='FLOOR_TYPE';
       UPDATE object_res1.main_detail SET attribute_value=NEW.floor_conn WHERE object_id=OLD.gid AND attribute_type_code='FLOOR_CONN';
       UPDATE object_res1.main_detail SET attribute_value=NEW.foundn_sys WHERE object_id=OLD.gid AND attribute_type_code='FOUNDN_SYS';
       UPDATE object_res1.main_detail SET attribute_value=NEW.build_type WHERE object_id=OLD.gid AND attribute_type_code='BUILD_TYPE';
       UPDATE object_res1.main_detail SET attribute_value=NEW.build_subtype WHERE object_id=OLD.gid AND attribute_type_code='BUILD_SUBTYPE';
       UPDATE object_res1.main_detail SET attribute_value=NEW.vuln WHERE object_id=OLD.gid AND attribute_type_code='VULN';
       UPDATE object_res1.main_detail SET attribute_numeric_1=NEW.vuln_1 WHERE object_id=OLD.gid AND attribute_type_code='VULN';
       UPDATE object_res1.main_detail SET attribute_numeric_2=NEW.vuln_2 WHERE object_id=OLD.gid AND attribute_type_code='VULN';
       UPDATE object_res1.main_detail SET attribute_numeric_1=NEW.height_1 WHERE object_id=OLD.gid AND attribute_type_code='HEIGHT';
       UPDATE object_res1.main_detail SET attribute_numeric_2=NEW.height_2 WHERE object_id=OLD.gid AND attribute_type_code='HEIGHT';

       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.mat_type_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='MAT_TYPE') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.mat_tech_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='MAT_TECH') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.mat_prop_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='MAT_PROP') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.llrs_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='LLRS') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.llrs_duct_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='LLRS_DUCT') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.height_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='HEIGHT') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.yr_built_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='YR_BUILT') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.occupy_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='OCCUPY') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.occupy_dt_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='OCCUPY_DT') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.position_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='POSITION') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.plan_shape_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='PLAN_SHAPE') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.str_irreg_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='STR_IRREG') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.str_irreg_dt_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='STR_IRREG_DT') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.str_irreg_type_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='STR_IRREG_TYPE') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.nonstrcexw_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='NONSTRCEXW') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.roof_shape_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='ROOF_SHAPE') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.roofcovmat_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='ROOFCOVMAT') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.roofsysmat_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='ROOFSYSMAT') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.roofsystyp_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='ROOFSYSTYP') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.roof_conn_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='ROOF_CONN') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.floor_mat_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='FLOOR_MAT') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.floor_type_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='FLOOR_TYPE') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.floor_conn_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='FLOOR_CONN') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.foundn_sys_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='FOUNDN_SYS') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.build_type_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='BUILD_TYPE') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.build_subtype_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='BUILD_SUBTYPE') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.vuln_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='VULN') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.yr_built_vt WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='YR_BUILT') AND qualifier_type_code='VALIDTIME';
       UPDATE object_res1.main_detail_qualifier SET qualifier_timestamp_1=NEW.yr_built_vt1 WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='YR_BUILT') AND qualifier_type_code='VALIDTIME'; 
       
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.mat_type_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='MAT_TYPE') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.mat_tech_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='MAT_TECH') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.mat_prop_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='MAT_PROP') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.llrs_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='LLRS') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.llrs_duct_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='LLRS_DUCT') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.height_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='HEIGHT') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.yr_built_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='YR_BUILT') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.occupy_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='OCCUPY') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.occupy_dt_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='OCCUPY_DT') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.position_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='POSITION') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.plan_shape_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='PLAN_SHAPE') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.str_irreg_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='STR_IRREG') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.str_irreg_dt_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='STR_IRREG_DT') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.str_irreg_type_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='STR_IRREG_TYPE') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.nonstrcexw_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='NONSTRCEXW') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.roof_shape_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='ROOF_SHAPE') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.roofcovmat_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='ROOFCOVMAT') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.roofsysmat_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='ROOFSYSMAT') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.roofsystyp_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='ROOFSYSTYP') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.roof_conn_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='ROOF_CONN') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.floor_mat_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='FLOOR_MAT') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.floor_type_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='FLOOR_TYPE') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.floor_conn_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='FLOOR_CONN') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.foundn_sys_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='FOUNDN_SYS') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.build_type_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='BUILD_TYPE') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.build_subtype_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='BUILD_SUBTYPE') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.vuln_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='VULN') AND qualifier_type_code='SOURCE';

       RETURN NEW;

      ELSIF TG_OP = 'DELETE' THEN
       DELETE FROM object_res1.main_detail_qualifier WHERE detail_id IN (SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid);
       DELETE FROM object_res1.main_detail WHERE object_id=OLD.gid;
       DELETE FROM object_res1.main WHERE gid=OLD.gid;
       --workaround to include row information after delete (because it is not possible to define a AFTER FOR EACH ROW trigger on a view)
       IF EXISTS (SELECT event_object_schema, trigger_name FROM information_schema.triggers WHERE event_object_schema = 'object_res1' AND trigger_name = 'zhistory_trigger_row') THEN
	       INSERT INTO history.logged_actions VALUES(
	        NEXTVAL('history.logged_actions_gid_seq'),    -- gid
		TG_TABLE_SCHEMA::text,                        -- schema_name
		TG_TABLE_NAME::text,                          -- table_name
		TG_RELID,                                     -- relation OID for much quicker searches
		txid_current(),                               -- transaction_id
		session_user::text,                           -- transaction_user
		current_timestamp,                            -- transaction_time
		NULL,                              	      -- top-level query or queries (if multistatement) from client
		'D',					      -- transaction_type
		hstore(OLD.*), NULL, NULL);                   -- old_record, new_record, changed_fields
	END IF;
       RETURN NULL;
      END IF;
      RETURN NEW;
END;
$BODY$ 
LANGUAGE 'plpgsql';

COMMENT ON FUNCTION object_res1.edit_resolution_view() IS $body$
This function makes the resolution 1 view (adjusted for the rrvs) editable and forwards the edits to the underlying tables.
$body$;

DROP TRIGGER IF EXISTS res1_trigger ON object_res1.ve_resolution1;
CREATE TRIGGER res1_trigger
    INSTEAD OF INSERT OR UPDATE OR DELETE ON object_res1.ve_resolution1 
      FOR EACH ROW 
      EXECUTE PROCEDURE object_res1.edit_resolution_view();


-------------------------------------------
-- resolution 1 view data (per-building) --
-------------------------------------------
DROP VIEW IF EXISTS object_res1.v_resolution1_data;
CREATE OR REPLACE VIEW object_res1.v_resolution1_data AS
  SELECT
   a.*,
   b.*,
   e.vuln_1,
   e.vuln_2,
   c.height_1,
   c.height_2,
   d.yr_built_vt,
   d.yr_built_vt1
  FROM object_res1.main 
AS a
JOIN
  --get attribute values
  (SELECT * FROM crosstab(
	'SELECT object_id, attribute_type_code, attribute_value FROM object_res1.main_detail order by object_id', 'select code from taxonomy.dic_attribute_type order by gid') 
	AS ct(object_id integer, 
	      mat_type varchar, 
	      mat_tech varchar,
	      mat_prop varchar,
	      llrs varchar,
	      llrs_duct varchar,
	      height varchar,
	      yr_built varchar,
	      occupy varchar,
	      occupy_dt varchar,
	      "position" varchar,
	      plan_shape varchar,
	      str_irreg varchar,
	      str_irreg_dt varchar,
	      str_irreg_type varchar,
	      nonstrcexw varchar,
	      roof_shape varchar,
	      roofcovmat varchar,
	      roofsysmat varchar,
	      roofsystyp varchar,
	      roof_conn varchar,
	      floor_mat varchar,
	      floor_type varchar,
	      floor_conn varchar,
	      foundn_sys varchar,
	      build_type varchar,
	      build_subtype varchar,
	      vuln varchar))
AS b ON (a.gid = b.object_id)
LEFT OUTER JOIN  --do a left outer join because of the where statement in the select 
  --get height values
  (SELECT object_id, attribute_numeric_1 as height_1, attribute_numeric_2 as height_2 FROM object_res1.main_detail WHERE attribute_type_code = 'HEIGHT') 
AS c ON (a.gid = c.object_id)
LEFT OUTER JOIN --do a left outer join because of the where statement in the select crosstab()
  --get valid time values (yr_built_1, yr_built_2)
  (SELECT object_id, qualifier_value as yr_built_vt, qualifier_timestamp_1 as yr_built_vt1 FROM (SELECT * FROM object_res1.main_detail as a
				JOIN object_res1.main_detail_qualifier as b
				ON (a.gid = b.detail_id)) sub WHERE attribute_type_code = 'YR_BUILT' AND qualifier_type_code = 'VALIDTIME' ORDER BY object_id)  
AS d ON (a.gid = d.object_id)
LEFT OUTER JOIN  --do a left outer join because of the where statement in the select 
  --get vulnerability values
  (SELECT object_id, attribute_numeric_1 as vuln_1, attribute_numeric_2 as vuln_2 FROM object_res1.main_detail WHERE attribute_type_code = 'VULN') 
AS e ON (a.gid = e.object_id)
ORDER BY gid ASC;


-------------------------------------------------------
-- resolution 1 view metadata summary (per-building) --
-------------------------------------------------------
DROP VIEW IF EXISTS object_res1.v_resolution1_metadata;
CREATE OR REPLACE VIEW object_res1.v_resolution1_metadata AS
	SELECT 'THE_GEOM' as attribute_type, 
	       'Object geometry' as description, 
	       array(SELECT distinct(source) FROM object_res1.main) as source, 
	       'BP' as belief_type,
	       avg(accuracy) as avg_belief 
	       FROM object_res1.main
	UNION
	SELECT b.attribute_type_code as attribute_type,
	       c.description as description,
	       array(SELECT distinct(qualifier_value) FROM object_res1.main_detail_qualifier WHERE qualifier_type_code='SOURCE') as source,
	       (SELECT distinct(qualifier_value) FROM object_res1.main_detail_qualifier WHERE qualifier_type_code='BELIEF') as belief_type,
	       avg(qualifier_numeric_1) AS avg_belief
		FROM object_res1.main_detail_qualifier a
	JOIN object_res1.main_detail b ON (a.detail_id = b.gid)
	JOIN taxonomy.dic_attribute_type c ON (b.attribute_type_code = c.code)
		GROUP BY attribute_type, description, belief_type, source ORDER BY attribute_type;
		

-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
-- Name: RRVSTOOL panoimage schema 
-- Version: 0.0.1
-- Date: 24.04.15
-- Author: M. Wieland
-- DBMS: PostgreSQL9.2 / PostGIS2.0
-- Description: Adds the panoimg schema and related tables to the database model
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

CREATE SCHEMA panoimg;

CREATE TABLE panoimg.gps
(
  gid integer,
  img_id integer,
  altitude numeric,
  azimuth numeric,
  abspeed numeric,
  the_geom geometry
);

CREATE TABLE panoimg.img
(
  gid integer,
  source text,
  acqdate character varying(254),
  acqtime character varying(254)
);

