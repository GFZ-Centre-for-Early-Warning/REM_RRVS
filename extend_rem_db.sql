CREATE SCHEMA users;

SET search_path = asset, pg_catalog;

DROP VIEW v_object_data;

DROP VIEW ve_object;

CREATE OR REPLACE FUNCTION edit_object_view() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
      IF TG_OP = 'INSERT' THEN
       INSERT INTO asset.object (gid, survey_gid, source, accuracy, description, the_geom) VALUES (DEFAULT, NEW.survey_gid, NEW.source, NEW.accuracy, NEW.description, NEW.the_geom);
       INSERT INTO asset.object_attribute (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM asset.object), 'MAT_TYPE', NEW.mat_type);
       INSERT INTO asset.object_attribute (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM asset.object), 'MAT_TECH', NEW.mat_tech);
       INSERT INTO asset.object_attribute (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM asset.object), 'MAT_PROP', NEW.mat_prop);
       INSERT INTO asset.object_attribute (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM asset.object), 'LLRS', NEW.llrs);
       INSERT INTO asset.object_attribute (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM asset.object), 'LLRS_DUCT', NEW.llrs_duct);
       INSERT INTO asset.object_attribute (object_id, attribute_type_code, attribute_value, attribute_numeric_1, attribute_numeric_2) VALUES ((SELECT max(gid) FROM asset.object), 'HEIGHT', NEW.height, NEW.height_1, NEW.height_2);
       INSERT INTO asset.object_attribute (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM asset.object), 'YR_BUILT', NEW.yr_built);
       INSERT INTO asset.object_attribute (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM asset.object), 'OCCUPY', NEW.occupy);
       INSERT INTO asset.object_attribute (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM asset.object), 'OCCUPY_DT', NEW.occupy_dt);
       INSERT INTO asset.object_attribute (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM asset.object), 'POSITION', NEW."position");
       INSERT INTO asset.object_attribute (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM asset.object), 'PLAN_SHAPE', NEW.plan_shape);
       INSERT INTO asset.object_attribute (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM asset.object), 'STR_IRREG', NEW.str_irreg);
       INSERT INTO asset.object_attribute (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM asset.object), 'STR_IRREG_DT', NEW.str_irreg_dt);
       INSERT INTO asset.object_attribute (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM asset.object), 'STR_IRREG_TYPE', NEW.str_irreg_type);
       INSERT INTO asset.object_attribute (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM asset.object), 'NONSTRCEXW', NEW.nonstrcexw);
       INSERT INTO asset.object_attribute (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM asset.object), 'ROOF_SHAPE', NEW.roof_shape);
       INSERT INTO asset.object_attribute (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM asset.object), 'ROOFCOVMAT', NEW.roofcovmat);
       INSERT INTO asset.object_attribute (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM asset.object), 'ROOFSYSMAT', NEW.roofsysmat);     
       INSERT INTO asset.object_attribute (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM asset.object), 'ROOFSYSTYP', NEW.roofsystyp);
       INSERT INTO asset.object_attribute (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM asset.object), 'ROOF_CONN', NEW.roof_conn);    
       INSERT INTO asset.object_attribute (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM asset.object), 'FLOOR_MAT', NEW.floor_mat);
       INSERT INTO asset.object_attribute (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM asset.object), 'FLOOR_TYPE', NEW.floor_type);
       INSERT INTO asset.object_attribute (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM asset.object), 'FLOOR_CONN', NEW.floor_conn);       
       INSERT INTO asset.object_attribute (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM asset.object), 'FOUNDN_SYS', NEW.foundn_sys);       
       INSERT INTO asset.object_attribute (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM asset.object), 'BUILD_TYPE', NEW.build_type);       
       INSERT INTO asset.object_attribute (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM asset.object), 'BUILD_SUBTYPE', NEW.build_subtype);       
       INSERT INTO asset.object_attribute (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM asset.object), 'RRVS_STATUS', NEW.rrvs_status);
       INSERT INTO asset.object_attribute (object_id, attribute_type_code, attribute_value, attribute_numeric_1, attribute_numeric_2) VALUES ((SELECT max(gid) FROM asset.object), 'VULN', NEW.vuln, NEW.vuln_1, NEW.vuln_2);       
       
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='MAT_TYPE'), 'BELIEF', 'BP', NEW.mat_type_bp);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='MAT_TECH'), 'BELIEF', 'BP', NEW.mat_tech_bp);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='MAT_PROP'), 'BELIEF', 'BP', NEW.mat_prop_bp);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='LLRS'), 'BELIEF', 'BP', NEW.llrs_bp);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='LLRS_DUCT'), 'BELIEF', 'BP', NEW.llrs_duct_bp);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='HEIGHT'), 'BELIEF', 'BP', NEW.height_bp);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='YR_BUILT'), 'BELIEF', 'BP', NEW.yr_built_bp);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='OCCUPY'), 'BELIEF', 'BP', NEW.occupy_bp);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='OCCUPY_DT'), 'BELIEF', 'BP', NEW.occupy_dt_bp);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='POSITION'), 'BELIEF', 'BP', NEW.position_bp);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='PLAN_SHAPE'), 'BELIEF', 'BP', NEW.plan_shape_bp);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='STR_IRREG'), 'BELIEF', 'BP', NEW.str_irreg_bp);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='STR_IRREG_DT'), 'BELIEF', 'BP', NEW.str_irreg_dt_bp);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='STR_IRREG_TYPE'), 'BELIEF', 'BP', NEW.str_irreg_type_bp);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='NONSTRCEXW'), 'BELIEF', 'BP', NEW.nonstrcexw_bp);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='ROOF_SHAPE'), 'BELIEF', 'BP', NEW.roof_shape_bp);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='ROOFCOVMAT'), 'BELIEF', 'BP', NEW.roofcovmat_bp);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='ROOFSYSMAT'), 'BELIEF', 'BP', NEW.roofsysmat_bp);     
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='ROOFSYSTYP'), 'BELIEF', 'BP', NEW.roofsystyp_bp);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='ROOF_CONN'), 'BELIEF', 'BP', NEW.roof_conn_bp);    
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='FLOOR_MAT'), 'BELIEF', 'BP', NEW.floor_mat_bp);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='FLOOR_TYPE'), 'BELIEF', 'BP', NEW.floor_type_bp);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='FLOOR_CONN'), 'BELIEF', 'BP', NEW.floor_conn_bp);       
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='FOUNDN_SYS'), 'BELIEF', 'BP', NEW.foundn_sys_bp);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='BUILD_TYPE'), 'BELIEF', 'BP', NEW.build_type_bp);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='BUILD_SUBTYPE'), 'BELIEF', 'BP', NEW.build_subtype_bp);  
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='VULN'), 'BELIEF', 'BP', NEW.vuln_bp);      
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_timestamp_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='YR_BUILT'), 'VALIDTIME', NEW.yr_built_vt, NEW.yr_built_vt1);

       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='MAT_TYPE'), 'SOURCE', NEW.mat_type_src);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='MAT_TECH'), 'SOURCE', NEW.mat_tech_src);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='MAT_PROP'), 'SOURCE', NEW.mat_prop_src);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='LLRS'), 'SOURCE', NEW.llrs_src);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='LLRS_DUCT'), 'SOURCE', NEW.llrs_duct_src);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='HEIGHT'), 'SOURCE', NEW.height_src);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='YR_BUILT'), 'SOURCE', NEW.yr_built_src);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='OCCUPY'), 'SOURCE', NEW.occupy_src);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='OCCUPY_DT'), 'SOURCE', NEW.occupy_dt_src);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='POSITION'), 'SOURCE', NEW.position_src);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='PLAN_SHAPE'), 'SOURCE', NEW.plan_shape_src);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='STR_IRREG'), 'SOURCE', NEW.str_irreg_src);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='STR_IRREG_DT'), 'SOURCE', NEW.str_irreg_dt_src);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='STR_IRREG_TYPE'), 'SOURCE', NEW.str_irreg_type_src);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='NONSTRCEXW'), 'SOURCE', NEW.nonstrcexw_src);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='ROOF_SHAPE'), 'SOURCE', NEW.roof_shape_src);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='ROOFCOVMAT'), 'SOURCE', NEW.roofcovmat_src);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='ROOFSYSMAT'), 'SOURCE', NEW.roofsysmat_src);     
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='ROOFSYSTYP'), 'SOURCE', NEW.roofsystyp_src);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='ROOF_CONN'), 'SOURCE', NEW.roof_conn_src);    
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='FLOOR_MAT'), 'SOURCE', NEW.floor_mat_src);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='FLOOR_TYPE'), 'SOURCE', NEW.floor_type_src);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='FLOOR_CONN'), 'SOURCE', NEW.floor_conn_src);       
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='FOUNDN_SYS'), 'SOURCE', NEW.foundn_sys_src);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='BUILD_TYPE'), 'SOURCE', NEW.build_type_src);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='BUILD_SUBTYPE'), 'SOURCE', NEW.build_subtype_src);  
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='VULN'), 'SOURCE', NEW.vuln_src);
 
       RETURN NEW;

      ELSIF TG_OP = 'UPDATE' THEN
       UPDATE asset.object SET survey_gid=NEW.survey_gid, source=NEW.source, accuracy=NEW.accuracy, description=NEW.description, the_geom=NEW.the_geom 
        WHERE gid=OLD.gid;
       --TODO: UPDATE ONLY IF DETAIL IS AVAILABLE, ELSE INSERT THE DETAIL
       UPDATE asset.object_attribute SET attribute_value=NEW.mat_type WHERE object_id=OLD.gid AND attribute_type_code='MAT_TYPE';
       UPDATE asset.object_attribute SET attribute_value=NEW.mat_tech WHERE object_id=OLD.gid AND attribute_type_code='MAT_TECH';
       UPDATE asset.object_attribute SET attribute_value=NEW.mat_prop WHERE object_id=OLD.gid AND attribute_type_code='MAT_PROP';
       UPDATE asset.object_attribute SET attribute_value=NEW.llrs WHERE object_id=OLD.gid AND attribute_type_code='LLRS';    
       UPDATE asset.object_attribute SET attribute_value=NEW.llrs_duct WHERE object_id=OLD.gid AND attribute_type_code='LLRS_DUCT';
       UPDATE asset.object_attribute SET attribute_value=NEW.height WHERE object_id=OLD.gid AND attribute_type_code='HEIGHT';
       UPDATE asset.object_attribute SET attribute_value=NEW.yr_built WHERE object_id=OLD.gid AND attribute_type_code='YR_BUILT';
       UPDATE asset.object_attribute SET attribute_value=NEW.occupy WHERE object_id=OLD.gid AND attribute_type_code='OCCUPY';
       UPDATE asset.object_attribute SET attribute_value=NEW.occupy_dt WHERE object_id=OLD.gid AND attribute_type_code='OCCUPY_DT';
       UPDATE asset.object_attribute SET attribute_value=NEW."position" WHERE object_id=OLD.gid AND attribute_type_code='POSITION';    
       UPDATE asset.object_attribute SET attribute_value=NEW.plan_shape WHERE object_id=OLD.gid AND attribute_type_code='PLAN_SHAPE';
       UPDATE asset.object_attribute SET attribute_value=NEW.str_irreg WHERE object_id=OLD.gid AND attribute_type_code='STR_IRREG';
       UPDATE asset.object_attribute SET attribute_value=NEW.str_irreg_dt WHERE object_id=OLD.gid AND attribute_type_code='STR_IRREG_DT';
       UPDATE asset.object_attribute SET attribute_value=NEW.str_irreg_type WHERE object_id=OLD.gid AND attribute_type_code='STR_IRREG_TYPE';
       UPDATE asset.object_attribute SET attribute_value=NEW.nonstrcexw WHERE object_id=OLD.gid AND attribute_type_code='NONSTRCEXW';
       UPDATE asset.object_attribute SET attribute_value=NEW.roof_shape WHERE object_id=OLD.gid AND attribute_type_code='ROOF_SHAPE';    
       UPDATE asset.object_attribute SET attribute_value=NEW.roofcovmat WHERE object_id=OLD.gid AND attribute_type_code='ROOFCOVMAT';
       UPDATE asset.object_attribute SET attribute_value=NEW.roofsystyp WHERE object_id=OLD.gid AND attribute_type_code='ROOFSYSTYP';
       UPDATE asset.object_attribute SET attribute_value=NEW.roof_conn WHERE object_id=OLD.gid AND attribute_type_code='ROOF_CONN';
       UPDATE asset.object_attribute SET attribute_value=NEW.floor_mat WHERE object_id=OLD.gid AND attribute_type_code='FLOOR_MAT';
       UPDATE asset.object_attribute SET attribute_value=NEW.floor_type WHERE object_id=OLD.gid AND attribute_type_code='FLOOR_TYPE';
       UPDATE asset.object_attribute SET attribute_value=NEW.floor_conn WHERE object_id=OLD.gid AND attribute_type_code='FLOOR_CONN';
       UPDATE asset.object_attribute SET attribute_value=NEW.foundn_sys WHERE object_id=OLD.gid AND attribute_type_code='FOUNDN_SYS';
       UPDATE asset.object_attribute SET attribute_value=NEW.build_type WHERE object_id=OLD.gid AND attribute_type_code='BUILD_TYPE';
       UPDATE asset.object_attribute SET attribute_value=NEW.build_subtype WHERE object_id=OLD.gid AND attribute_type_code='BUILD_SUBTYPE';
       UPDATE asset.object_attribute SET attribute_value=NEW.rrvs_status WHERE object_id=OLD.gid AND attribute_type_code='RRVS_STATUS';
       UPDATE asset.object_attribute SET attribute_value=NEW.vuln WHERE object_id=OLD.gid AND attribute_type_code='VULN';
       UPDATE asset.object_attribute SET attribute_numeric_1=NEW.vuln_1 WHERE object_id=OLD.gid AND attribute_type_code='VULN';
       UPDATE asset.object_attribute SET attribute_numeric_2=NEW.vuln_2 WHERE object_id=OLD.gid AND attribute_type_code='VULN';
       UPDATE asset.object_attribute SET attribute_numeric_1=NEW.height_1 WHERE object_id=OLD.gid AND attribute_type_code='HEIGHT';
       UPDATE asset.object_attribute SET attribute_numeric_2=NEW.height_2 WHERE object_id=OLD.gid AND attribute_type_code='HEIGHT';

       UPDATE asset.object_attribute_qualifier SET qualifier_numeric_1=NEW.mat_type_bp WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='MAT_TYPE') AND qualifier_type_code='BELIEF';
       UPDATE asset.object_attribute_qualifier SET qualifier_numeric_1=NEW.mat_tech_bp WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='MAT_TECH') AND qualifier_type_code='BELIEF';
       UPDATE asset.object_attribute_qualifier SET qualifier_numeric_1=NEW.mat_prop_bp WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='MAT_PROP') AND qualifier_type_code='BELIEF';
       UPDATE asset.object_attribute_qualifier SET qualifier_numeric_1=NEW.llrs_bp WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='LLRS') AND qualifier_type_code='BELIEF';
       UPDATE asset.object_attribute_qualifier SET qualifier_numeric_1=NEW.llrs_duct_bp WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='LLRS_DUCT') AND qualifier_type_code='BELIEF';
       UPDATE asset.object_attribute_qualifier SET qualifier_numeric_1=NEW.height_bp WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='HEIGHT') AND qualifier_type_code='BELIEF';
       UPDATE asset.object_attribute_qualifier SET qualifier_numeric_1=NEW.yr_built_bp WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='YR_BUILT') AND qualifier_type_code='BELIEF';
       UPDATE asset.object_attribute_qualifier SET qualifier_numeric_1=NEW.occupy_bp WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='OCCUPY') AND qualifier_type_code='BELIEF';
       UPDATE asset.object_attribute_qualifier SET qualifier_numeric_1=NEW.occupy_dt_bp WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='OCCUPY_DT') AND qualifier_type_code='BELIEF';
       UPDATE asset.object_attribute_qualifier SET qualifier_numeric_1=NEW.position_bp WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='POSITION') AND qualifier_type_code='BELIEF';
       UPDATE asset.object_attribute_qualifier SET qualifier_numeric_1=NEW.plan_shape_bp WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='PLAN_SHAPE') AND qualifier_type_code='BELIEF';
       UPDATE asset.object_attribute_qualifier SET qualifier_numeric_1=NEW.str_irreg_bp WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='STR_IRREG') AND qualifier_type_code='BELIEF';
       UPDATE asset.object_attribute_qualifier SET qualifier_numeric_1=NEW.str_irreg_dt_bp WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='STR_IRREG_DT') AND qualifier_type_code='BELIEF';
       UPDATE asset.object_attribute_qualifier SET qualifier_numeric_1=NEW.str_irreg_type_bp WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='STR_IRREG_TYPE') AND qualifier_type_code='BELIEF';
       UPDATE asset.object_attribute_qualifier SET qualifier_numeric_1=NEW.nonstrcexw_bp WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='NONSTRCEXW') AND qualifier_type_code='BELIEF';
       UPDATE asset.object_attribute_qualifier SET qualifier_numeric_1=NEW.roof_shape_bp WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='ROOF_SHAPE') AND qualifier_type_code='BELIEF';
       UPDATE asset.object_attribute_qualifier SET qualifier_numeric_1=NEW.roofcovmat_bp WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='ROOFCOVMAT') AND qualifier_type_code='BELIEF';
       UPDATE asset.object_attribute_qualifier SET qualifier_numeric_1=NEW.roofsysmat_bp WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='ROOFSYSMAT') AND qualifier_type_code='BELIEF';
       UPDATE asset.object_attribute_qualifier SET qualifier_numeric_1=NEW.roofsystyp_bp WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='ROOFSYSTYP') AND qualifier_type_code='BELIEF';
       UPDATE asset.object_attribute_qualifier SET qualifier_numeric_1=NEW.roof_conn_bp WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='ROOF_CONN') AND qualifier_type_code='BELIEF';
       UPDATE asset.object_attribute_qualifier SET qualifier_numeric_1=NEW.floor_mat_bp WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='FLOOR_MAT') AND qualifier_type_code='BELIEF';
       UPDATE asset.object_attribute_qualifier SET qualifier_numeric_1=NEW.floor_type_bp WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='FLOOR_TYPE') AND qualifier_type_code='BELIEF';
       UPDATE asset.object_attribute_qualifier SET qualifier_numeric_1=NEW.floor_conn_bp WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='FLOOR_CONN') AND qualifier_type_code='BELIEF';
       UPDATE asset.object_attribute_qualifier SET qualifier_numeric_1=NEW.foundn_sys_bp WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='FOUNDN_SYS') AND qualifier_type_code='BELIEF';
       UPDATE asset.object_attribute_qualifier SET qualifier_numeric_1=NEW.build_type_bp WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='BUILD_TYPE') AND qualifier_type_code='BELIEF';
       UPDATE asset.object_attribute_qualifier SET qualifier_numeric_1=NEW.build_subtype_bp WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='BUILD_SUBTYPE') AND qualifier_type_code='BELIEF';
       UPDATE asset.object_attribute_qualifier SET qualifier_numeric_1=NEW.vuln_bp WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='VULN') AND qualifier_type_code='BELIEF';
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.yr_built_vt WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='YR_BUILT') AND qualifier_type_code='VALIDTIME';
       UPDATE asset.object_attribute_qualifier SET qualifier_timestamp_1=NEW.yr_built_vt1 WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='YR_BUILT') AND qualifier_type_code='VALIDTIME'; 
       
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.mat_type_src WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='MAT_TYPE') AND qualifier_type_code='SOURCE';
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.mat_tech_src WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='MAT_TECH') AND qualifier_type_code='SOURCE';
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.mat_prop_src WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='MAT_PROP') AND qualifier_type_code='SOURCE';
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.llrs_src WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='LLRS') AND qualifier_type_code='SOURCE';
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.llrs_duct_src WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='LLRS_DUCT') AND qualifier_type_code='SOURCE';
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.height_src WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='HEIGHT') AND qualifier_type_code='SOURCE';
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.yr_built_src WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='YR_BUILT') AND qualifier_type_code='SOURCE';
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.occupy_src WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='OCCUPY') AND qualifier_type_code='SOURCE';
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.occupy_dt_src WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='OCCUPY_DT') AND qualifier_type_code='SOURCE';
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.position_src WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='POSITION') AND qualifier_type_code='SOURCE';
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.plan_shape_src WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='PLAN_SHAPE') AND qualifier_type_code='SOURCE';
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.str_irreg_src WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='STR_IRREG') AND qualifier_type_code='SOURCE';
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.str_irreg_dt_src WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='STR_IRREG_DT') AND qualifier_type_code='SOURCE';
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.str_irreg_type_src WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='STR_IRREG_TYPE') AND qualifier_type_code='SOURCE';
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.nonstrcexw_src WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='NONSTRCEXW') AND qualifier_type_code='SOURCE';
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.roof_shape_src WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='ROOF_SHAPE') AND qualifier_type_code='SOURCE';
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.roofcovmat_src WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='ROOFCOVMAT') AND qualifier_type_code='SOURCE';
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.roofsysmat_src WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='ROOFSYSMAT') AND qualifier_type_code='SOURCE';
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.roofsystyp_src WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='ROOFSYSTYP') AND qualifier_type_code='SOURCE';
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.roof_conn_src WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='ROOF_CONN') AND qualifier_type_code='SOURCE';
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.floor_mat_src WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='FLOOR_MAT') AND qualifier_type_code='SOURCE';
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.floor_type_src WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='FLOOR_TYPE') AND qualifier_type_code='SOURCE';
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.floor_conn_src WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='FLOOR_CONN') AND qualifier_type_code='SOURCE';
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.foundn_sys_src WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='FOUNDN_SYS') AND qualifier_type_code='SOURCE';
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.build_type_src WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='BUILD_TYPE') AND qualifier_type_code='SOURCE';
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.build_subtype_src WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='BUILD_SUBTYPE') AND qualifier_type_code='SOURCE';
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.vuln_src WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='VULN') AND qualifier_type_code='SOURCE';

       RETURN NEW;

      ELSIF TG_OP = 'DELETE' THEN
       DELETE FROM asset.object_attribute_qualifier WHERE attribute_id IN (SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid);
       DELETE FROM asset.object_attribute WHERE object_id=OLD.gid;
       DELETE FROM asset.object WHERE gid=OLD.gid;
       --workaround to include row information after delete (because it is not possible to define a AFTER FOR EACH ROW trigger on a view)
       IF EXISTS (SELECT event_object_schema, trigger_name FROM information_schema.triggers WHERE event_object_schema = 'asset' AND trigger_name = 'zhistory_trigger_row') THEN
           INSERT INTO history.logged_actions VALUES(
            NEXTVAL('history.logged_actions_gid_seq'),    -- gid
        TG_TABLE_SCHEMA::text,                        -- schema_name
        TG_TABLE_NAME::text,                          -- table_name
        TG_RELID,                                     -- relation OID for much quicker searches
        txid_current(),                               -- transaction_id
        session_user::text,                           -- transaction_user
        current_timestamp,                            -- transaction_time
        NULL,                                        -- top-level query or queries (if multistatement) from client
        'D',                          -- transaction_type
        hstore(OLD.*), NULL, NULL);                   -- old_record, new_record, changed_fields
    END IF;
       RETURN NULL;
      END IF;
      RETURN NEW;
END;
$$;

COMMENT ON FUNCTION edit_object_view() IS '
This function makes the object view (adjusted for the rrvs) editable and forwards the edits to the underlying tables.
';

CREATE VIEW v_object_data AS
    SELECT a.gid,
    a.survey_gid,
    a.description,
    a.source,
    a.accuracy,
    a.the_geom,
    b.object_id,
    b.mat_type,
    b.mat_tech,
    b.mat_prop,
    b.llrs,
    b.llrs_duct,
    b.height,
    b.yr_built,
    b.occupy,
    b.occupy_dt,
    b."position",
    b.plan_shape,
    b.str_irreg,
    b.str_irreg_dt,
    b.str_irreg_type,
    b.nonstrcexw,
    b.roof_shape,
    b.roofcovmat,
    b.roofsysmat,
    b.roofsystyp,
    b.roof_conn,
    b.floor_mat,
    b.floor_type,
    b.floor_conn,
    b.foundn_sys,
    b.build_type,
    b.build_subtype,
    b.vuln,
    e.vuln_1,
    e.vuln_2,
    c.height_1,
    c.height_2,
    d.yr_built_vt,
    d.yr_built_vt1
   FROM ((((object a
     JOIN ( SELECT ct.object_id,
            ct.mat_type,
            ct.mat_tech,
            ct.mat_prop,
            ct.llrs,
            ct.llrs_duct,
            ct.height,
            ct.yr_built,
            ct.occupy,
            ct.occupy_dt,
            ct."position",
            ct.plan_shape,
            ct.str_irreg,
            ct.str_irreg_dt,
            ct.str_irreg_type,
            ct.nonstrcexw,
            ct.roof_shape,
            ct.roofcovmat,
            ct.roofsysmat,
            ct.roofsystyp,
            ct.roof_conn,
            ct.floor_mat,
            ct.floor_type,
            ct.floor_conn,
            ct.foundn_sys,
            ct.build_type,
            ct.build_subtype,
            ct.vuln,
            ct.rrvs_status
           FROM public.crosstab('SELECT object_id, attribute_type_code, attribute_value FROM asset.object_attribute order by object_id'::text, 'select code from taxonomy.dic_attribute_type order by gid'::text) ct(object_id integer, mat_type character varying, mat_tech character varying, mat_prop character varying, llrs character varying, llrs_duct character varying, height character varying, yr_built character varying, occupy character varying, occupy_dt character varying, "position" character varying, plan_shape character varying, str_irreg character varying, str_irreg_dt character varying, str_irreg_type character varying, nonstrcexw character varying, roof_shape character varying, roofcovmat character varying, roofsysmat character varying, roofsystyp character varying, roof_conn character varying, floor_mat character varying, floor_type character varying, floor_conn character varying, foundn_sys character varying, build_type character varying, build_subtype character varying, vuln character varying, rrvs_status character varying)) b ON ((a.gid = b.object_id)))
     LEFT JOIN ( SELECT object_attribute.object_id,
            object_attribute.attribute_numeric_1 AS height_1,
            object_attribute.attribute_numeric_2 AS height_2
           FROM object_attribute object_attribute
          WHERE ((object_attribute.attribute_type_code)::text = 'HEIGHT'::text)) c ON ((a.gid = c.object_id)))
     LEFT JOIN ( SELECT sub.object_id,
            sub.qualifier_value AS yr_built_vt,
            sub.qualifier_timestamp_1 AS yr_built_vt1
           FROM ( SELECT a_1.gid,
                    a_1.object_id,
                    a_1.attribute_type_code,
                    a_1.attribute_value,
                    a_1.attribute_numeric_1,
                    a_1.attribute_numeric_2,
                    a_1.attribute_text_1,
                    b_1.gid,
                    b_1.attribute_id,
                    b_1.qualifier_type_code,
                    b_1.qualifier_value,
                    b_1.qualifier_numeric_1,
                    b_1.qualifier_text_1,
                    b_1.qualifier_timestamp_1
                   FROM (object_attribute a_1
                     JOIN object_attribute_qualifier b_1 ON ((a_1.gid = b_1.attribute_id)))) sub(gid, object_id, attribute_type_code, attribute_value, attribute_numeric_1, attribute_numeric_2, attribute_text_1, gid_1, attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1, qualifier_text_1, qualifier_timestamp_1)
          WHERE (((sub.attribute_type_code)::text = 'YR_BUILT'::text) AND ((sub.qualifier_type_code)::text = 'VALIDTIME'::text))
          ORDER BY sub.object_id) d ON ((a.gid = d.object_id)))
     LEFT JOIN ( SELECT object_attribute.object_id,
            object_attribute.attribute_numeric_1 AS vuln_1,
            object_attribute.attribute_numeric_2 AS vuln_2
           FROM object_attribute object_attribute
          WHERE ((object_attribute.attribute_type_code)::text = 'VULN'::text)) e ON ((a.gid = e.object_id)))
  ORDER BY a.gid;

CREATE VIEW ve_object AS
    SELECT a.gid,
    a.survey_gid,
    a.description,
    a.source,
    a.accuracy,
    a.the_geom,
    b.object_id,
    b.mat_type,
    b.mat_tech,
    b.mat_prop,
    b.llrs,
    b.llrs_duct,
    b.height,
    b.yr_built,
    b.occupy,
    b.occupy_dt,
    b."position",
    b.plan_shape,
    b.str_irreg,
    b.str_irreg_dt,
    b.str_irreg_type,
    b.nonstrcexw,
    b.roof_shape,
    b.roofcovmat,
    b.roofsysmat,
    b.roofsystyp,
    b.roof_conn,
    b.floor_mat,
    b.floor_type,
    b.floor_conn,
    b.foundn_sys,
    b.build_type,
    b.build_subtype,
    b.vuln,
    b.rrvs_status,
    f.vuln_1,
    f.vuln_2,
    c.height_1,
    c.height_2,
    d.object_id1,
    d.mat_type_bp,
    d.mat_tech_bp,
    d.mat_prop_bp,
    d.llrs_bp,
    d.llrs_duct_bp,
    d.height_bp,
    d.yr_built_bp,
    d.occupy_bp,
    d.occupy_dt_bp,
    d.position_bp,
    d.plan_shape_bp,
    d.str_irreg_bp,
    d.str_irreg_dt_bp,
    d.str_irreg_type_bp,
    d.nonstrcexw_bp,
    d.roof_shape_bp,
    d.roofcovmat_bp,
    d.roofsysmat_bp,
    d.roofsystyp_bp,
    d.roof_conn_bp,
    d.floor_mat_bp,
    d.floor_type_bp,
    d.floor_conn_bp,
    d.foundn_sys_bp,
    d.build_type_bp,
    d.build_subtype_bp,
    d.vuln_bp,
    e.yr_built_vt,
    e.yr_built_vt1,
    g.object_id2,
    g.mat_type_src,
    g.mat_tech_src,
    g.mat_prop_src,
    g.llrs_src,
    g.llrs_duct_src,
    g.height_src,
    g.yr_built_src,
    g.occupy_src,
    g.occupy_dt_src,
    g.position_src,
    g.plan_shape_src,
    g.str_irreg_src,
    g.str_irreg_dt_src,
    g.str_irreg_type_src,
    g.nonstrcexw_src,
    g.roof_shape_src,
    g.roofcovmat_src,
    g.roofsysmat_src,
    g.roofsystyp_src,
    g.roof_conn_src,
    g.floor_mat_src,
    g.floor_type_src,
    g.floor_conn_src,
    g.foundn_sys_src,
    g.build_type_src,
    g.build_subtype_src,
    g.vuln_src
   FROM ((((((object a
     JOIN ( SELECT ct.object_id,
            ct.mat_type,
            ct.mat_tech,
            ct.mat_prop,
            ct.llrs,
            ct.llrs_duct,
            ct.height,
            ct.yr_built,
            ct.occupy,
            ct.occupy_dt,
            ct."position",
            ct.plan_shape,
            ct.str_irreg,
            ct.str_irreg_dt,
            ct.str_irreg_type,
            ct.nonstrcexw,
            ct.roof_shape,
            ct.roofcovmat,
            ct.roofsysmat,
            ct.roofsystyp,
            ct.roof_conn,
            ct.floor_mat,
            ct.floor_type,
            ct.floor_conn,
            ct.foundn_sys,
            ct.build_type,
            ct.build_subtype,
            ct.vuln,
            ct.rrvs_status
           FROM public.crosstab('SELECT object_id, attribute_type_code, attribute_value FROM asset.object_attribute order by object_id'::text, 'select code from taxonomy.dic_attribute_type order by gid'::text) ct(object_id integer, mat_type character varying, mat_tech character varying, mat_prop character varying, llrs character varying, llrs_duct character varying, height character varying, yr_built character varying, occupy character varying, occupy_dt character varying, "position" character varying, plan_shape character varying, str_irreg character varying, str_irreg_dt character varying, str_irreg_type character varying, nonstrcexw character varying, roof_shape character varying, roofcovmat character varying, roofsysmat character varying, roofsystyp character varying, roof_conn character varying, floor_mat character varying, floor_type character varying, floor_conn character varying, foundn_sys character varying, build_type character varying, build_subtype character varying, vuln character varying, rrvs_status character varying)) b ON ((a.gid = b.object_id)))
     LEFT JOIN ( SELECT object_attribute.object_id,
            object_attribute.attribute_numeric_1 AS height_1,
            object_attribute.attribute_numeric_2 AS height_2
           FROM object_attribute object_attribute
          WHERE ((object_attribute.attribute_type_code)::text = 'HEIGHT'::text)) c ON ((a.gid = c.object_id)))
     JOIN ( SELECT a_1.object_id1,
            a_1.mat_type_bp,
            a_1.mat_tech_bp,
            a_1.mat_prop_bp,
            a_1.llrs_bp,
            a_1.llrs_duct_bp,
            a_1.height_bp,
            a_1.yr_built_bp,
            a_1.occupy_bp,
            a_1.occupy_dt_bp,
            a_1.position_bp,
            a_1.plan_shape_bp,
            a_1.str_irreg_bp,
            a_1.str_irreg_dt_bp,
            a_1.str_irreg_type_bp,
            a_1.nonstrcexw_bp,
            a_1.roof_shape_bp,
            a_1.roofcovmat_bp,
            a_1.roofsysmat_bp,
            a_1.roofsystyp_bp,
            a_1.roof_conn_bp,
            a_1.floor_mat_bp,
            a_1.floor_type_bp,
            a_1.floor_conn_bp,
            a_1.foundn_sys_bp,
            a_1.build_type_bp,
            a_1.build_subtype_bp,
            a_1.vuln_bp,
            a_1.rrvs_status_bp
           FROM public.crosstab('SELECT object_id, attribute_type_code, qualifier_numeric_1 FROM (SELECT * FROM asset.object_attribute as a
                JOIN (SELECT * FROM asset.object_attribute_qualifier WHERE qualifier_type_code=''BELIEF'') as b
                ON (a.gid = b.attribute_id)) sub ORDER BY object_id'::text, 'SELECT code from taxonomy.dic_attribute_type order by gid'::text) a_1(object_id1 integer, mat_type_bp integer, mat_tech_bp integer, mat_prop_bp integer, llrs_bp integer, llrs_duct_bp integer, height_bp integer, yr_built_bp integer, occupy_bp integer, occupy_dt_bp integer, position_bp integer, plan_shape_bp integer, str_irreg_bp integer, str_irreg_dt_bp integer, str_irreg_type_bp integer, nonstrcexw_bp integer, roof_shape_bp integer, roofcovmat_bp integer, roofsysmat_bp integer, roofsystyp_bp integer, roof_conn_bp integer, floor_mat_bp integer, floor_type_bp integer, floor_conn_bp integer, foundn_sys_bp integer, build_type_bp integer, build_subtype_bp integer, vuln_bp integer, rrvs_status_bp integer)) d ON ((a.gid = d.object_id1)))
     LEFT JOIN ( SELECT sub.object_id,
            sub.qualifier_value AS yr_built_vt,
            sub.qualifier_timestamp_1 AS yr_built_vt1
           FROM ( SELECT a_1.gid,
                    a_1.object_id,
                    a_1.attribute_type_code,
                    a_1.attribute_value,
                    a_1.attribute_numeric_1,
                    a_1.attribute_numeric_2,
                    a_1.attribute_text_1,
                    b_1.gid,
                    b_1.attribute_id,
                    b_1.qualifier_type_code,
                    b_1.qualifier_value,
                    b_1.qualifier_numeric_1,
                    b_1.qualifier_text_1,
                    b_1.qualifier_timestamp_1
                   FROM (object_attribute a_1
                     JOIN object_attribute_qualifier b_1 ON ((a_1.gid = b_1.attribute_id)))) sub(gid, object_id, attribute_type_code, attribute_value, attribute_numeric_1, attribute_numeric_2, attribute_text_1, gid_1, attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1, qualifier_text_1, qualifier_timestamp_1)
          WHERE (((sub.attribute_type_code)::text = 'YR_BUILT'::text) AND ((sub.qualifier_type_code)::text = 'VALIDTIME'::text))
          ORDER BY sub.object_id) e ON ((a.gid = e.object_id)))
     LEFT JOIN ( SELECT object_attribute.object_id,
            object_attribute.attribute_numeric_1 AS vuln_1,
            object_attribute.attribute_numeric_2 AS vuln_2
           FROM object_attribute object_attribute
          WHERE ((object_attribute.attribute_type_code)::text = 'VULN'::text)) f ON ((a.gid = f.object_id)))
     JOIN ( SELECT ct.object_id2,
            ct.mat_type_src,
            ct.mat_tech_src,
            ct.mat_prop_src,
            ct.llrs_src,
            ct.llrs_duct_src,
            ct.height_src,
            ct.yr_built_src,
            ct.occupy_src,
            ct.occupy_dt_src,
            ct.position_src,
            ct.plan_shape_src,
            ct.str_irreg_src,
            ct.str_irreg_dt_src,
            ct.str_irreg_type_src,
            ct.nonstrcexw_src,
            ct.roof_shape_src,
            ct.roofcovmat_src,
            ct.roofsysmat_src,
            ct.roofsystyp_src,
            ct.roof_conn_src,
            ct.floor_mat_src,
            ct.floor_type_src,
            ct.floor_conn_src,
            ct.foundn_sys_src,
            ct.build_type_src,
            ct.build_subtype_src,
            ct.vuln_src,
            ct.rrvs_status_src
           FROM public.crosstab('SELECT object_id, attribute_type_code, qualifier_value FROM (SELECT * FROM asset.object_attribute as a
                JOIN (SELECT * FROM asset.object_attribute_qualifier WHERE qualifier_type_code=''SOURCE'') as b
                ON (a.gid = b.attribute_id)) sub ORDER BY object_id'::text, 'SELECT code from taxonomy.dic_attribute_type order by gid'::text) ct(object_id2 integer, mat_type_src character varying, mat_tech_src character varying, mat_prop_src character varying, llrs_src character varying, llrs_duct_src character varying, height_src character varying, yr_built_src character varying, occupy_src character varying, occupy_dt_src character varying, position_src character varying, plan_shape_src character varying, str_irreg_src character varying, str_irreg_dt_src character varying, str_irreg_type_src character varying, nonstrcexw_src character varying, roof_shape_src character varying, roofcovmat_src character varying, roofsysmat_src character varying, roofsystyp_src character varying, roof_conn_src character varying, floor_mat_src character varying, floor_type_src character varying, floor_conn_src character varying, foundn_sys_src character varying, build_type_src character varying, build_subtype_src character varying, vuln_src character varying, rrvs_status_src character varying)) g ON ((a.gid = g.object_id2)))
  ORDER BY a.gid;

ALTER VIEW ve_object ALTER COLUMN mat_type SET DEFAULT 'MAT99'::character varying;

ALTER VIEW ve_object ALTER COLUMN mat_tech SET DEFAULT 'MATT99'::character varying;

ALTER VIEW ve_object ALTER COLUMN mat_prop SET DEFAULT 'MATP99'::character varying;

ALTER VIEW ve_object ALTER COLUMN llrs SET DEFAULT 'L99'::character varying;

ALTER VIEW ve_object ALTER COLUMN llrs_duct SET DEFAULT 'DU99'::character varying;

ALTER VIEW ve_object ALTER COLUMN height SET DEFAULT 'H99'::character varying;

ALTER VIEW ve_object ALTER COLUMN yr_built SET DEFAULT 'Y99'::character varying;

ALTER VIEW ve_object ALTER COLUMN occupy SET DEFAULT 'OC99'::character varying;

ALTER VIEW ve_object ALTER COLUMN occupy_dt SET DEFAULT 'OCCDT99'::character varying;

ALTER VIEW ve_object ALTER COLUMN "position" SET DEFAULT 'BP99'::character varying;

ALTER VIEW ve_object ALTER COLUMN plan_shape SET DEFAULT 'PLF99'::character varying;

ALTER VIEW ve_object ALTER COLUMN str_irreg SET DEFAULT 'IR99'::character varying;

ALTER VIEW ve_object ALTER COLUMN str_irreg_dt SET DEFAULT 'IRP99'::character varying;

ALTER VIEW ve_object ALTER COLUMN str_irreg_type SET DEFAULT 'IRT99'::character varying;

ALTER VIEW ve_object ALTER COLUMN nonstrcexw SET DEFAULT 'EW99'::character varying;

ALTER VIEW ve_object ALTER COLUMN roof_shape SET DEFAULT 'R99'::character varying;

ALTER VIEW ve_object ALTER COLUMN roofcovmat SET DEFAULT 'RMT99'::character varying;

ALTER VIEW ve_object ALTER COLUMN roofsysmat SET DEFAULT 'RSM99'::character varying;

ALTER VIEW ve_object ALTER COLUMN roofsystyp SET DEFAULT 'RST99'::character varying;

ALTER VIEW ve_object ALTER COLUMN roof_conn SET DEFAULT 'RCN99'::character varying;

ALTER VIEW ve_object ALTER COLUMN floor_mat SET DEFAULT 'F99'::character varying;

ALTER VIEW ve_object ALTER COLUMN floor_type SET DEFAULT 'FT99'::character varying;

ALTER VIEW ve_object ALTER COLUMN floor_conn SET DEFAULT 'FWC99'::character varying;

ALTER VIEW ve_object ALTER COLUMN foundn_sys SET DEFAULT 'FOS99'::character varying;

ALTER VIEW ve_object ALTER COLUMN rrvs_status SET DEFAULT 'UNMODIFIED'::character varying;

CREATE TRIGGER object_trigger INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_object FOR EACH ROW EXECUTE PROCEDURE edit_object_view();

SET search_path = users, pg_catalog;

CREATE TABLE roles (
    id integer NOT NULL,
    name character varying(254)
);

CREATE TABLE roles_users (
    user_id integer,
    role_id integer
);

CREATE TABLE tasks (
    id integer NOT NULL,
    bdg_gids integer[],
    img_ids integer[]
);

CREATE TABLE tasks_users (
    user_id integer,
    task_id integer
);

CREATE TABLE users (
    id integer NOT NULL,
    authenticated boolean,
    name character varying(25)
);

ALTER TABLE roles
    ADD CONSTRAINT role_pkey PRIMARY KEY (id);

ALTER TABLE tasks
    ADD CONSTRAINT task_pkey PRIMARY KEY (id);

ALTER TABLE users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);

ALTER TABLE roles_users
    ADD CONSTRAINT roles_users_role_id_fkey FOREIGN KEY (role_id) REFERENCES roles(id);

ALTER TABLE roles_users
    ADD CONSTRAINT roles_users_users_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);

ALTER TABLE tasks_users
    ADD CONSTRAINT tasks_users_task_id_fkey FOREIGN KEY (task_id) REFERENCES tasks(id);

ALTER TABLE tasks_users
    ADD CONSTRAINT tasks_users_users_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);

SET search_path = taxonomy, pg_catalog;

--
-- Data for Name: dic_attribute_type; Type: TABLE DATA; Schema: taxonomy; Owner: postgres
--

INSERT INTO dic_attribute_type (gid, code, description) VALUES (28,'RRVS_STATUS','RRVS processing status');

--
-- Data for Name: dic_attribute_value; Type: TABLE DATA; Schema: taxonomy; Owner: postgres
--

INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description) VALUES (387,'RRVS_STATUS','MODIFIED','Asset has been modified by RRVS');
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description) VALUES (388,'RRVS_STATUS','COMPLETED','Asset has been completed by RRVS');
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description) VALUES (386,'RRVS_STATUS','UNMODIFIED','Default RRVS processing status');
