CREATE SCHEMA users;

SET search_path = taxonomy, pg_catalog;

---
--- Michael: Extension during DESERVE
---

INSERT INTO dic_attribute_type (gid, code, description) VALUES (29,'COMMENT','Comment by analyst');
INSERT INTO dic_attribute_type (gid, code, description) VALUES (30,'HEIGHT2','Second height value');
INSERT INTO dic_attribute_type (gid, code, description) VALUES (31,'STR_IRREG_2','Second structural irregularity');
INSERT INTO dic_attribute_type (gid, code, description) VALUES (32,'STR_IRREG_DT_2','Second structural irregularity detail');
INSERT INTO dic_attribute_type (gid, code, description) VALUES (33,'STR_IRREG_TYPE_2','Second structural irregularity type');
INSERT INTO dic_attribute_type (gid, code, description) VALUES (34,'VULN_EMS98','EMS-98 vulnerability classes');
INSERT INTO dic_attribute_type (gid, code, description) VALUES (35,'DMG','EMS-98 damage grade');

INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description) VALUES (386,'RRVS_STATUS','UNMODIFIED','Default RRVS processing status');
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description) VALUES (387,'RRVS_STATUS','MODIFIED','Asset has been modified by RRVS');
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description) VALUES (388,'RRVS_STATUS','COMPLETED','Asset has been completed by RRVS');


INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description) VALUES (389,'OCCUPY','CON','Under construction');
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description) VALUES (390,'OCCUPY','VAC','Vacant building');
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description) VALUES (391,'COMMENT','COMMENT','Comment by the analyst');
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description) VALUES (392,'HEIGHT','HB99','Number of storeys below ground unknown');
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description) VALUES (393,'VULN_EMS98','A','EMS-98 Class A');
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description) VALUES (394,'VULN_EMS98','B','EMS-98 Class B');
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description) VALUES (395,'VULN_EMS98','C','EMS-98 Class C');
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description) VALUES (396,'VULN_EMS98','D','EMS-98 Class D');
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description) VALUES (397,'VULN_EMS98','E','EMS-98 Class E');
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description) VALUES (398,'VULN_EMS98','F','EMS-98 Class F');
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description) VALUES (399,'VULN_EMS98','V99','Unknown EMS-98 Class');
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description) VALUES (400,'DMG','0','EMS-98 Damage Grade 0');
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description) VALUES (401,'DMG','1','EMS-98 Damage Grade 1');
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description) VALUES (402,'DMG','2','EMS-98 Damage Grade 2');
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description) VALUES (403,'DMG','3','EMS-98 Damage Grade 3');
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description) VALUES (404,'DMG','4','EMS-98 Damage Grade 4');
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description) VALUES (405,'DMG','5','EMS-98 Damage Grade 5');
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description) VALUES (406,'DMG','99','EMS-98 Damage Grade unknown');

---

SET search_path = asset, pg_catalog;

DROP VIEW IF EXISTS v_object_data;

DROP VIEW IF EXISTS ve_object;

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
       INSERT INTO asset.object_attribute (object_id, attribute_type_code, attribute_value, attribute_numeric_1, attribute_numeric_2) VALUES ((SELECT max(gid) FROM asset.object), 'HEIGHT2', NEW.height2, NEW.height2_1, NEW.height2_2);
       INSERT INTO asset.object_attribute (object_id, attribute_type_code, attribute_value, attribute_numeric_1, attribute_numeric_2) VALUES ((SELECT max(gid) FROM asset.object), 'YR_BUILT', NEW.yr_built, NEW.year_1, NEW.year_2);
       INSERT INTO asset.object_attribute (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM asset.object), 'OCCUPY', NEW.occupy);
       INSERT INTO asset.object_attribute (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM asset.object), 'OCCUPY_DT', NEW.occupy_dt);
       INSERT INTO asset.object_attribute (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM asset.object), 'POSITION', NEW."position");
       INSERT INTO asset.object_attribute (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM asset.object), 'PLAN_SHAPE', NEW.plan_shape);
       INSERT INTO asset.object_attribute (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM asset.object), 'STR_IRREG', NEW.str_irreg);
       INSERT INTO asset.object_attribute (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM asset.object), 'STR_IRREG_2', NEW.str_irreg_2);
       INSERT INTO asset.object_attribute (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM asset.object), 'STR_IRREG_DT', NEW.str_irreg_dt);
       INSERT INTO asset.object_attribute (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM asset.object), 'STR_IRREG_DT_2', NEW.str_irreg_dt_2);
       INSERT INTO asset.object_attribute (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM asset.object), 'STR_IRREG_TYPE', NEW.str_irreg_type);
       INSERT INTO asset.object_attribute (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM asset.object), 'STR_IRREG_TYPE_2', NEW.str_irreg_type_2);
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
       INSERT INTO asset.object_attribute (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM asset.object), 'COMMENT', NEW.comment);
       INSERT INTO asset.object_attribute (object_id, attribute_type_code, attribute_value, attribute_numeric_1, attribute_numeric_2) VALUES ((SELECT max(gid) FROM asset.object), 'VULN', NEW.vuln, NEW.vuln_1, NEW.vuln_2);       
       INSERT INTO asset.object_attribute (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM asset.object), 'DMG', NEW.dmg);       
       
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='MAT_TYPE'), 'BELIEF', 'BP', NEW.mat_type_bp);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='MAT_TECH'), 'BELIEF', 'BP', NEW.mat_tech_bp);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='MAT_PROP'), 'BELIEF', 'BP', NEW.mat_prop_bp);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='LLRS'), 'BELIEF', 'BP', NEW.llrs_bp);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='LLRS_DUCT'), 'BELIEF', 'BP', NEW.llrs_duct_bp);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='HEIGHT'), 'BELIEF', 'BP', NEW.height_bp);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='HEIGHT2'), 'BELIEF', 'BP', NEW.height2_bp);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='YR_BUILT'), 'BELIEF', 'BP', NEW.yr_built_bp);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='OCCUPY'), 'BELIEF', 'BP', NEW.occupy_bp);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='OCCUPY_DT'), 'BELIEF', 'BP', NEW.occupy_dt_bp);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='POSITION'), 'BELIEF', 'BP', NEW.position_bp);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='PLAN_SHAPE'), 'BELIEF', 'BP', NEW.plan_shape_bp);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='STR_IRREG'), 'BELIEF', 'BP', NEW.str_irreg_bp);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='STR_IRREG_2'), 'BELIEF', 'BP', NEW.str_irreg_2_bp);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='STR_IRREG_DT'), 'BELIEF', 'BP', NEW.str_irreg_dt_bp);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='STR_IRREG_DT_2'), 'BELIEF', 'BP', NEW.str_irreg_dt_2_bp);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='STR_IRREG_TYPE'), 'BELIEF', 'BP', NEW.str_irreg_type_bp);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='STR_IRREG_TYPE_2'), 'BELIEF', 'BP', NEW.str_irreg_type_2_bp);
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
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='DMG'), 'BELIEF', 'BP', NEW.dmg_bp);      
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value, qualifier_timestamp_1) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='YR_BUILT'), 'VALIDTIME', NEW.yr_built_vt, NEW.yr_built_vt1);

       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='MAT_TYPE'), 'SOURCE', NEW.mat_type_src);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='MAT_TECH'), 'SOURCE', NEW.mat_tech_src);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='MAT_PROP'), 'SOURCE', NEW.mat_prop_src);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='LLRS'), 'SOURCE', NEW.llrs_src);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='LLRS_DUCT'), 'SOURCE', NEW.llrs_duct_src);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='HEIGHT'), 'SOURCE', NEW.height_src);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='HEIGHT2'), 'SOURCE', NEW.height2_src);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='YR_BUILT'), 'SOURCE', NEW.yr_built_src);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='OCCUPY'), 'SOURCE', NEW.occupy_src);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='OCCUPY_DT'), 'SOURCE', NEW.occupy_dt_src);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='POSITION'), 'SOURCE', NEW.position_src);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='PLAN_SHAPE'), 'SOURCE', NEW.plan_shape_src);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='STR_IRREG'), 'SOURCE', NEW.str_irreg_src);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='STR_IRREG_2'), 'SOURCE', NEW.str_irreg_2_src);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='STR_IRREG_DT'), 'SOURCE', NEW.str_irreg_dt_src);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='STR_IRREG_DT_2'), 'SOURCE', NEW.str_irreg_dt_2_src);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='STR_IRREG_TYPE'), 'SOURCE', NEW.str_irreg_type_src);
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='STR_IRREG_TYPE_2'), 'SOURCE', NEW.str_irreg_type_2_src);
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
       INSERT INTO asset.object_attribute_qualifier (attribute_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM asset.object_attribute WHERE attribute_type_code='DMG'), 'SOURCE', NEW.dmg_src);
 
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
       UPDATE asset.object_attribute SET attribute_value=NEW.height2 WHERE object_id=OLD.gid AND attribute_type_code='HEIGHT2';
       UPDATE asset.object_attribute SET attribute_value=NEW.yr_built WHERE object_id=OLD.gid AND attribute_type_code='YR_BUILT';
       UPDATE asset.object_attribute SET attribute_value=NEW.occupy WHERE object_id=OLD.gid AND attribute_type_code='OCCUPY';
       UPDATE asset.object_attribute SET attribute_value=NEW.occupy_dt WHERE object_id=OLD.gid AND attribute_type_code='OCCUPY_DT';
       UPDATE asset.object_attribute SET attribute_value=NEW."position" WHERE object_id=OLD.gid AND attribute_type_code='POSITION';    
       UPDATE asset.object_attribute SET attribute_value=NEW.plan_shape WHERE object_id=OLD.gid AND attribute_type_code='PLAN_SHAPE';
       UPDATE asset.object_attribute SET attribute_value=NEW.str_irreg WHERE object_id=OLD.gid AND attribute_type_code='STR_IRREG';
       UPDATE asset.object_attribute SET attribute_value=NEW.str_irreg_2 WHERE object_id=OLD.gid AND attribute_type_code='STR_IRREG_2';
       UPDATE asset.object_attribute SET attribute_value=NEW.str_irreg_dt WHERE object_id=OLD.gid AND attribute_type_code='STR_IRREG_DT';
       UPDATE asset.object_attribute SET attribute_value=NEW.str_irreg_dt_2 WHERE object_id=OLD.gid AND attribute_type_code='STR_IRREG_DT_2';
       UPDATE asset.object_attribute SET attribute_value=NEW.str_irreg_type WHERE object_id=OLD.gid AND attribute_type_code='STR_IRREG_TYPE';
       UPDATE asset.object_attribute SET attribute_value=NEW.str_irreg_type_2 WHERE object_id=OLD.gid AND attribute_type_code='STR_IRREG_TYPE_2';
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
       UPDATE asset.object_attribute SET attribute_value=NEW.comment WHERE object_id=OLD.gid AND attribute_type_code='COMMENT';
       UPDATE asset.object_attribute SET attribute_value=NEW.vuln WHERE object_id=OLD.gid AND attribute_type_code='VULN';
       UPDATE asset.object_attribute SET attribute_numeric_1=NEW.vuln_1 WHERE object_id=OLD.gid AND attribute_type_code='VULN';
       UPDATE asset.object_attribute SET attribute_numeric_2=NEW.vuln_2 WHERE object_id=OLD.gid AND attribute_type_code='VULN';
       UPDATE asset.object_attribute SET attribute_value=NEW.dmg WHERE object_id=OLD.gid AND attribute_type_code='DMG';
       UPDATE asset.object_attribute SET attribute_numeric_1=NEW.height_1 WHERE object_id=OLD.gid AND attribute_type_code='HEIGHT';
       UPDATE asset.object_attribute SET attribute_numeric_2=NEW.height_2 WHERE object_id=OLD.gid AND attribute_type_code='HEIGHT';
       UPDATE asset.object_attribute SET attribute_numeric_1=NEW.height2_1 WHERE object_id=OLD.gid AND attribute_type_code='HEIGHT2';
       UPDATE asset.object_attribute SET attribute_numeric_2=NEW.height2_2 WHERE object_id=OLD.gid AND attribute_type_code='HEIGHT2';
       UPDATE asset.object_attribute SET attribute_numeric_1=NEW.year_1 WHERE object_id=OLD.gid AND attribute_type_code='YR_BUILT';
       UPDATE asset.object_attribute SET attribute_numeric_2=NEW.year_2 WHERE object_id=OLD.gid AND attribute_type_code='YR_BUILT';

       UPDATE asset.object_attribute_qualifier SET qualifier_numeric_1=NEW.mat_type_bp WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='MAT_TYPE') AND qualifier_type_code='BELIEF';
       UPDATE asset.object_attribute_qualifier SET qualifier_numeric_1=NEW.mat_tech_bp WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='MAT_TECH') AND qualifier_type_code='BELIEF';
       UPDATE asset.object_attribute_qualifier SET qualifier_numeric_1=NEW.mat_prop_bp WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='MAT_PROP') AND qualifier_type_code='BELIEF';
       UPDATE asset.object_attribute_qualifier SET qualifier_numeric_1=NEW.llrs_bp WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='LLRS') AND qualifier_type_code='BELIEF';
       UPDATE asset.object_attribute_qualifier SET qualifier_numeric_1=NEW.llrs_duct_bp WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='LLRS_DUCT') AND qualifier_type_code='BELIEF';
       UPDATE asset.object_attribute_qualifier SET qualifier_numeric_1=NEW.height_bp WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='HEIGHT') AND qualifier_type_code='BELIEF';
       UPDATE asset.object_attribute_qualifier SET qualifier_numeric_1=NEW.height2_bp WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='HEIGHT2') AND qualifier_type_code='BELIEF';
       UPDATE asset.object_attribute_qualifier SET qualifier_numeric_1=NEW.yr_built_bp WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='YR_BUILT') AND qualifier_type_code='BELIEF';
       UPDATE asset.object_attribute_qualifier SET qualifier_numeric_1=NEW.occupy_bp WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='OCCUPY') AND qualifier_type_code='BELIEF';
       UPDATE asset.object_attribute_qualifier SET qualifier_numeric_1=NEW.occupy_dt_bp WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='OCCUPY_DT') AND qualifier_type_code='BELIEF';
       UPDATE asset.object_attribute_qualifier SET qualifier_numeric_1=NEW.position_bp WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='POSITION') AND qualifier_type_code='BELIEF';
       UPDATE asset.object_attribute_qualifier SET qualifier_numeric_1=NEW.plan_shape_bp WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='PLAN_SHAPE') AND qualifier_type_code='BELIEF';
       UPDATE asset.object_attribute_qualifier SET qualifier_numeric_1=NEW.str_irreg_bp WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='STR_IRREG') AND qualifier_type_code='BELIEF';
       UPDATE asset.object_attribute_qualifier SET qualifier_numeric_1=NEW.str_irreg_2_bp WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='STR_IRREG_2') AND qualifier_type_code='BELIEF';
       UPDATE asset.object_attribute_qualifier SET qualifier_numeric_1=NEW.str_irreg_dt_bp WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='STR_IRREG_DT') AND qualifier_type_code='BELIEF';
       UPDATE asset.object_attribute_qualifier SET qualifier_numeric_1=NEW.str_irreg_dt_2_bp WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='STR_IRREG_DT_2') AND qualifier_type_code='BELIEF';
       UPDATE asset.object_attribute_qualifier SET qualifier_numeric_1=NEW.str_irreg_type_bp WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='STR_IRREG_TYPE') AND qualifier_type_code='BELIEF';
       UPDATE asset.object_attribute_qualifier SET qualifier_numeric_1=NEW.str_irreg_type_2_bp WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='STR_IRREG_TYPE_2') AND qualifier_type_code='BELIEF';
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
       UPDATE asset.object_attribute_qualifier SET qualifier_numeric_1=NEW.dmg_bp WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='DMG') AND qualifier_type_code='BELIEF';
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.yr_built_vt WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='YR_BUILT') AND qualifier_type_code='VALIDTIME';
       UPDATE asset.object_attribute_qualifier SET qualifier_timestamp_1=NEW.yr_built_vt1 WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='YR_BUILT') AND qualifier_type_code='VALIDTIME'; 
       
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.mat_type_src WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='MAT_TYPE') AND qualifier_type_code='SOURCE';
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.mat_tech_src WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='MAT_TECH') AND qualifier_type_code='SOURCE';
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.mat_prop_src WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='MAT_PROP') AND qualifier_type_code='SOURCE';
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.llrs_src WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='LLRS') AND qualifier_type_code='SOURCE';
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.llrs_duct_src WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='LLRS_DUCT') AND qualifier_type_code='SOURCE';
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.height_src WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='HEIGHT') AND qualifier_type_code='SOURCE';
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.height2_src WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='HEIGHT2') AND qualifier_type_code='SOURCE';
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.yr_built_src WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='YR_BUILT') AND qualifier_type_code='SOURCE';
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.occupy_src WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='OCCUPY') AND qualifier_type_code='SOURCE';
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.occupy_dt_src WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='OCCUPY_DT') AND qualifier_type_code='SOURCE';
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.position_src WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='POSITION') AND qualifier_type_code='SOURCE';
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.plan_shape_src WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='PLAN_SHAPE') AND qualifier_type_code='SOURCE';
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.str_irreg_src WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='STR_IRREG') AND qualifier_type_code='SOURCE';
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.str_irreg_2_src WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='STR_IRREG_2') AND qualifier_type_code='SOURCE';
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.str_irreg_dt_src WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='STR_IRREG_DT') AND qualifier_type_code='SOURCE';
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.str_irreg_dt_2_src WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='STR_IRREG_DT_2') AND qualifier_type_code='SOURCE';
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.str_irreg_type_src WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='STR_IRREG_TYPE') AND qualifier_type_code='SOURCE';
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.str_irreg_type_2_src WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='STR_IRREG_TYPE_2') AND qualifier_type_code='SOURCE';
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
       UPDATE asset.object_attribute_qualifier SET qualifier_value=NEW.dmg_src WHERE attribute_id=(SELECT gid FROM asset.object_attribute WHERE object_id=OLD.gid AND attribute_type_code='DMG') AND qualifier_type_code='SOURCE';

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
    b.height2,
    b.yr_built,
    b.occupy,
    b.occupy_dt,
    b."position",
    b.plan_shape,
    b.str_irreg,
    b.str_irreg_dt,
    b.str_irreg_type,
    b.str_irreg_2,
    b.str_irreg_dt_2,
    b.str_irreg_type_2,
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
    b.dmg,
    b."comment",
    e.vuln_1,
    e.vuln_2,
    c.height_1,
    c.height_2,
    c1.height2_1,
    c1.height2_2,
    c2.year_1,
    c2.year_2,
    d.yr_built_vt,
    d.yr_built_vt1
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
            ct.rrvs_status,
            ct."comment",
            ct.height2,
            ct.str_irreg_2,
            ct.str_irreg_dt_2,
            ct.str_irreg_type_2,
            ct.dmg
            
           FROM public.crosstab('SELECT object_id, attribute_type_code, attribute_value FROM asset.object_attribute order by object_id'::text, 'select code from taxonomy.dic_attribute_type order by gid'::text) ct
		(object_id integer, mat_type character varying, mat_tech character varying, mat_prop character varying, 
		llrs character varying, llrs_duct character varying, 
		height character varying, yr_built character varying, 
		occupy character varying, occupy_dt character varying, "position" character varying, plan_shape character varying,
		str_irreg character varying, str_irreg_dt character varying, str_irreg_type character varying,  
		nonstrcexw character varying, roof_shape character varying, roofcovmat character varying, 
		roofsysmat character varying, roofsystyp character varying, roof_conn character varying, 
		floor_mat character varying, floor_type character varying, floor_conn character varying, 
		foundn_sys character varying, build_type character varying, build_subtype character varying,
		vuln character varying,  rrvs_status character varying, "comment" character varying, height2 character varying,
		str_irreg_2 character varying, str_irreg_dt_2 character varying, str_irreg_type_2 character varying,
		dmg character varying 
		)) b ON ((a.gid = b.object_id)))
     LEFT JOIN ( SELECT object_attribute.object_id,
            object_attribute.attribute_numeric_1 AS height_1,
            object_attribute.attribute_numeric_2 AS height_2
           FROM object_attribute object_attribute
          WHERE ((object_attribute.attribute_type_code)::text = 'HEIGHT'::text)) c ON ((a.gid = c.object_id)))
     LEFT JOIN ( SELECT object_attribute.object_id,
            object_attribute.attribute_numeric_1 AS height2_1,
            object_attribute.attribute_numeric_2 AS height2_2
           FROM object_attribute object_attribute
          WHERE ((object_attribute.attribute_type_code)::text = 'HEIGHT2'::text)) c1 ON ((a.gid = c1.object_id)))
     LEFT JOIN ( SELECT object_attribute.object_id,
            object_attribute.attribute_numeric_1 AS year_1,
            object_attribute.attribute_numeric_2 AS year_2
           FROM object_attribute object_attribute
          WHERE ((object_attribute.attribute_type_code)::text = 'YR_BUILT'::text)) c2 ON ((a.gid = c2.object_id)))
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
    b."comment",
    b.height2,
    b.str_irreg_2,
    b.str_irreg_dt_2,
    b.str_irreg_type_2,
    b.dmg,
    f.vuln_1,
    f.vuln_2,
    c.height_1,
    c.height_2,
    c1.height2_1,
    c1.height2_2,
    c2.year_1,
    c2.year_2,
    d.object_id1,
    d.mat_type_bp,
    d.mat_tech_bp,
    d.mat_prop_bp,
    d.llrs_bp,
    d.llrs_duct_bp,
    d.height_bp,
    d.height2_bp,
    d.yr_built_bp,
    d.occupy_bp,
    d.occupy_dt_bp,
    d.position_bp,
    d.plan_shape_bp,
    d.str_irreg_bp,
    d.str_irreg_dt_bp,
    d.str_irreg_type_bp,
    d.str_irreg_2_bp,
    d.str_irreg_dt_2_bp,
    d.str_irreg_type_2_bp,
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
    d.dmg_bp,
    e.yr_built_vt,
    e.yr_built_vt1,
    g.object_id2,
    g.mat_type_src,
    g.mat_tech_src,
    g.mat_prop_src,
    g.llrs_src,
    g.llrs_duct_src,
    g.height_src,
    g.height2_src,
    g.yr_built_src,
    g.occupy_src,
    g.occupy_dt_src,
    g.position_src,
    g.plan_shape_src,
    g.str_irreg_src,
    g.str_irreg_dt_src,
    g.str_irreg_type_src,
    g.str_irreg_2_src,
    g.str_irreg_dt_2_src,
    g.str_irreg_type_2_src,
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
    g.vuln_src,
    g.dmg_src
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
            ct.rrvs_status,
            ct."comment",
            ct.height2,
            ct.str_irreg_2,
            ct.str_irreg_dt_2,
            ct.str_irreg_type_2,
            ct.dmg
            
            
           FROM public.crosstab('SELECT object_id, attribute_type_code, attribute_value FROM asset.object_attribute order by object_id'::text, 'select code from taxonomy.dic_attribute_type order by gid'::text) 
				ct(object_id integer, mat_type character varying, mat_tech character varying, mat_prop character varying, 
				   llrs character varying, llrs_duct character varying, 
				   height character varying, yr_built character varying, 
				   occupy character varying, occupy_dt character varying, "position" character varying, plan_shape character varying,
				   str_irreg character varying, str_irreg_dt character varying, str_irreg_type character varying, 
				   nonstrcexw character varying, roof_shape character varying, roofcovmat character varying, 
				   roofsysmat character varying, roofsystyp character varying, roof_conn character varying, 
				   floor_mat character varying, floor_type character varying, floor_conn character varying, 
				   foundn_sys character varying, build_type character varying, build_subtype character varying, 
				   vuln character varying,rrvs_status character varying, "comment" character varying,
				   height2 character varying,
				   str_irreg_2 character varying, str_irreg_dt_2 character varying, str_irreg_type_2 character varying,
				   dmg character varying 
				   )) b 
				   ON ((a.gid = b.object_id)))
     LEFT JOIN ( SELECT object_attribute.object_id,
            object_attribute.attribute_numeric_1 AS height_1,
            object_attribute.attribute_numeric_2 AS height_2
           FROM object_attribute object_attribute
          WHERE ((object_attribute.attribute_type_code)::text = 'HEIGHT'::text)) c ON ((a.gid = c.object_id))
     LEFT JOIN ( SELECT object_attribute.object_id,
            object_attribute.attribute_numeric_1 AS height2_1,
            object_attribute.attribute_numeric_2 AS height2_2
           FROM object_attribute object_attribute
          WHERE ((object_attribute.attribute_type_code)::text = 'HEIGHT2'::text)) c1 ON ((a.gid = c1.object_id))
     LEFT JOIN ( SELECT object_attribute.object_id,
            object_attribute.attribute_numeric_1 AS year_1,
            object_attribute.attribute_numeric_2 AS year_2
           FROM object_attribute object_attribute
          WHERE ((object_attribute.attribute_type_code)::text = 'YR_BUILT'::text)) c2 ON ((a.gid = c2.object_id)))
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
            a_1.rrvs_status_bp,
            a_1.comment_bp,
            a_1.height2_bp,
            a_1.str_irreg_2_bp,
            a_1.str_irreg_dt_2_bp,
            a_1.str_irreg_type_2_bp,
            a_1.dmg_bp

           FROM public.crosstab('SELECT object_id, attribute_type_code, qualifier_numeric_1 FROM (SELECT * FROM asset.object_attribute as a
                JOIN (SELECT * FROM asset.object_attribute_qualifier WHERE qualifier_type_code=''BELIEF'') as b
                ON (a.gid = b.attribute_id)) sub ORDER BY object_id'::text, 'SELECT code from taxonomy.dic_attribute_type order by gid'::text) 
                a_1(object_id1 integer, mat_type_bp integer, mat_tech_bp integer, mat_prop_bp integer, llrs_bp integer, 
		    llrs_duct_bp integer, height_bp integer, yr_built_bp integer, occupy_bp integer,
		    occupy_dt_bp integer, position_bp integer, plan_shape_bp integer, 
		    str_irreg_bp integer, str_irreg_dt_bp integer, str_irreg_type_bp integer,
		    nonstrcexw_bp integer, roof_shape_bp integer, roofcovmat_bp integer, roofsysmat_bp integer, 
		    roofsystyp_bp integer, roof_conn_bp integer, floor_mat_bp integer, floor_type_bp integer, 
		    floor_conn_bp integer, foundn_sys_bp integer, build_type_bp integer, build_subtype_bp integer, 
		    vuln_bp integer, rrvs_status_bp integer,comment_bp integer,height2_bp integer,
    		    str_irreg_2_bp integer, str_irreg_dt_2_bp integer, str_irreg_type_2_bp integer,
    		    dmg_bp integer
  
		    )) d ON ((a.gid = d.object_id1)))
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
            ct.rrvs_status_src,
            ct.comment_src,
            ct.height2_src,
            ct.str_irreg_2_src,
            ct.str_irreg_dt_2_src,
            ct.str_irreg_type_2_src,
            ct.dmg_src
           FROM public.crosstab('SELECT object_id, attribute_type_code, qualifier_value FROM (SELECT * FROM asset.object_attribute as a
                JOIN (SELECT * FROM asset.object_attribute_qualifier WHERE qualifier_type_code=''SOURCE'') as b
                ON (a.gid = b.attribute_id)) sub ORDER BY object_id'::text, 'SELECT code from taxonomy.dic_attribute_type order by gid'::text) 
                ct(object_id2 integer, mat_type_src character varying, mat_tech_src character varying, mat_prop_src character varying, 
		   llrs_src character varying, llrs_duct_src character varying, height_src character varying, 
		   yr_built_src character varying, occupy_src character varying, 
		   occupy_dt_src character varying, position_src character varying, plan_shape_src character varying, 
		   str_irreg_src character varying, str_irreg_dt_src character varying, str_irreg_type_src character varying,
		   nonstrcexw_src character varying, roof_shape_src character varying, roofcovmat_src character varying, 
		   roofsysmat_src character varying, roofsystyp_src character varying, roof_conn_src character varying, 
		   floor_mat_src character varying, floor_type_src character varying, floor_conn_src character varying, 
		   foundn_sys_src character varying, build_type_src character varying, build_subtype_src character varying, 
		   vuln_src character varying, rrvs_status_src character varying, comment_src character varying,
		   height2_src character varying,
		   str_irreg_2_src character varying, str_irreg_dt_2_src character varying, str_irreg_type_2_src character varying,
		   dmg_src character varying
                   )) g 
		   ON ((a.gid = g.object_id2)))
  ORDER BY a.gid;

ALTER VIEW ve_object ALTER COLUMN mat_type SET DEFAULT 'MAT99'::character varying;

ALTER VIEW ve_object ALTER COLUMN mat_tech SET DEFAULT 'MATT99'::character varying;

ALTER VIEW ve_object ALTER COLUMN mat_prop SET DEFAULT 'MATP99'::character varying;

ALTER VIEW ve_object ALTER COLUMN llrs SET DEFAULT 'L99'::character varying;

ALTER VIEW ve_object ALTER COLUMN llrs_duct SET DEFAULT 'DU99'::character varying;

ALTER VIEW ve_object ALTER COLUMN height SET DEFAULT 'H99'::character varying;

ALTER VIEW ve_object ALTER COLUMN height2 SET DEFAULT 'HB99'::character varying;

ALTER VIEW ve_object ALTER COLUMN yr_built SET DEFAULT 'Y99'::character varying;

ALTER VIEW ve_object ALTER COLUMN occupy SET DEFAULT 'OC99'::character varying;

ALTER VIEW ve_object ALTER COLUMN occupy_dt SET DEFAULT 'OCCDT99'::character varying;

ALTER VIEW ve_object ALTER COLUMN "position" SET DEFAULT 'BP99'::character varying;

ALTER VIEW ve_object ALTER COLUMN plan_shape SET DEFAULT 'PLF99'::character varying;

ALTER VIEW ve_object ALTER COLUMN str_irreg SET DEFAULT 'IR99'::character varying;

ALTER VIEW ve_object ALTER COLUMN str_irreg_dt SET DEFAULT 'IRP99'::character varying;

ALTER VIEW ve_object ALTER COLUMN str_irreg_type SET DEFAULT 'IRT99'::character varying;

ALTER VIEW ve_object ALTER COLUMN str_irreg_2 SET DEFAULT 'IRRE'::character varying;

ALTER VIEW ve_object ALTER COLUMN str_irreg_dt_2 SET DEFAULT 'IRPP'::character varying;

ALTER VIEW ve_object ALTER COLUMN str_irreg_type_2 SET DEFAULT 'IRN'::character varying;

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
    id serial primary key,
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


SET search_path = taxonomy, pg_catalog;

--
-- Name: dic_attribute_value; Type: TABLE; Schema: taxonomy; Owner: postgres; Tablespace: 
--

ALTER TABLE dic_attribute_value ADD COLUMN description_ar character varying(254);
COMMENT ON COLUMN dic_attribute_value.description_ar IS 'Short textual description of the attribute value in Arabic';

--
-- Data for Name: dic_attribute_value; Type: TABLE DATA; Schema: taxonomy; Owner: postgres
--
UPDATE dic_attribute_value SET description_ar='DU99 - Ductility unknown' WHERE gid=94;
UPDATE dic_attribute_value SET description_ar='DUC - Ductile' WHERE gid=95;
UPDATE dic_attribute_value SET description_ar='DNO - Non-ductile' WHERE gid=96;
UPDATE dic_attribute_value SET description_ar='DBD - Equipped with base isolation and/or energy dissipation devices' WHERE gid=97;
UPDATE dic_attribute_value SET description_ar='RMT99 - Unknown roof covering' WHERE gid=235;
UPDATE dic_attribute_value SET description_ar='CU - Concrete' WHERE gid=3;
UPDATE dic_attribute_value SET description_ar='CR - Concrete' WHERE gid=4;
UPDATE dic_attribute_value SET description_ar='فولاذ' WHERE gid=6;
UPDATE dic_attribute_value SET description_ar='الفولاذ  باستثناء - المعادن ' WHERE gid=7;
UPDATE dic_attribute_value SET description_ar='MUR - Masonry' WHERE gid=9;
UPDATE dic_attribute_value SET description_ar='MCF - Masonry' WHERE gid=10;
UPDATE dic_attribute_value SET description_ar='E99 - Earth' WHERE gid=12;
UPDATE dic_attribute_value SET description_ar='EU - Earth' WHERE gid=13;
UPDATE dic_attribute_value SET description_ar='خشب' WHERE gid=15;
UPDATE dic_attribute_value SET description_ar='اخرى مادة' WHERE gid=16;
UPDATE dic_attribute_value SET description_ar='الرصيف   اوحجاره صخور شبه منحوته' WHERE gid=32;
UPDATE dic_attribute_value SET description_ar='قوالب/كتل طين' WHERE gid=30;
UPDATE dic_attribute_value SET description_ar='MUN99 - Masonry unit' WHERE gid=29;
UPDATE dic_attribute_value SET description_ar='منحوته حجاره' WHERE gid=33;
UPDATE dic_attribute_value SET description_ar='صلب طوب من الناري الطين' WHERE gid=35;
UPDATE dic_attribute_value SET description_ar='مجوفبلاط او قوالب من  الناريالطين الناري' WHERE gid=37;
UPDATE dic_attribute_value SET description_ar='المكان في مصبوبة خرسانه' WHERE gid=18;
UPDATE dic_attribute_value SET description_ar='الجاهزة خرسانه' WHERE gid=19;
UPDATE dic_attribute_value SET description_ar='الاجهاد مسبقه  جاهزة خرسانه' WHERE gid=21;
UPDATE dic_attribute_value SET description_ar='S99 - Steel' WHERE gid=22;
UPDATE dic_attribute_value SET description_ar='عناصر فولاذية مشكلة على الساخن' WHERE gid=24;
UPDATE dic_attribute_value SET description_ar='SO - Steel' WHERE gid=25;
UPDATE dic_attribute_value SET description_ar='ME99 - Metal' WHERE gid=26;
UPDATE dic_attribute_value SET description_ar='حديد' WHERE gid=27;
UPDATE dic_attribute_value SET description_ar='CBS - Concrete blocks' WHERE gid=39;
UPDATE dic_attribute_value SET description_ar='MO - Masonry unit' WHERE gid=41;
UPDATE dic_attribute_value SET description_ar='مسلحفولاذ' WHERE gid=43;
UPDATE dic_attribute_value SET description_ar='مسلح خشب' WHERE gid=44;
UPDATE dic_attribute_value SET description_ar='مسلحه ليافا شبكه' WHERE gid=46;
UPDATE dic_attribute_value SET description_ar='الخرسانة المسلحة   من مجموعه' WHERE gid=47;
UPDATE dic_attribute_value SET description_ar='معروفه - غير لارضا تقنية' WHERE gid=48;
UPDATE dic_attribute_value SET description_ar='الارض صدم' WHERE gid=49;
UPDATE dic_attribute_value SET description_ar='ETO - Earth technology' WHERE gid=51;
UPDATE dic_attribute_value SET description_ar='W99 - Wood' WHERE gid=52;
UPDATE dic_attribute_value SET description_ar=' خفيف خشب' WHERE gid=54;
UPDATE dic_attribute_value SET description_ar='صلب خشب' WHERE gid=55;
UPDATE dic_attribute_value SET description_ar='خيزران' WHERE gid=57;
UPDATE dic_attribute_value SET description_ar='WO - Wood' WHERE gid=58;
UPDATE dic_attribute_value SET description_ar='جيري حجر' WHERE gid=72;
UPDATE dic_attribute_value SET description_ar=' رملي حجر' WHERE gid=73;
UPDATE dic_attribute_value SET description_ar='مسامي حجر' WHERE gid=74;
UPDATE dic_attribute_value SET description_ar=' صخري لوح' WHERE gid=75;
UPDATE dic_attribute_value SET description_ar='غرانيت' WHERE gid=76;
UPDATE dic_attribute_value SET description_ar='بركاني حجر' WHERE gid=77;
UPDATE dic_attribute_value SET description_ar='SPO - Stone' WHERE gid=78;
UPDATE dic_attribute_value SET description_ar='ملحومه وصلات' WHERE gid=62;
UPDATE dic_attribute_value SET description_ar='مثبته بإحكام وصلات' WHERE gid=63;
UPDATE dic_attribute_value SET description_ar='مغلقه وصلات' WHERE gid=64;
UPDATE dic_attribute_value SET description_ar='ملاط بدون' WHERE gid=66;
UPDATE dic_attribute_value SET description_ar='طيني ملاط' WHERE gid=67;
UPDATE dic_attribute_value SET description_ar='جيري ملاط' WHERE gid=68;
UPDATE dic_attribute_value SET description_ar='اسمنتي جيري ملاط' WHERE gid=70;
UPDATE dic_attribute_value SET description_ar='معروف غير الماده نوع' WHERE gid=81;
UPDATE dic_attribute_value SET description_ar='نظام مقاومة الحمل الجانبي' WHERE gid=92;
UPDATE dic_attribute_value SET description_ar='مقاوم للعزوم اطار' WHERE gid=84;
UPDATE dic_attribute_value SET description_ar='        ليس نظام مقاوم للاحمال الجانبية' WHERE gid=83;
UPDATE dic_attribute_value SET description_ar='بداخله جدران محمولة/قسامات طارا' WHERE gid=85;
UPDATE dic_attribute_value SET description_ar='جائز' WHERE gid=87;
UPDATE dic_attribute_value SET description_ar='الحائط' WHERE gid=88;
UPDATE dic_attribute_value SET description_ar='أإو مفرغة مسطحه بلاطه' WHERE gid=90;
UPDATE dic_attribute_value SET description_ar='عدد الطوابق غير معروف' WHERE gid=98;
UPDATE dic_attribute_value SET description_ar='عدد الطوابق فوق مستوى الطابق الأرضي' WHERE gid=99;
UPDATE dic_attribute_value SET description_ar='ارتفاع مستوى الطابق الارضي ' WHERE gid=101;
UPDATE dic_attribute_value SET description_ar='السنة غيرمعروفة' WHERE gid=103;
UPDATE dic_attribute_value SET description_ar='آخر معلومات ممكنة عن الإنشاء أو التقوية الزلزالية ' WHERE gid=106;
UPDATE dic_attribute_value SET description_ar='معلومات تقريبية عن الإنشاء و التقوية الزلزالية' WHERE gid=107;
UPDATE dic_attribute_value SET description_ar='منطقة سكنية' WHERE gid=109;
UPDATE dic_attribute_value SET description_ar='RMN - Concrete rood without additional covering' WHERE gid=236;
UPDATE dic_attribute_value SET description_ar='IRIR - Irregular structure' WHERE gid=196;
UPDATE dic_attribute_value SET description_ar='BP1 - Adjoining building(s) on one side' WHERE gid=171;
UPDATE dic_attribute_value SET description_ar='IRPP - Plan irregularity - primary' WHERE gid=197;
UPDATE dic_attribute_value SET description_ar='BP2 - Adjoining building(s) on two sides' WHERE gid=172;
UPDATE dic_attribute_value SET description_ar='BP3 - Adjoining building(s) on three sides' WHERE gid=173;
UPDATE dic_attribute_value SET description_ar='IRPS - Plan irregularity - secondary' WHERE gid=198;
UPDATE dic_attribute_value SET description_ar='IRVP - Vertical irregularity - primary' WHERE gid=199;
UPDATE dic_attribute_value SET description_ar='IRVS - Vertical irregularity - secondary' WHERE gid=200;
UPDATE dic_attribute_value SET description_ar='INR - No irregularity' WHERE gid=201;
UPDATE dic_attribute_value SET description_ar='TOR - Torsion eccentricity' WHERE gid=202;
UPDATE dic_attribute_value SET description_ar='REC - Re-entrant corner' WHERE gid=203;
UPDATE dic_attribute_value SET description_ar='IRHO - Other plan irregularity' WHERE gid=204;
UPDATE dic_attribute_value SET description_ar='RMT1 - Clay or concrete tile roof covering' WHERE gid=237;
UPDATE dic_attribute_value SET description_ar='SOS - Soft storey' WHERE gid=205;
UPDATE dic_attribute_value SET description_ar='CRW - Cripple wall' WHERE gid=206;
UPDATE dic_attribute_value SET description_ar='SHC - Short column' WHERE gid=207;
UPDATE dic_attribute_value SET description_ar='POP - Pounding potential' WHERE gid=208;
UPDATE dic_attribute_value SET description_ar='SET - Setback' WHERE gid=209;
UPDATE dic_attribute_value SET description_ar='CHV - Change in vertical structure (includes large overhangs)' WHERE gid=210;
UPDATE dic_attribute_value SET description_ar='IRVO - Other vertical irregularity' WHERE gid=211;
UPDATE dic_attribute_value SET description_ar='RMT2 - Fibre cement or metal tile roof covering' WHERE gid=238;
UPDATE dic_attribute_value SET description_ar='RMT3 - Membrane roof covering' WHERE gid=239;
UPDATE dic_attribute_value SET description_ar='RMT4 - Slate roof covering' WHERE gid=240;
UPDATE dic_attribute_value SET description_ar='RMT5 - Stone slab roof covering' WHERE gid=241;
UPDATE dic_attribute_value SET description_ar='RMT6 - Metal or asbestos sheet roof covering' WHERE gid=242;
UPDATE dic_attribute_value SET description_ar='RMT7 - Wooden or asphalt shingle roof covering' WHERE gid=243;
UPDATE dic_attribute_value SET description_ar='RMT8 - Vegetative roof covering' WHERE gid=244;
UPDATE dic_attribute_value SET description_ar='RMT9 - Earthen roof covering' WHERE gid=245;
UPDATE dic_attribute_value SET description_ar='RSH4 - Pitched with dormers' WHERE gid=228;
UPDATE dic_attribute_value SET description_ar='RSH5 - Monopitch' WHERE gid=229;
UPDATE dic_attribute_value SET description_ar='RSH6 - Sawtooth' WHERE gid=230;
UPDATE dic_attribute_value SET description_ar='RSH7 - Curved' WHERE gid=231;
UPDATE dic_attribute_value SET description_ar='RSH8 - Complex regular' WHERE gid=232;
UPDATE dic_attribute_value SET description_ar='RSH9 - Complex irregular' WHERE gid=233;
UPDATE dic_attribute_value SET description_ar='RSHO - Roof shape' WHERE gid=234;
UPDATE dic_attribute_value SET description_ar='RMT10 - Solar panelled roofs' WHERE gid=246;
UPDATE dic_attribute_value SET description_ar='RMT11 - Tensile membrane or fabric roof' WHERE gid=247;
UPDATE dic_attribute_value SET description_ar='RMTO - Roof covering' WHERE gid=248;
UPDATE dic_attribute_value SET description_ar='RM - Masonry roof' WHERE gid=249;
UPDATE dic_attribute_value SET description_ar='RE - Earthen roof' WHERE gid=250;
UPDATE dic_attribute_value SET description_ar='RC - Concrete roof' WHERE gid=251;
UPDATE dic_attribute_value SET description_ar='RME - Metal roof' WHERE gid=252;
UPDATE dic_attribute_value SET description_ar='RWO - Wooden roof' WHERE gid=253;
UPDATE dic_attribute_value SET description_ar='RFA - Fabric roof' WHERE gid=254;
UPDATE dic_attribute_value SET description_ar='RO - Roof material' WHERE gid=255;
UPDATE dic_attribute_value SET description_ar='RM99 - Masonry roof' WHERE gid=256;
UPDATE dic_attribute_value SET description_ar='RM1 - Vaulted masonry roof' WHERE gid=257;
UPDATE dic_attribute_value SET description_ar='RM2 - Shallow-arched masonry roof' WHERE gid=258;
UPDATE dic_attribute_value SET description_ar='RM3 - Composite masonry and concrete roof system' WHERE gid=259;
UPDATE dic_attribute_value SET description_ar='RE99 - Earthen roof' WHERE gid=260;
UPDATE dic_attribute_value SET description_ar='RE1 - Vaulted earthen roof' WHERE gid=261;
UPDATE dic_attribute_value SET description_ar='RWCP - Roof-wall diaphragm connection present' WHERE gid=281;
UPDATE dic_attribute_value SET description_ar='RTDN - Roof tie-down not provided' WHERE gid=283;
UPDATE dic_attribute_value SET description_ar='RTD99 - Roof tie-down unknown' WHERE gid=282;
UPDATE dic_attribute_value SET description_ar='RTDP - Roof tie-down present' WHERE gid=284;
UPDATE dic_attribute_value SET description_ar='FN - No elevated or suspended floor' WHERE gid=285;
UPDATE dic_attribute_value SET description_ar='F99 - Floor material' WHERE gid=286;
UPDATE dic_attribute_value SET description_ar='FE - Earthen floor' WHERE gid=288;
UPDATE dic_attribute_value SET description_ar='FME - Metal floor' WHERE gid=290;
UPDATE dic_attribute_value SET description_ar='FM1 - Vaulted masonry floor' WHERE gid=294;
UPDATE dic_attribute_value SET description_ar='FE99 - Earthen floor' WHERE gid=297;
UPDATE dic_attribute_value SET description_ar='FC99 - Concrete floor' WHERE gid=298;
UPDATE dic_attribute_value SET description_ar=' تجارية وعامة ' WHERE gid=110;
UPDATE dic_attribute_value SET description_ar='صناعي' WHERE gid=112;
UPDATE dic_attribute_value SET description_ar='الزراعة' WHERE gid=113;
UPDATE dic_attribute_value SET description_ar='جمعية' WHERE gid=114;
UPDATE dic_attribute_value SET description_ar='في الغالب صناعي وسكني' WHERE gid=149;
UPDATE dic_attribute_value SET description_ar='صناعات ثقيلة' WHERE gid=151;
UPDATE dic_attribute_value SET description_ar='صناعات خفيفة' WHERE gid=152;
UPDATE dic_attribute_value SET description_ar='AGR99 - Agriculture' WHERE gid=153;
UPDATE dic_attribute_value SET description_ar='مأوى للحيوانات' WHERE gid=155;
UPDATE dic_attribute_value SET description_ar='العملية الزراعية' WHERE gid=156;
UPDATE dic_attribute_value SET description_ar='تجمع ديني' WHERE gid=158;
UPDATE dic_attribute_value SET description_ar='ميدان' WHERE gid=159;
UPDATE dic_attribute_value SET description_ar='حفلات أو دور عرض' WHERE gid=160;
UPDATE dic_attribute_value SET description_ar='تجمعات أخرى' WHERE gid=161;
UPDATE dic_attribute_value SET description_ar='GOV1 - Government' WHERE gid=163;
UPDATE dic_attribute_value SET description_ar='EDU99 - Education' WHERE gid=165;
UPDATE dic_attribute_value SET description_ar='التسهيلاتقبل المدرسه' WHERE gid=166;
UPDATE dic_attribute_value SET description_ar='المدرسه' WHERE gid=167;
UPDATE dic_attribute_value SET description_ar='المستشفيات /  العيادات الطبية' WHERE gid=135;
UPDATE dic_attribute_value SET description_ar='الترفيه' WHERE gid=136;
UPDATE dic_attribute_value SET description_ar='المباني العامة' WHERE gid=137;
UPDATE dic_attribute_value SET description_ar='محطة الحافلات' WHERE gid=139;
UPDATE dic_attribute_value SET description_ar='جدران خارجية من الخرسانة' WHERE gid=213;
UPDATE dic_attribute_value SET description_ar='BPD - Detached building' WHERE gid=170;
UPDATE dic_attribute_value SET description_ar='جدران خارجية من الزجاج' WHERE gid=214;
UPDATE dic_attribute_value SET description_ar='جدران خارجة من الخزف' WHERE gid=215;
UPDATE dic_attribute_value SET description_ar='PLFSQO - Square' WHERE gid=176;
UPDATE dic_attribute_value SET description_ar='PLFR - Rectangular' WHERE gid=177;
UPDATE dic_attribute_value SET description_ar='PLFRO - Rectangular' WHERE gid=178;
UPDATE dic_attribute_value SET description_ar='PLFL - L-shape' WHERE gid=179;
UPDATE dic_attribute_value SET description_ar='PLFC - Curved' WHERE gid=180;
UPDATE dic_attribute_value SET description_ar='PLFCO - Curved' WHERE gid=181;
UPDATE dic_attribute_value SET description_ar='PLFD - Triangular' WHERE gid=182;
UPDATE dic_attribute_value SET description_ar='PLFDO - Triangular' WHERE gid=183;
UPDATE dic_attribute_value SET description_ar=' pentagon' WHERE gid=184;
UPDATE dic_attribute_value SET description_ar='RC99 - Concrete roof' WHERE gid=262;
UPDATE dic_attribute_value SET description_ar='RC1 - Cast-in-place beamless reinforced concrete roof' WHERE gid=263;
UPDATE dic_attribute_value SET description_ar='PLF99 - Unknown plan shape' WHERE gid=174;
UPDATE dic_attribute_value SET description_ar='PLFSQ - Square' WHERE gid=175;
UPDATE dic_attribute_value SET description_ar='PLFPO - Polygonal' WHERE gid=185;
UPDATE dic_attribute_value SET description_ar='EWME - Metal exterior walls' WHERE gid=217;
UPDATE dic_attribute_value SET description_ar='PLFE - E-shape' WHERE gid=186;
UPDATE dic_attribute_value SET description_ar='PLFH - H-shape' WHERE gid=187;
UPDATE dic_attribute_value SET description_ar='PLFS - S-shape' WHERE gid=188;
UPDATE dic_attribute_value SET description_ar='PLFT - T-shape' WHERE gid=189;
UPDATE dic_attribute_value SET description_ar='PLFU - U- or C-shape' WHERE gid=190;
UPDATE dic_attribute_value SET description_ar='PLFX - X-shape' WHERE gid=191;
UPDATE dic_attribute_value SET description_ar='PLFY - Y-shape' WHERE gid=192;
UPDATE dic_attribute_value SET description_ar='PLFI - Irregular plan shape' WHERE gid=193;
UPDATE dic_attribute_value SET description_ar='RC2 - Cast-in-place beam-supported reinforced concrete roof' WHERE gid=264;
UPDATE dic_attribute_value SET description_ar='RC3 - Precast concrete roof with reinforced concrete topping' WHERE gid=265;
UPDATE dic_attribute_value SET description_ar='IR99 - Unknown structural irregularity' WHERE gid=194;
UPDATE dic_attribute_value SET description_ar='IRRE - Regular structure' WHERE gid=195;
UPDATE dic_attribute_value SET description_ar='RC4 - Precast concrete roof without reinforced concrete topping' WHERE gid=266;
UPDATE dic_attribute_value SET description_ar='RME99 - Metal roof' WHERE gid=267;
UPDATE dic_attribute_value SET description_ar='RME1 - Metal beams or trusses supporting light roofing' WHERE gid=268;
UPDATE dic_attribute_value SET description_ar='RME2 - Metal roof beams supporting precast concrete slabs' WHERE gid=269;
UPDATE dic_attribute_value SET description_ar='RME3 - Composite steel roof deck and concrete slab' WHERE gid=270;
UPDATE dic_attribute_value SET description_ar='RWO99 - Wooden roof' WHERE gid=271;
UPDATE dic_attribute_value SET description_ar='EWV - Vegetative exterior walls' WHERE gid=218;
UPDATE dic_attribute_value SET description_ar='EWW - Wooden exterior walls' WHERE gid=219;
UPDATE dic_attribute_value SET description_ar='EWSL - Stucco finish on light framing for exterior walls' WHERE gid=220;
UPDATE dic_attribute_value SET description_ar='EWPL - Plastic/vinyl exterior walls' WHERE gid=221;
UPDATE dic_attribute_value SET description_ar='EWCB - Cement-based boards for exterior walls' WHERE gid=222;
UPDATE dic_attribute_value SET description_ar='EWO - Material of exterior walls' WHERE gid=223;
UPDATE dic_attribute_value SET description_ar='RWO1 - Wooden structure with roof covering' WHERE gid=272;
UPDATE dic_attribute_value SET description_ar='RWO2 - Wooden beams or trusses with heavy roof covering' WHERE gid=273;
UPDATE dic_attribute_value SET description_ar='RWO3 - Wood-based sheets on rafters or purlins' WHERE gid=274;
UPDATE dic_attribute_value SET description_ar='R99 - Unknown roof shape' WHERE gid=224;
UPDATE dic_attribute_value SET description_ar='RSH1 - Flat' WHERE gid=225;
UPDATE dic_attribute_value SET description_ar='RSH2 - Pitched with gable ends' WHERE gid=226;
UPDATE dic_attribute_value SET description_ar='RSH3 - Pitched and hipped' WHERE gid=227;
UPDATE dic_attribute_value SET description_ar='RWO4 - Plywood panels or other light-weight panels for roof' WHERE gid=275;
UPDATE dic_attribute_value SET description_ar='RWO5 - Bamboo' WHERE gid=276;
UPDATE dic_attribute_value SET description_ar='RFA1 - Inflatable or tensile membrane roof' WHERE gid=277;
UPDATE dic_attribute_value SET description_ar='RFAO - Fabric roof' WHERE gid=278;
UPDATE dic_attribute_value SET description_ar='RWC99 - Roof-wall diaphragm connection unknown' WHERE gid=279;
UPDATE dic_attribute_value SET description_ar='RWCN - Roof-wall diaphragm connection not provided' WHERE gid=280;
UPDATE dic_attribute_value SET description_ar='FM - Masonry floor' WHERE gid=287;
UPDATE dic_attribute_value SET description_ar='FC - Concrete floor' WHERE gid=289;
UPDATE dic_attribute_value SET description_ar='FW - Wooden floor' WHERE gid=291;
UPDATE dic_attribute_value SET description_ar='FO - Floor material' WHERE gid=292;
UPDATE dic_attribute_value SET description_ar='FME1 - Metal beams' WHERE gid=304;
UPDATE dic_attribute_value SET description_ar='FME2 - Metal floor beams supporting precast concrete slabs' WHERE gid=305;
UPDATE dic_attribute_value SET description_ar='FME3 - Composite steel deck and concrete slab' WHERE gid=306;
UPDATE dic_attribute_value SET description_ar='FM99 - Masonry floor' WHERE gid=293;
UPDATE dic_attribute_value SET description_ar='FM2 - Shallow-arched masonry floor' WHERE gid=295;
UPDATE dic_attribute_value SET description_ar='FM3 - Composite cast-in-place reinforced concrete and masonry floor system' WHERE gid=296;
UPDATE dic_attribute_value SET description_ar='FC1 - Cast-in-place beamless reinforced concrete floor' WHERE gid=299;
UPDATE dic_attribute_value SET description_ar='FC2 - Cast-in-place beam-supported reinforced concrete floor' WHERE gid=300;
UPDATE dic_attribute_value SET description_ar='FC3 - Precast concrete flor with reinforced concrete topping' WHERE gid=301;
UPDATE dic_attribute_value SET description_ar='FC4 - Precast concrete floor without reinforced concrete topping' WHERE gid=302;
UPDATE dic_attribute_value SET description_ar='التعليم' WHERE gid=116;
UPDATE dic_attribute_value SET description_ar='محطة القطار' WHERE gid=140;
UPDATE dic_attribute_value SET description_ar='مطار' WHERE gid=141;
UPDATE dic_attribute_value SET description_ar='الترفيه والتسلية' WHERE gid=142;
UPDATE dic_attribute_value SET description_ar='في الغالب سكني وتجاري' WHERE gid=144;
UPDATE dic_attribute_value SET description_ar='في الغالب تجاري وسكني' WHERE gid=145;
UPDATE dic_attribute_value SET description_ar='RES99 - Residential' WHERE gid=118;
UPDATE dic_attribute_value SET description_ar='مسكن واحد' WHERE gid=119;
UPDATE dic_attribute_value SET description_ar='وحدتان - بناء مكون من طابقين' WHERE gid=121;
UPDATE dic_attribute_value SET description_ar='3-4 وحدات' WHERE gid=122;
UPDATE dic_attribute_value SET description_ar='5-9 وحدات' WHERE gid=123;
UPDATE dic_attribute_value SET description_ar='10-19 وحدة ' WHERE gid=124;
UPDATE dic_attribute_value SET description_ar='20-49 وحدة' WHERE gid=125;
UPDATE dic_attribute_value SET description_ar='50 وحدة وما فوق' WHERE gid=126;
UPDATE dic_attribute_value SET description_ar='اقامة مؤقتة' WHERE gid=127;
UPDATE dic_attribute_value SET description_ar='تأسيس سكني' WHERE gid=128;
UPDATE dic_attribute_value SET description_ar='سكن عشوائي' WHERE gid=130;
UPDATE dic_attribute_value SET description_ar='تجارة التجزئة' WHERE gid=132;
UPDATE dic_attribute_value SET description_ar='مستودع' WHERE gid=133;
UPDATE dic_attribute_value SET description_ar='FME99 - Metal floor' WHERE gid=303;
UPDATE dic_attribute_value SET description_ar='FW99 - Wooden floor' WHERE gid=307;
UPDATE dic_attribute_value SET description_ar='FW1 - Wooden beams or trusses and joists supporting light flooring' WHERE gid=308;
UPDATE dic_attribute_value SET description_ar='FW2 - Wooden beams or trusses and joists supporting heavy flooring' WHERE gid=309;
UPDATE dic_attribute_value SET description_ar='FW3 - Wood-based sheets on joists or beams' WHERE gid=310;
UPDATE dic_attribute_value SET description_ar='FW4 - Plywood panels or other light-weight panels for floor' WHERE gid=311;
UPDATE dic_attribute_value SET description_ar='FWC99 - Floor-wall diaphragm connection unknown' WHERE gid=312;
UPDATE dic_attribute_value SET description_ar='FWCN - Floor-wall diaphragm connection not provided' WHERE gid=313;
UPDATE dic_attribute_value SET description_ar='FWCP - Floor-wall diaphragm connection present' WHERE gid=314;
UPDATE dic_attribute_value SET description_ar='FOS99 - Unknown foundation system' WHERE gid=315;
UPDATE dic_attribute_value SET description_ar='FOSSL - Shallow foundation' WHERE gid=316;
UPDATE dic_attribute_value SET description_ar='FOSN - Shallow foundation' WHERE gid=317;
UPDATE dic_attribute_value SET description_ar='FOSDL - Deep foundation' WHERE gid=318;
UPDATE dic_attribute_value SET description_ar='FOSDN - Deep foundation' WHERE gid=319;
UPDATE dic_attribute_value SET description_ar='FOSO - Foundation' WHERE gid=320;
UPDATE dic_attribute_value SET description_ar='BP99 - Position' WHERE gid=322;
UPDATE dic_attribute_value SET description_ar='IRT99 - Structural irregularity type' WHERE gid=324;
UPDATE dic_attribute_value SET description_ar='IRP99 - Structural irregularity detail' WHERE gid=323;
UPDATE dic_attribute_value SET description_ar='RSM99 - Roof system material' WHERE gid=357;
UPDATE dic_attribute_value SET description_ar='RST99 - Roof system type' WHERE gid=358;
UPDATE dic_attribute_value SET description_ar='RCN99 - Roof connection' WHERE gid=360;
UPDATE dic_attribute_value SET description_ar='FT99 - Floor type' WHERE gid=361;
UPDATE dic_attribute_value SET description_ar='EMCA1 - Load bearing masonry wall buildings' WHERE gid=362;
UPDATE dic_attribute_value SET description_ar='EMCA2 - Monolithic reinforced concrete buildings' WHERE gid=363;
UPDATE dic_attribute_value SET description_ar='EMCA3 - Precast concrete buildings' WHERE gid=364;
UPDATE dic_attribute_value SET description_ar='EMCA4 - Non-engineered earthen buildings' WHERE gid=365;
UPDATE dic_attribute_value SET description_ar='EMCA5 - Wooden buildings' WHERE gid=366;
UPDATE dic_attribute_value SET description_ar='EMCA6 - Steel buildings' WHERE gid=367;
UPDATE dic_attribute_value SET description_ar=' or blocks in cement or mixed mortar (no seismic design) - wooden floors' WHERE gid=368;
UPDATE dic_attribute_value SET description_ar=' or blocks in cement or mixed mortar (no seismic design) - precast concrete floors' WHERE gid=369;
UPDATE dic_attribute_value SET description_ar='2012 /HBET:1' WHERE gid=370;
UPDATE dic_attribute_value SET description_ar='1959 /HBET:1' WHERE gid=371;
UPDATE dic_attribute_value SET description_ar='2012 /HBET:3' WHERE gid=372;
UPDATE dic_attribute_value SET description_ar='2012 /HBET:7' WHERE gid=373;
UPDATE dic_attribute_value SET description_ar='1995 /HBET:3' WHERE gid=374;
UPDATE dic_attribute_value SET description_ar='2012 /HBET:8' WHERE gid=375;
UPDATE dic_attribute_value SET description_ar='2012 /HBET:1' WHERE gid=376;
UPDATE dic_attribute_value SET description_ar='EMCA3.2 - Precast concrete large panel buildings with panel connections achieved by welding of embedment plates - Seria 464' WHERE gid=377;
UPDATE dic_attribute_value SET description_ar='1990 /HBET:5' WHERE gid=378;
UPDATE dic_attribute_value SET description_ar='DX /CR+PC /LFLS+DUC /DY /CR+PC /LFLS+DUC /YBET:1966' WHERE gid=379;
UPDATE dic_attribute_value SET description_ar='2012 /HEX:1+HBEX:0+HFBET:0.3' WHERE gid=380;
UPDATE dic_attribute_value SET description_ar='1970 /HBET:1' WHERE gid=381;
UPDATE dic_attribute_value SET description_ar='2012 /HBET:1' WHERE gid=382;
UPDATE dic_attribute_value SET description_ar='EMCA6.1 - Steel buildings' WHERE gid=383;
UPDATE dic_attribute_value SET description_ar='Exact vulnerability class' WHERE gid=384;
UPDATE dic_attribute_value SET description_ar='Lower and upper class of vulnerability' WHERE gid=385;
UPDATE dic_attribute_value SET description_ar='Asset has been modified by RRVS' WHERE gid=387;
UPDATE dic_attribute_value SET description_ar='Asset has been completed by RRVS' WHERE gid=388;
UPDATE dic_attribute_value SET description_ar='Default RRVS processing status' WHERE gid=386;
UPDATE dic_attribute_value SET description_ar='معروفة غير مادة ' WHERE gid=1;
UPDATE dic_attribute_value SET description_ar='C99 - Concrete' WHERE gid=2;
UPDATE dic_attribute_value SET description_ar='SRC - Concrete' WHERE gid=5;
UPDATE dic_attribute_value SET description_ar='M99 - Masonry' WHERE gid=8;
UPDATE dic_attribute_value SET description_ar='MR - Masonry' WHERE gid=11;
UPDATE dic_attribute_value SET description_ar='ER - Earth' WHERE gid=14;
UPDATE dic_attribute_value SET description_ar='كلية/ مكاتب جامعية / قاعات للدراسة ' WHERE gid=168;
UPDATE dic_attribute_value SET description_ar='ST99 - Stone' WHERE gid=31;
UPDATE dic_attribute_value SET description_ar='CL99 - Fired clay unit' WHERE gid=34;
UPDATE dic_attribute_value SET description_ar='مجوف طوب من الناري الطين' WHERE gid=36;
UPDATE dic_attribute_value SET description_ar='CB99 - Concrete blocks' WHERE gid=38;
UPDATE dic_attribute_value SET description_ar='خرسانية غير معروفة تقنيه' WHERE gid=17;
UPDATE dic_attribute_value SET description_ar='منزل متنقل' WHERE gid=129;
UPDATE dic_attribute_value SET description_ar='COM99 - Commercial and public' WHERE gid=131;
UPDATE dic_attribute_value SET description_ar='كلية / بحوث وتسهيلات جامعية / مختبرات ' WHERE gid=169;
UPDATE dic_attribute_value SET description_ar='OCCDT99 - Occupancy detail' WHERE gid=321;
UPDATE dic_attribute_value SET description_ar=' الاجهاد مسبقة في المكان مصبوبة خرسانه' WHERE gid=20;
UPDATE dic_attribute_value SET description_ar='عناصر فولاذية مشكلة على البارد' WHERE gid=23;
UPDATE dic_attribute_value SET description_ar='MEO - Metal' WHERE gid=28;
UPDATE dic_attribute_value SET description_ar='CBH - Concrete blocks' WHERE gid=40;
UPDATE dic_attribute_value SET description_ar='MR99 - Masonry reinforcement' WHERE gid=42;
UPDATE dic_attribute_value SET description_ar='RB - Bamboo-' WHERE gid=45;
UPDATE dic_attribute_value SET description_ar='ETC - Cob or wet construction' WHERE gid=50;
UPDATE dic_attribute_value SET description_ar=' تقيل خشب' WHERE gid=53;
UPDATE dic_attribute_value SET description_ar='والخشب/القصب الطين' WHERE gid=56;
UPDATE dic_attribute_value SET description_ar='معروفه غير المواد تقنيه' WHERE gid=80;
UPDATE dic_attribute_value SET description_ar='SC99 - Steel connections' WHERE gid=60;
UPDATE dic_attribute_value SET description_ar='نوع الملاط غير معروف' WHERE gid=65;
UPDATE dic_attribute_value SET description_ar='اسمنتي ملاط' WHERE gid=69;
UPDATE dic_attribute_value SET description_ar='SP99 - Stone' WHERE gid=71;
UPDATE dic_attribute_value SET description_ar='احمال اخرى افقية-نظام المقاومة' WHERE gid=93;
UPDATE dic_attribute_value SET description_ar='نظام مقاوم للاحمال الجانبية غير معرف' WHERE gid=82;
UPDATE dic_attribute_value SET description_ar='إطار مكتف' WHERE gid=86;
UPDATE dic_attribute_value SET description_ar='نظام مشترك إطار مع جدران' WHERE gid=89;
UPDATE dic_attribute_value SET description_ar='بلاطة دبس او بلاطة مفرغة (وفل) /' WHERE gid=91;
UPDATE dic_attribute_value SET description_ar='عدد الطوابق الموجودة تحت الطابق الأرضي / التسوية' WHERE gid=100;
UPDATE dic_attribute_value SET description_ar='معلومات دقيقة عن الإنشاء أو التقوية الزلزالية' WHERE gid=104;
UPDATE dic_attribute_value SET description_ar='الحد الأدنى والأقصى للمعلومات عن الإنشاء والتقوية الزلزالية ' WHERE gid=105;
UPDATE dic_attribute_value SET description_ar='معروف غير إشغال' WHERE gid=108;
UPDATE dic_attribute_value SET description_ar='استخدام مختلط' WHERE gid=111;
UPDATE dic_attribute_value SET description_ar='الحكومه' WHERE gid=115;
UPDATE dic_attribute_value SET description_ar='أنوع أخرى من الإشغال ' WHERE gid=117;
UPDATE dic_attribute_value SET description_ar='في الغالب سكني وصناعي' WHERE gid=147;
UPDATE dic_attribute_value SET description_ar='في الغالب صناعي وتجاري' WHERE gid=148;
UPDATE dic_attribute_value SET description_ar='IND99 - Industiral' WHERE gid=150;
UPDATE dic_attribute_value SET description_ar='مستودع الإنتاج' WHERE gid=154;
UPDATE dic_attribute_value SET description_ar='ASS99 - Assembly' WHERE gid=157;
UPDATE dic_attribute_value SET description_ar='GOV99 - Government' WHERE gid=162;
UPDATE dic_attribute_value SET description_ar='GOV2 - Government' WHERE gid=164;
UPDATE dic_attribute_value SET description_ar='COM3 - Offices' WHERE gid=134;
UPDATE dic_attribute_value SET description_ar='مواقف مغطاه للمركبات' WHERE gid=138;
UPDATE dic_attribute_value SET description_ar='MIX99 - Mixed' WHERE gid=143;
UPDATE dic_attribute_value SET description_ar='في الغالب تجاري وصناعي' WHERE gid=146;
UPDATE dic_attribute_value SET description_ar='RES2 - Multi-unit' WHERE gid=120;
UPDATE dic_attribute_value SET description_ar='مادة البناء للجدران الخارجية - غيرمعروفة' WHERE gid=212;
UPDATE dic_attribute_value SET description_ar='جدران خارجية من الحجر' WHERE gid=216;
UPDATE dic_attribute_value SET description_ar='Under construction' WHERE gid=389;
UPDATE dic_attribute_value SET description_ar='Vacant building' WHERE gid=390;
UPDATE dic_attribute_value SET description_ar='Comment by the analyst' WHERE gid=391;

SET search_path = public, pg_catalog;
