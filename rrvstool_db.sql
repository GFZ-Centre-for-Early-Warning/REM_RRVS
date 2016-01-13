--
-- PostgreSQL database dump
--

-- Dumped from database version 9.2.8
-- Dumped by pg_dump version 9.2.5
-- Started on 2016-01-13 10:00:29 CET

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 6 (class 2615 OID 1852027)
-- Name: asset; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA asset;


ALTER SCHEMA asset OWNER TO postgres;

--
-- TOC entry 7 (class 2615 OID 1852028)
-- Name: history; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA history;


ALTER SCHEMA history OWNER TO postgres;

--
-- TOC entry 8 (class 2615 OID 1852029)
-- Name: image; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA image;


ALTER SCHEMA image OWNER TO postgres;

--
-- TOC entry 9 (class 2615 OID 1852030)
-- Name: survey; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA survey;


ALTER SCHEMA survey OWNER TO postgres;

--
-- TOC entry 10 (class 2615 OID 1852031)
-- Name: taxonomy; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA taxonomy;


ALTER SCHEMA taxonomy OWNER TO postgres;

--
-- TOC entry 3675 (class 0 OID 0)
-- Dependencies: 10
-- Name: SCHEMA taxonomy; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA taxonomy IS 'includes attribute and qualifiers of possibly different taxonomies';


SET search_path = asset, pg_catalog;

--
-- TOC entry 1445 (class 1255 OID 1853607)
-- Name: edit_object_view(); Type: FUNCTION; Schema: asset; Owner: postgres
--

CREATE FUNCTION edit_object_view() RETURNS trigger
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
		NULL,                              	      -- top-level query or queries (if multistatement) from client
		'D',					      -- transaction_type
		hstore(OLD.*), NULL, NULL);                   -- old_record, new_record, changed_fields
	END IF;
       RETURN NULL;
      END IF;
      RETURN NEW;
END;
$$;


ALTER FUNCTION asset.edit_object_view() OWNER TO postgres;

--
-- TOC entry 3676 (class 0 OID 0)
-- Dependencies: 1445
-- Name: FUNCTION edit_object_view(); Type: COMMENT; Schema: asset; Owner: postgres
--

COMMENT ON FUNCTION edit_object_view() IS '
This function makes the object view (adjusted for the rrvs) editable and forwards the edits to the underlying tables.
';


SET search_path = history, pg_catalog;

--
-- TOC entry 1450 (class 1255 OID 1853921)
-- Name: history_table(regclass); Type: FUNCTION; Schema: history; Owner: postgres
--

CREATE FUNCTION history_table(target_table regclass) RETURNS void
    LANGUAGE sql
    AS $_$
SELECT history.history_table($1, BOOLEAN 'f', BOOLEAN 't');
$_$;


ALTER FUNCTION history.history_table(target_table regclass) OWNER TO postgres;

--
-- TOC entry 3677 (class 0 OID 0)
-- Dependencies: 1450
-- Name: FUNCTION history_table(target_table regclass); Type: COMMENT; Schema: history; Owner: postgres
--

COMMENT ON FUNCTION history_table(target_table regclass) IS '
ADD auditing support TO the given TABLE. Row-level changes will be logged WITH FULL query text. No cols are ignored.
';


--
-- TOC entry 1449 (class 1255 OID 1853920)
-- Name: history_table(regclass, boolean, boolean); Type: FUNCTION; Schema: history; Owner: postgres
--

CREATE FUNCTION history_table(target_table regclass, history_view boolean, history_query_text boolean) RETURNS void
    LANGUAGE sql
    AS $_$
SELECT history.history_table($1, $2, $3, ARRAY[]::text[]);
$_$;


ALTER FUNCTION history.history_table(target_table regclass, history_view boolean, history_query_text boolean) OWNER TO postgres;

--
-- TOC entry 1448 (class 1255 OID 1853919)
-- Name: history_table(regclass, boolean, boolean, text[]); Type: FUNCTION; Schema: history; Owner: postgres
--

CREATE FUNCTION history_table(target_table regclass, history_view boolean, history_query_text boolean, ignored_cols text[]) RETURNS void
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION history.history_table(target_table regclass, history_view boolean, history_query_text boolean, ignored_cols text[]) OWNER TO postgres;

--
-- TOC entry 3678 (class 0 OID 0)
-- Dependencies: 1448
-- Name: FUNCTION history_table(target_table regclass, history_view boolean, history_query_text boolean, ignored_cols text[]); Type: COMMENT; Schema: history; Owner: postgres
--

COMMENT ON FUNCTION history_table(target_table regclass, history_view boolean, history_query_text boolean, ignored_cols text[]) IS '
ADD transaction logging support TO a TABLE.

Arguments:
   target_table:       TABLE name, schema qualified IF NOT ON search_path
   history_view:       Activate trigger for view (true) or for table (false)
   history_query_text: Record the text of the client query that triggered the history event?
   ignored_cols:       COLUMNS TO exclude FROM UPDATE diffs, IGNORE updates that CHANGE only ignored cols.
';


--
-- TOC entry 1446 (class 1255 OID 1853917)
-- Name: if_modified(); Type: FUNCTION; Schema: history; Owner: postgres
--

CREATE FUNCTION if_modified() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO pg_catalog, public
    AS $$
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
$$;


ALTER FUNCTION history.if_modified() OWNER TO postgres;

--
-- TOC entry 3679 (class 0 OID 0)
-- Dependencies: 1446
-- Name: FUNCTION if_modified(); Type: COMMENT; Schema: history; Owner: postgres
--

COMMENT ON FUNCTION if_modified() IS '
Track changes TO a TABLE or a VIEW at the row level.
Optional parameters TO TRIGGER IN CREATE TRIGGER call:
param 0: BOOLEAN, whether TO log the query text. DEFAULT ''t''.
param 1: text[], COLUMNS TO IGNORE IN updates. DEFAULT [].

         Note: Updates TO ignored cols are included in new_record.
         Updates WITH only ignored cols changed are NOT inserted
         INTO the history log.
         There IS no parameter TO disable logging of VALUES. ADD this TRIGGER AS
         a ''FOR EACH STATEMENT'' rather than ''FOR EACH ROW'' TRIGGER IF you do NOT
         want TO log row VALUES.
';


--
-- TOC entry 1447 (class 1255 OID 1853918)
-- Name: if_modified_view(); Type: FUNCTION; Schema: history; Owner: postgres
--

CREATE FUNCTION if_modified_view() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION history.if_modified_view() OWNER TO postgres;

--
-- TOC entry 3680 (class 0 OID 0)
-- Dependencies: 1447
-- Name: FUNCTION if_modified_view(); Type: COMMENT; Schema: history; Owner: postgres
--

COMMENT ON FUNCTION if_modified_view() IS '
This function updates the gid of a view in the logged actions table for the INSERT statement.
';


--
-- TOC entry 1451 (class 1255 OID 1853922)
-- Name: ttime_gethistory(character varying); Type: FUNCTION; Schema: history; Owner: postgres
--

CREATE FUNCTION ttime_gethistory(tbl character varying) RETURNS SETOF record
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION history.ttime_gethistory(tbl character varying) OWNER TO postgres;

--
-- TOC entry 3681 (class 0 OID 0)
-- Dependencies: 1451
-- Name: FUNCTION ttime_gethistory(tbl character varying); Type: COMMENT; Schema: history; Owner: postgres
--

COMMENT ON FUNCTION ttime_gethistory(tbl character varying) IS '
This function searches history.logged_actions to get all transactions of object primitives. Results table structure needs to be defined manually. Returns set of records.
Arguments:
   tbl:		schema.table character varying
';


--
-- TOC entry 1452 (class 1255 OID 1853923)
-- Name: ttime_gethistory(character varying, character varying); Type: FUNCTION; Schema: history; Owner: postgres
--

CREATE FUNCTION ttime_gethistory(tbl_in character varying, tbl_out character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION history.ttime_gethistory(tbl_in character varying, tbl_out character varying) OWNER TO postgres;

--
-- TOC entry 3682 (class 0 OID 0)
-- Dependencies: 1452
-- Name: FUNCTION ttime_gethistory(tbl_in character varying, tbl_out character varying); Type: COMMENT; Schema: history; Owner: postgres
--

COMMENT ON FUNCTION ttime_gethistory(tbl_in character varying, tbl_out character varying) IS '
This function searches history.logged_actions to get all transactions of object primitives. Results table structure is defined dynamically from input table/view. Returns view.
Arguments:
   tbl_in:		schema.table character varying
   tbl_out:		schema.table character varying
';


--
-- TOC entry 1453 (class 1255 OID 1853924)
-- Name: vtime_gethistory(character varying, character varying, character varying); Type: FUNCTION; Schema: history; Owner: postgres
--

CREATE FUNCTION vtime_gethistory(tbl character varying, col_value character varying, col_vtime character varying) RETURNS SETOF record
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION history.vtime_gethistory(tbl character varying, col_value character varying, col_vtime character varying) OWNER TO postgres;

--
-- TOC entry 3683 (class 0 OID 0)
-- Dependencies: 1453
-- Name: FUNCTION vtime_gethistory(tbl character varying, col_value character varying, col_vtime character varying); Type: COMMENT; Schema: history; Owner: postgres
--

COMMENT ON FUNCTION vtime_gethistory(tbl character varying, col_value character varying, col_vtime character varying) IS '
This function searches history.logged_actions to get all real world changes with the corresponding latest version for each object primitive at each valid time.
Results table structure needs to be defined manually. Returns set of records.

Arguments:
   tbl:			table/view that holds the valid time columns character varying
   col_value:		column that holds the qualifier values (BUILT, MODIF, DESTR) character varying
   col_vtime:		column that holds the actual valid time character varying
';


--
-- TOC entry 1454 (class 1255 OID 1853925)
-- Name: vtime_gethistory(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: history; Owner: postgres
--

CREATE FUNCTION vtime_gethistory(tbl_in character varying, tbl_out character varying, col_value character varying, col_vtime character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION history.vtime_gethistory(tbl_in character varying, tbl_out character varying, col_value character varying, col_vtime character varying) OWNER TO postgres;

--
-- TOC entry 3684 (class 0 OID 0)
-- Dependencies: 1454
-- Name: FUNCTION vtime_gethistory(tbl_in character varying, tbl_out character varying, col_value character varying, col_vtime character varying); Type: COMMENT; Schema: history; Owner: postgres
--

COMMENT ON FUNCTION vtime_gethistory(tbl_in character varying, tbl_out character varying, col_value character varying, col_vtime character varying) IS '
This function searches history.logged_actions to get all real world changes with the corresponding latest version for each object primitive at each valid time.
Results table structure is defined dynamically from input table/view. Returns view.
Arguments:
   tbl_in:		schema.table character varying
   tbl_out:		schema.table character varying
   col_value:		column that holds the qualifier values (BUILT, MODIF, DESTR) character varying
   col_vtime:		column that holds the actual valid time character varying
';


SET search_path = asset, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 196 (class 1259 OID 1853609)
-- Name: object; Type: TABLE; Schema: asset; Owner: postgres; Tablespace: 
--

CREATE TABLE object (
    gid integer NOT NULL,
    survey_gid integer,
    description character varying(254),
    source text,
    accuracy numeric,
    the_geom public.geometry
);


ALTER TABLE asset.object OWNER TO postgres;

--
-- TOC entry 3685 (class 0 OID 0)
-- Dependencies: 196
-- Name: TABLE object; Type: COMMENT; Schema: asset; Owner: postgres
--

COMMENT ON TABLE object IS 'The object table (e.g. per building scale). Contains basic information about the object.';


--
-- TOC entry 3686 (class 0 OID 0)
-- Dependencies: 196
-- Name: COLUMN object.gid; Type: COMMENT; Schema: asset; Owner: postgres
--

COMMENT ON COLUMN object.gid IS 'Unique object identifier';


--
-- TOC entry 3687 (class 0 OID 0)
-- Dependencies: 196
-- Name: COLUMN object.survey_gid; Type: COMMENT; Schema: asset; Owner: postgres
--

COMMENT ON COLUMN object.survey_gid IS 'Identifier for the survey';


--
-- TOC entry 3688 (class 0 OID 0)
-- Dependencies: 196
-- Name: COLUMN object.description; Type: COMMENT; Schema: asset; Owner: postgres
--

COMMENT ON COLUMN object.description IS 'Textual description of the object';


--
-- TOC entry 3689 (class 0 OID 0)
-- Dependencies: 196
-- Name: COLUMN object.source; Type: COMMENT; Schema: asset; Owner: postgres
--

COMMENT ON COLUMN object.source IS 'Source of the object (geometry)';


--
-- TOC entry 3690 (class 0 OID 0)
-- Dependencies: 196
-- Name: COLUMN object.accuracy; Type: COMMENT; Schema: asset; Owner: postgres
--

COMMENT ON COLUMN object.accuracy IS 'Accuracy of the object (geometry)';


--
-- TOC entry 3691 (class 0 OID 0)
-- Dependencies: 196
-- Name: COLUMN object.the_geom; Type: COMMENT; Schema: asset; Owner: postgres
--

COMMENT ON COLUMN object.the_geom IS 'Spatial reference and geometry information';


--
-- TOC entry 197 (class 1259 OID 1853615)
-- Name: object_attribute; Type: TABLE; Schema: asset; Owner: postgres; Tablespace: 
--

CREATE TABLE object_attribute (
    gid integer NOT NULL,
    object_id integer,
    attribute_type_code character varying(254),
    attribute_value character varying(254),
    attribute_numeric_1 numeric,
    attribute_numeric_2 numeric,
    attribute_text_1 character varying(254)
);


ALTER TABLE asset.object_attribute OWNER TO postgres;

--
-- TOC entry 3692 (class 0 OID 0)
-- Dependencies: 197
-- Name: TABLE object_attribute; Type: COMMENT; Schema: asset; Owner: postgres
--

COMMENT ON TABLE object_attribute IS 'The object object detail table. Contains information about the object details.';


--
-- TOC entry 3693 (class 0 OID 0)
-- Dependencies: 197
-- Name: COLUMN object_attribute.gid; Type: COMMENT; Schema: asset; Owner: postgres
--

COMMENT ON COLUMN object_attribute.gid IS 'Unique object detail identifier';


--
-- TOC entry 3694 (class 0 OID 0)
-- Dependencies: 197
-- Name: COLUMN object_attribute.object_id; Type: COMMENT; Schema: asset; Owner: postgres
--

COMMENT ON COLUMN object_attribute.object_id IS 'Object identifier';


--
-- TOC entry 3695 (class 0 OID 0)
-- Dependencies: 197
-- Name: COLUMN object_attribute.attribute_type_code; Type: COMMENT; Schema: asset; Owner: postgres
--

COMMENT ON COLUMN object_attribute.attribute_type_code IS 'Code of the taxonomy attribute type';


--
-- TOC entry 3696 (class 0 OID 0)
-- Dependencies: 197
-- Name: COLUMN object_attribute.attribute_value; Type: COMMENT; Schema: asset; Owner: postgres
--

COMMENT ON COLUMN object_attribute.attribute_value IS 'Value of the taxonomy attribute type (from look up table in taxonomy scheme)';


--
-- TOC entry 3697 (class 0 OID 0)
-- Dependencies: 197
-- Name: COLUMN object_attribute.attribute_numeric_1; Type: COMMENT; Schema: asset; Owner: postgres
--

COMMENT ON COLUMN object_attribute.attribute_numeric_1 IS 'Value of the taxonomy attribute type (numeric)';


--
-- TOC entry 3698 (class 0 OID 0)
-- Dependencies: 197
-- Name: COLUMN object_attribute.attribute_numeric_2; Type: COMMENT; Schema: asset; Owner: postgres
--

COMMENT ON COLUMN object_attribute.attribute_numeric_2 IS 'Value of the taxonomy attribute type (numeric)';


--
-- TOC entry 3699 (class 0 OID 0)
-- Dependencies: 197
-- Name: COLUMN object_attribute.attribute_text_1; Type: COMMENT; Schema: asset; Owner: postgres
--

COMMENT ON COLUMN object_attribute.attribute_text_1 IS 'Value of the taxonomy attribute type (textual)';


--
-- TOC entry 198 (class 1259 OID 1853621)
-- Name: object_attribute_gid_seq; Type: SEQUENCE; Schema: asset; Owner: postgres
--

CREATE SEQUENCE object_attribute_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE asset.object_attribute_gid_seq OWNER TO postgres;

--
-- TOC entry 3700 (class 0 OID 0)
-- Dependencies: 198
-- Name: object_attribute_gid_seq; Type: SEQUENCE OWNED BY; Schema: asset; Owner: postgres
--

ALTER SEQUENCE object_attribute_gid_seq OWNED BY object_attribute.gid;


--
-- TOC entry 199 (class 1259 OID 1853623)
-- Name: object_attribute_qualifier; Type: TABLE; Schema: asset; Owner: postgres; Tablespace: 
--

CREATE TABLE object_attribute_qualifier (
    gid integer NOT NULL,
    attribute_id integer,
    qualifier_type_code character varying(254),
    qualifier_value character varying(254),
    qualifier_numeric_1 numeric,
    qualifier_text_1 character varying(254),
    qualifier_timestamp_1 timestamp with time zone
);


ALTER TABLE asset.object_attribute_qualifier OWNER TO postgres;

--
-- TOC entry 3701 (class 0 OID 0)
-- Dependencies: 199
-- Name: TABLE object_attribute_qualifier; Type: COMMENT; Schema: asset; Owner: postgres
--

COMMENT ON TABLE object_attribute_qualifier IS 'The object object attribute qualifier table. Contains information about the object qualifiers.';


--
-- TOC entry 3702 (class 0 OID 0)
-- Dependencies: 199
-- Name: COLUMN object_attribute_qualifier.gid; Type: COMMENT; Schema: asset; Owner: postgres
--

COMMENT ON COLUMN object_attribute_qualifier.gid IS 'Unique object attribute qualifier identifier';


--
-- TOC entry 3703 (class 0 OID 0)
-- Dependencies: 199
-- Name: COLUMN object_attribute_qualifier.attribute_id; Type: COMMENT; Schema: asset; Owner: postgres
--

COMMENT ON COLUMN object_attribute_qualifier.attribute_id IS 'Object atttribute identifier';


--
-- TOC entry 3704 (class 0 OID 0)
-- Dependencies: 199
-- Name: COLUMN object_attribute_qualifier.qualifier_type_code; Type: COMMENT; Schema: asset; Owner: postgres
--

COMMENT ON COLUMN object_attribute_qualifier.qualifier_type_code IS 'Code of the taxonomy qualifier type';


--
-- TOC entry 3705 (class 0 OID 0)
-- Dependencies: 199
-- Name: COLUMN object_attribute_qualifier.qualifier_value; Type: COMMENT; Schema: asset; Owner: postgres
--

COMMENT ON COLUMN object_attribute_qualifier.qualifier_value IS 'Value of the taxonomy qualifier type (from look up table in taxonomy scheme)';


--
-- TOC entry 3706 (class 0 OID 0)
-- Dependencies: 199
-- Name: COLUMN object_attribute_qualifier.qualifier_numeric_1; Type: COMMENT; Schema: asset; Owner: postgres
--

COMMENT ON COLUMN object_attribute_qualifier.qualifier_numeric_1 IS 'Value of the taxonomy qualifier type (numeric)';


--
-- TOC entry 3707 (class 0 OID 0)
-- Dependencies: 199
-- Name: COLUMN object_attribute_qualifier.qualifier_text_1; Type: COMMENT; Schema: asset; Owner: postgres
--

COMMENT ON COLUMN object_attribute_qualifier.qualifier_text_1 IS 'Value of the taxonomy qualifier type (textual)';


--
-- TOC entry 3708 (class 0 OID 0)
-- Dependencies: 199
-- Name: COLUMN object_attribute_qualifier.qualifier_timestamp_1; Type: COMMENT; Schema: asset; Owner: postgres
--

COMMENT ON COLUMN object_attribute_qualifier.qualifier_timestamp_1 IS 'Value of the taxonomy qualifier type (timestamp)';


--
-- TOC entry 200 (class 1259 OID 1853629)
-- Name: object_attribute_qualifier_gid_seq; Type: SEQUENCE; Schema: asset; Owner: postgres
--

CREATE SEQUENCE object_attribute_qualifier_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE asset.object_attribute_qualifier_gid_seq OWNER TO postgres;

--
-- TOC entry 3709 (class 0 OID 0)
-- Dependencies: 200
-- Name: object_attribute_qualifier_gid_seq; Type: SEQUENCE OWNED BY; Schema: asset; Owner: postgres
--

ALTER SEQUENCE object_attribute_qualifier_gid_seq OWNED BY object_attribute_qualifier.gid;


--
-- TOC entry 201 (class 1259 OID 1853631)
-- Name: object_gid_seq; Type: SEQUENCE; Schema: asset; Owner: postgres
--

CREATE SEQUENCE object_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE asset.object_gid_seq OWNER TO postgres;

--
-- TOC entry 3710 (class 0 OID 0)
-- Dependencies: 201
-- Name: object_gid_seq; Type: SEQUENCE OWNED BY; Schema: asset; Owner: postgres
--

ALTER SEQUENCE object_gid_seq OWNED BY object.gid;


--
-- TOC entry 202 (class 1259 OID 1853633)
-- Name: v_object_data; Type: VIEW; Schema: asset; Owner: postgres
--

CREATE VIEW v_object_data AS
    SELECT a.gid, a.survey_gid, a.description, a.source, a.accuracy, a.the_geom, b.object_id, b.mat_type, b.mat_tech, b.mat_prop, b.llrs, b.llrs_duct, b.height, b.yr_built, b.occupy, b.occupy_dt, b."position", b.plan_shape, b.str_irreg, b.str_irreg_dt, b.str_irreg_type, b.nonstrcexw, b.roof_shape, b.roofcovmat, b.roofsysmat, b.roofsystyp, b.roof_conn, b.floor_mat, b.floor_type, b.floor_conn, b.foundn_sys, b.build_type, b.build_subtype, b.vuln, e.vuln_1, e.vuln_2, c.height_1, c.height_2, d.yr_built_vt, d.yr_built_vt1 FROM ((((object a JOIN (SELECT ct.object_id, ct.mat_type, ct.mat_tech, ct.mat_prop, ct.llrs, ct.llrs_duct, ct.height, ct.yr_built, ct.occupy, ct.occupy_dt, ct."position", ct.plan_shape, ct.str_irreg, ct.str_irreg_dt, ct.str_irreg_type, ct.nonstrcexw, ct.roof_shape, ct.roofcovmat, ct.roofsysmat, ct.roofsystyp, ct.roof_conn, ct.floor_mat, ct.floor_type, ct.floor_conn, ct.foundn_sys, ct.build_type, ct.build_subtype, ct.vuln FROM public.crosstab('SELECT object_id, attribute_type_code, attribute_value FROM asset.object_attribute order by object_id'::text, 'select code from taxonomy.dic_attribute_type order by gid'::text) ct(object_id integer, mat_type character varying, mat_tech character varying, mat_prop character varying, llrs character varying, llrs_duct character varying, height character varying, yr_built character varying, occupy character varying, occupy_dt character varying, "position" character varying, plan_shape character varying, str_irreg character varying, str_irreg_dt character varying, str_irreg_type character varying, nonstrcexw character varying, roof_shape character varying, roofcovmat character varying, roofsysmat character varying, roofsystyp character varying, roof_conn character varying, floor_mat character varying, floor_type character varying, floor_conn character varying, foundn_sys character varying, build_type character varying, build_subtype character varying, vuln character varying)) b ON ((a.gid = b.object_id))) LEFT JOIN (SELECT object_attribute.object_id, object_attribute.attribute_numeric_1 AS height_1, object_attribute.attribute_numeric_2 AS height_2 FROM object_attribute object_attribute WHERE ((object_attribute.attribute_type_code)::text = 'HEIGHT'::text)) c ON ((a.gid = c.object_id))) LEFT JOIN (SELECT sub.object_id, sub.qualifier_value AS yr_built_vt, sub.qualifier_timestamp_1 AS yr_built_vt1 FROM (SELECT a.gid, a.object_id, a.attribute_type_code, a.attribute_value, a.attribute_numeric_1, a.attribute_numeric_2, a.attribute_text_1, b.gid, b.attribute_id, b.qualifier_type_code, b.qualifier_value, b.qualifier_numeric_1, b.qualifier_text_1, b.qualifier_timestamp_1 FROM (object_attribute a JOIN object_attribute_qualifier b ON ((a.gid = b.attribute_id)))) sub WHERE (((sub.attribute_type_code)::text = 'YR_BUILT'::text) AND ((sub.qualifier_type_code)::text = 'VALIDTIME'::text)) ORDER BY sub.object_id) d ON ((a.gid = d.object_id))) LEFT JOIN (SELECT object_attribute.object_id, object_attribute.attribute_numeric_1 AS vuln_1, object_attribute.attribute_numeric_2 AS vuln_2 FROM object_attribute object_attribute WHERE ((object_attribute.attribute_type_code)::text = 'VULN'::text)) e ON ((a.gid = e.object_id))) ORDER BY a.gid;


ALTER TABLE asset.v_object_data OWNER TO postgres;

SET search_path = taxonomy, pg_catalog;

--
-- TOC entry 203 (class 1259 OID 1853638)
-- Name: dic_attribute_type; Type: TABLE; Schema: taxonomy; Owner: postgres; Tablespace: 
--

CREATE TABLE dic_attribute_type (
    gid integer NOT NULL,
    code character varying(254),
    description character varying(254),
    extended_description character varying(1024),
    taxonomy_code character varying(254),
    attribute_level smallint,
    attribute_order smallint
);


ALTER TABLE taxonomy.dic_attribute_type OWNER TO postgres;

--
-- TOC entry 3711 (class 0 OID 0)
-- Dependencies: 203
-- Name: TABLE dic_attribute_type; Type: COMMENT; Schema: taxonomy; Owner: postgres
--

COMMENT ON TABLE dic_attribute_type IS 'The attribute type dictionary table. Contains information about the attribute types.';


--
-- TOC entry 3712 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN dic_attribute_type.gid; Type: COMMENT; Schema: taxonomy; Owner: postgres
--

COMMENT ON COLUMN dic_attribute_type.gid IS 'Unique attribute type identifier';


--
-- TOC entry 3713 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN dic_attribute_type.code; Type: COMMENT; Schema: taxonomy; Owner: postgres
--

COMMENT ON COLUMN dic_attribute_type.code IS 'Code of the attribute type';


--
-- TOC entry 3714 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN dic_attribute_type.description; Type: COMMENT; Schema: taxonomy; Owner: postgres
--

COMMENT ON COLUMN dic_attribute_type.description IS 'Short textual description of the attribute type';


--
-- TOC entry 3715 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN dic_attribute_type.extended_description; Type: COMMENT; Schema: taxonomy; Owner: postgres
--

COMMENT ON COLUMN dic_attribute_type.extended_description IS 'Extended textual description of the attribute type';


--
-- TOC entry 3716 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN dic_attribute_type.taxonomy_code; Type: COMMENT; Schema: taxonomy; Owner: postgres
--

COMMENT ON COLUMN dic_attribute_type.taxonomy_code IS 'Code of the taxonomy';


--
-- TOC entry 3717 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN dic_attribute_type.attribute_level; Type: COMMENT; Schema: taxonomy; Owner: postgres
--

COMMENT ON COLUMN dic_attribute_type.attribute_level IS 'Identifier of the attribute level (e.g. GEM taxonomy: 1 = main attribute, 2 = secondary attribute, 3 = tertiary attribute)';


--
-- TOC entry 3718 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN dic_attribute_type.attribute_order; Type: COMMENT; Schema: taxonomy; Owner: postgres
--

COMMENT ON COLUMN dic_attribute_type.attribute_order IS 'Order of the attribute type. To be used for compiling a textual representation of the taxonomy attributes and their values which follows a predefined order (e.g. GEM Taxonomy TaxT strings)';


SET search_path = asset, pg_catalog;

--
-- TOC entry 204 (class 1259 OID 1853644)
-- Name: v_object_metadata; Type: VIEW; Schema: asset; Owner: postgres
--

CREATE VIEW v_object_metadata AS
    SELECT 'THE_GEOM'::character varying AS attribute_type, 'Object geometry'::character varying AS description, ARRAY(SELECT DISTINCT object.source FROM object object) AS source, 'BP'::character varying AS belief_type, avg(object.accuracy) AS avg_belief FROM object object UNION SELECT b.attribute_type_code AS attribute_type, c.description, ARRAY(SELECT DISTINCT object_attribute_qualifier.qualifier_value FROM object_attribute_qualifier object_attribute_qualifier WHERE ((object_attribute_qualifier.qualifier_type_code)::text = 'SOURCE'::text)) AS source, (SELECT DISTINCT object_attribute_qualifier.qualifier_value FROM object_attribute_qualifier object_attribute_qualifier WHERE ((object_attribute_qualifier.qualifier_type_code)::text = 'BELIEF'::text)) AS belief_type, avg(a.qualifier_numeric_1) AS avg_belief FROM ((object_attribute_qualifier a JOIN object_attribute b ON ((a.attribute_id = b.gid))) JOIN taxonomy.dic_attribute_type c ON (((b.attribute_type_code)::text = (c.code)::text))) GROUP BY b.attribute_type_code, c.description, (SELECT DISTINCT object_attribute_qualifier.qualifier_value FROM object_attribute_qualifier object_attribute_qualifier WHERE ((object_attribute_qualifier.qualifier_type_code)::text = 'BELIEF'::text)), ARRAY(SELECT DISTINCT object_attribute_qualifier.qualifier_value FROM object_attribute_qualifier object_attribute_qualifier WHERE ((object_attribute_qualifier.qualifier_type_code)::text = 'SOURCE'::text)) ORDER BY 1;


ALTER TABLE asset.v_object_metadata OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 1853649)
-- Name: ve_object; Type: VIEW; Schema: asset; Owner: postgres
--

CREATE VIEW ve_object AS
    SELECT a.gid, a.survey_gid, a.description, a.source, a.accuracy, a.the_geom, b.object_id, b.mat_type, b.mat_tech, b.mat_prop, b.llrs, b.llrs_duct, b.height, b.yr_built, b.occupy, b.occupy_dt, b."position", b.plan_shape, b.str_irreg, b.str_irreg_dt, b.str_irreg_type, b.nonstrcexw, b.roof_shape, b.roofcovmat, b.roofsysmat, b.roofsystyp, b.roof_conn, b.floor_mat, b.floor_type, b.floor_conn, b.foundn_sys, b.build_type, b.build_subtype, b.vuln, f.vuln_1, f.vuln_2, c.height_1, c.height_2, d.object_id1, d.mat_type_bp, d.mat_tech_bp, d.mat_prop_bp, d.llrs_bp, d.llrs_duct_bp, d.height_bp, d.yr_built_bp, d.occupy_bp, d.occupy_dt_bp, d.position_bp, d.plan_shape_bp, d.str_irreg_bp, d.str_irreg_dt_bp, d.str_irreg_type_bp, d.nonstrcexw_bp, d.roof_shape_bp, d.roofcovmat_bp, d.roofsysmat_bp, d.roofsystyp_bp, d.roof_conn_bp, d.floor_mat_bp, d.floor_type_bp, d.floor_conn_bp, d.foundn_sys_bp, d.build_type_bp, d.build_subtype_bp, d.vuln_bp, e.yr_built_vt, e.yr_built_vt1, g.object_id2, g.mat_type_src, g.mat_tech_src, g.mat_prop_src, g.llrs_src, g.llrs_duct_src, g.height_src, g.yr_built_src, g.occupy_src, g.occupy_dt_src, g.position_src, g.plan_shape_src, g.str_irreg_src, g.str_irreg_dt_src, g.str_irreg_type_src, g.nonstrcexw_src, g.roof_shape_src, g.roofcovmat_src, g.roofsysmat_src, g.roofsystyp_src, g.roof_conn_src, g.floor_mat_src, g.floor_type_src, g.floor_conn_src, g.foundn_sys_src, g.build_type_src, g.build_subtype_src, g.vuln_src FROM ((((((object a JOIN (SELECT ct.object_id, ct.mat_type, ct.mat_tech, ct.mat_prop, ct.llrs, ct.llrs_duct, ct.height, ct.yr_built, ct.occupy, ct.occupy_dt, ct."position", ct.plan_shape, ct.str_irreg, ct.str_irreg_dt, ct.str_irreg_type, ct.nonstrcexw, ct.roof_shape, ct.roofcovmat, ct.roofsysmat, ct.roofsystyp, ct.roof_conn, ct.floor_mat, ct.floor_type, ct.floor_conn, ct.foundn_sys, ct.build_type, ct.build_subtype, ct.vuln FROM public.crosstab('SELECT object_id, attribute_type_code, attribute_value FROM asset.object_attribute order by object_id'::text, 'select code from taxonomy.dic_attribute_type order by gid'::text) ct(object_id integer, mat_type character varying, mat_tech character varying, mat_prop character varying, llrs character varying, llrs_duct character varying, height character varying, yr_built character varying, occupy character varying, occupy_dt character varying, "position" character varying, plan_shape character varying, str_irreg character varying, str_irreg_dt character varying, str_irreg_type character varying, nonstrcexw character varying, roof_shape character varying, roofcovmat character varying, roofsysmat character varying, roofsystyp character varying, roof_conn character varying, floor_mat character varying, floor_type character varying, floor_conn character varying, foundn_sys character varying, build_type character varying, build_subtype character varying, vuln character varying)) b ON ((a.gid = b.object_id))) LEFT JOIN (SELECT object_attribute.object_id, object_attribute.attribute_numeric_1 AS height_1, object_attribute.attribute_numeric_2 AS height_2 FROM object_attribute object_attribute WHERE ((object_attribute.attribute_type_code)::text = 'HEIGHT'::text)) c ON ((a.gid = c.object_id))) JOIN (SELECT a.object_id1, a.mat_type_bp, a.mat_tech_bp, a.mat_prop_bp, a.llrs_bp, a.llrs_duct_bp, a.height_bp, a.yr_built_bp, a.occupy_bp, a.occupy_dt_bp, a.position_bp, a.plan_shape_bp, a.str_irreg_bp, a.str_irreg_dt_bp, a.str_irreg_type_bp, a.nonstrcexw_bp, a.roof_shape_bp, a.roofcovmat_bp, a.roofsysmat_bp, a.roofsystyp_bp, a.roof_conn_bp, a.floor_mat_bp, a.floor_type_bp, a.floor_conn_bp, a.foundn_sys_bp, a.build_type_bp, a.build_subtype_bp, a.vuln_bp FROM public.crosstab('SELECT object_id, attribute_type_code, qualifier_numeric_1 FROM (SELECT * FROM asset.object_attribute as a
				JOIN (SELECT * FROM asset.object_attribute_qualifier WHERE qualifier_type_code=''BELIEF'') as b
				ON (a.gid = b.attribute_id)) sub ORDER BY object_id'::text, 'SELECT code from taxonomy.dic_attribute_type order by gid'::text) a(object_id1 integer, mat_type_bp integer, mat_tech_bp integer, mat_prop_bp integer, llrs_bp integer, llrs_duct_bp integer, height_bp integer, yr_built_bp integer, occupy_bp integer, occupy_dt_bp integer, position_bp integer, plan_shape_bp integer, str_irreg_bp integer, str_irreg_dt_bp integer, str_irreg_type_bp integer, nonstrcexw_bp integer, roof_shape_bp integer, roofcovmat_bp integer, roofsysmat_bp integer, roofsystyp_bp integer, roof_conn_bp integer, floor_mat_bp integer, floor_type_bp integer, floor_conn_bp integer, foundn_sys_bp integer, build_type_bp integer, build_subtype_bp integer, vuln_bp integer)) d ON ((a.gid = d.object_id1))) LEFT JOIN (SELECT sub.object_id, sub.qualifier_value AS yr_built_vt, sub.qualifier_timestamp_1 AS yr_built_vt1 FROM (SELECT a.gid, a.object_id, a.attribute_type_code, a.attribute_value, a.attribute_numeric_1, a.attribute_numeric_2, a.attribute_text_1, b.gid, b.attribute_id, b.qualifier_type_code, b.qualifier_value, b.qualifier_numeric_1, b.qualifier_text_1, b.qualifier_timestamp_1 FROM (object_attribute a JOIN object_attribute_qualifier b ON ((a.gid = b.attribute_id)))) sub WHERE (((sub.attribute_type_code)::text = 'YR_BUILT'::text) AND ((sub.qualifier_type_code)::text = 'VALIDTIME'::text)) ORDER BY sub.object_id) e ON ((a.gid = e.object_id))) LEFT JOIN (SELECT object_attribute.object_id, object_attribute.attribute_numeric_1 AS vuln_1, object_attribute.attribute_numeric_2 AS vuln_2 FROM object_attribute object_attribute WHERE ((object_attribute.attribute_type_code)::text = 'VULN'::text)) f ON ((a.gid = f.object_id))) JOIN (SELECT ct.object_id2, ct.mat_type_src, ct.mat_tech_src, ct.mat_prop_src, ct.llrs_src, ct.llrs_duct_src, ct.height_src, ct.yr_built_src, ct.occupy_src, ct.occupy_dt_src, ct.position_src, ct.plan_shape_src, ct.str_irreg_src, ct.str_irreg_dt_src, ct.str_irreg_type_src, ct.nonstrcexw_src, ct.roof_shape_src, ct.roofcovmat_src, ct.roofsysmat_src, ct.roofsystyp_src, ct.roof_conn_src, ct.floor_mat_src, ct.floor_type_src, ct.floor_conn_src, ct.foundn_sys_src, ct.build_type_src, ct.build_subtype_src, ct.vuln_src FROM public.crosstab('SELECT object_id, attribute_type_code, qualifier_value FROM (SELECT * FROM asset.object_attribute as a
				JOIN (SELECT * FROM asset.object_attribute_qualifier WHERE qualifier_type_code=''SOURCE'') as b
				ON (a.gid = b.attribute_id)) sub ORDER BY object_id'::text, 'SELECT code from taxonomy.dic_attribute_type order by gid'::text) ct(object_id2 integer, mat_type_src character varying, mat_tech_src character varying, mat_prop_src character varying, llrs_src character varying, llrs_duct_src character varying, height_src character varying, yr_built_src character varying, occupy_src character varying, occupy_dt_src character varying, position_src character varying, plan_shape_src character varying, str_irreg_src character varying, str_irreg_dt_src character varying, str_irreg_type_src character varying, nonstrcexw_src character varying, roof_shape_src character varying, roofcovmat_src character varying, roofsysmat_src character varying, roofsystyp_src character varying, roof_conn_src character varying, floor_mat_src character varying, floor_type_src character varying, floor_conn_src character varying, foundn_sys_src character varying, build_type_src character varying, build_subtype_src character varying, vuln_src character varying)) g ON ((a.gid = g.object_id2))) ORDER BY a.gid;


ALTER TABLE asset.ve_object OWNER TO postgres;

SET search_path = history, pg_catalog;

--
-- TOC entry 206 (class 1259 OID 1853654)
-- Name: logged_actions; Type: TABLE; Schema: history; Owner: postgres; Tablespace: 
--

CREATE TABLE logged_actions (
    gid bigint NOT NULL,
    schema_name text NOT NULL,
    table_name text NOT NULL,
    table_id oid NOT NULL,
    transaction_id bigint,
    transaction_user text,
    transaction_time timestamp with time zone NOT NULL,
    transaction_query text,
    transaction_type text NOT NULL,
    old_record public.hstore,
    new_record public.hstore,
    changed_fields public.hstore,
    CONSTRAINT logged_actions_transaction_type_check CHECK ((transaction_type = ANY (ARRAY['I'::text, 'D'::text, 'U'::text, 'T'::text])))
);


ALTER TABLE history.logged_actions OWNER TO postgres;

--
-- TOC entry 3719 (class 0 OID 0)
-- Dependencies: 206
-- Name: TABLE logged_actions; Type: COMMENT; Schema: history; Owner: postgres
--

COMMENT ON TABLE logged_actions IS 'History of transactions on activated tables, from history.if_modified_func().';


--
-- TOC entry 3720 (class 0 OID 0)
-- Dependencies: 206
-- Name: COLUMN logged_actions.gid; Type: COMMENT; Schema: history; Owner: postgres
--

COMMENT ON COLUMN logged_actions.gid IS 'Unique log identifier';


--
-- TOC entry 3721 (class 0 OID 0)
-- Dependencies: 206
-- Name: COLUMN logged_actions.schema_name; Type: COMMENT; Schema: history; Owner: postgres
--

COMMENT ON COLUMN logged_actions.schema_name IS 'Textual reference to the database schema which contains the modified table';


--
-- TOC entry 3722 (class 0 OID 0)
-- Dependencies: 206
-- Name: COLUMN logged_actions.table_name; Type: COMMENT; Schema: history; Owner: postgres
--

COMMENT ON COLUMN logged_actions.table_name IS 'Name of the modified table';


--
-- TOC entry 3723 (class 0 OID 0)
-- Dependencies: 206
-- Name: COLUMN logged_actions.table_id; Type: COMMENT; Schema: history; Owner: postgres
--

COMMENT ON COLUMN logged_actions.table_id IS 'OID of the modified table';


--
-- TOC entry 3724 (class 0 OID 0)
-- Dependencies: 206
-- Name: COLUMN logged_actions.transaction_id; Type: COMMENT; Schema: history; Owner: postgres
--

COMMENT ON COLUMN logged_actions.transaction_id IS 'Identifier of the transaction (may differ from gid when more than one row is affected by a transaction query)';


--
-- TOC entry 3725 (class 0 OID 0)
-- Dependencies: 206
-- Name: COLUMN logged_actions.transaction_user; Type: COMMENT; Schema: history; Owner: postgres
--

COMMENT ON COLUMN logged_actions.transaction_user IS 'Session user name who caused the transaction';


--
-- TOC entry 3726 (class 0 OID 0)
-- Dependencies: 206
-- Name: COLUMN logged_actions.transaction_time; Type: COMMENT; Schema: history; Owner: postgres
--

COMMENT ON COLUMN logged_actions.transaction_time IS 'Timestamp when transaction was started (current_timestamp)';


--
-- TOC entry 3727 (class 0 OID 0)
-- Dependencies: 206
-- Name: COLUMN logged_actions.transaction_query; Type: COMMENT; Schema: history; Owner: postgres
--

COMMENT ON COLUMN logged_actions.transaction_query IS 'Transaction query';


--
-- TOC entry 3728 (class 0 OID 0)
-- Dependencies: 206
-- Name: COLUMN logged_actions.transaction_type; Type: COMMENT; Schema: history; Owner: postgres
--

COMMENT ON COLUMN logged_actions.transaction_type IS 'Transaction type (I = insert, D = delete, U = update, T = truncate)';


--
-- TOC entry 3729 (class 0 OID 0)
-- Dependencies: 206
-- Name: COLUMN logged_actions.old_record; Type: COMMENT; Schema: history; Owner: postgres
--

COMMENT ON COLUMN logged_actions.old_record IS 'The old record before the modification containing all the values as hstore (for DELETE and UPDATE statements)';


--
-- TOC entry 3730 (class 0 OID 0)
-- Dependencies: 206
-- Name: COLUMN logged_actions.new_record; Type: COMMENT; Schema: history; Owner: postgres
--

COMMENT ON COLUMN logged_actions.new_record IS 'The new record after the modification containing all the values as hstore (for INSERT and UPDATE statements)';


--
-- TOC entry 3731 (class 0 OID 0)
-- Dependencies: 206
-- Name: COLUMN logged_actions.changed_fields; Type: COMMENT; Schema: history; Owner: postgres
--

COMMENT ON COLUMN logged_actions.changed_fields IS 'The modified fields only, including the new values, stored as hstore';


--
-- TOC entry 207 (class 1259 OID 1853661)
-- Name: logged_actions_gid_seq; Type: SEQUENCE; Schema: history; Owner: postgres
--

CREATE SEQUENCE logged_actions_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE history.logged_actions_gid_seq OWNER TO postgres;

--
-- TOC entry 3732 (class 0 OID 0)
-- Dependencies: 207
-- Name: logged_actions_gid_seq; Type: SEQUENCE OWNED BY; Schema: history; Owner: postgres
--

ALTER SEQUENCE logged_actions_gid_seq OWNED BY logged_actions.gid;


SET search_path = image, pg_catalog;

--
-- TOC entry 208 (class 1259 OID 1853663)
-- Name: gpano_metadata; Type: TABLE; Schema: image; Owner: postgres; Tablespace: 
--

CREATE TABLE gpano_metadata (
    gid integer NOT NULL,
    usepanoramaviewer boolean,
    capturesoftware character varying,
    stichingsoftware character varying,
    projectiontype character varying DEFAULT 'equirectangular'::character varying NOT NULL,
    poseheadingdegrees real,
    posepitchdegrees real DEFAULT 0,
    poserolldegrees real DEFAULT 0,
    initialviewheadingdegrees integer DEFAULT 0,
    initialviewpitchdegrees integer DEFAULT 0,
    initialviewrolldegrees integer DEFAULT 0,
    initialhorizontalfovdegrees real,
    firstphotodate timestamp without time zone,
    sourcephotoscount integer,
    exposurelockused boolean,
    croppedareaimagewidthpixels integer NOT NULL,
    croppedareaimageheightpixels integer NOT NULL,
    fullpanoheightpixels integer NOT NULL,
    croppedarealeftpixels integer NOT NULL,
    croppedareatoppixels integer NOT NULL,
    initialcameradolly real DEFAULT 0
);


ALTER TABLE image.gpano_metadata OWNER TO postgres;

--
-- TOC entry 3733 (class 0 OID 0)
-- Dependencies: 208
-- Name: TABLE gpano_metadata; Type: COMMENT; Schema: image; Owner: postgres
--

COMMENT ON TABLE gpano_metadata IS ' Photosphere XMP metadata. Properties that provide information regarding the creation and rendering of photo spheres, also sometimes referred to as panoramas';


--
-- TOC entry 3734 (class 0 OID 0)
-- Dependencies: 208
-- Name: COLUMN gpano_metadata.gid; Type: COMMENT; Schema: image; Owner: postgres
--

COMMENT ON COLUMN gpano_metadata.gid IS 'unique identifier';


--
-- TOC entry 3735 (class 0 OID 0)
-- Dependencies: 208
-- Name: COLUMN gpano_metadata.usepanoramaviewer; Type: COMMENT; Schema: image; Owner: postgres
--

COMMENT ON COLUMN gpano_metadata.usepanoramaviewer IS 'Whether to show this image in a photo sphere viewer rather than as a normal flat image. This may be specified based on user preferences or by the stitching software. The application displaying or ingesting the image may choose to ignore this.';


--
-- TOC entry 3736 (class 0 OID 0)
-- Dependencies: 208
-- Name: COLUMN gpano_metadata.capturesoftware; Type: COMMENT; Schema: image; Owner: postgres
--

COMMENT ON COLUMN gpano_metadata.capturesoftware IS 'If capture was done using an application on a mobile device, such as an Android phone, the name of the application that was used (such as “Photo Sphere”). This should be left blank if source images were captured manually, such as by using a DSLR on a tripod.';


--
-- TOC entry 3737 (class 0 OID 0)
-- Dependencies: 208
-- Name: COLUMN gpano_metadata.stichingsoftware; Type: COMMENT; Schema: image; Owner: postgres
--

COMMENT ON COLUMN gpano_metadata.stichingsoftware IS 'The software that was used to create the final photo sphere. This may sometimes be the same value as that of  GPano:CaptureSoftware.';


--
-- TOC entry 3738 (class 0 OID 0)
-- Dependencies: 208
-- Name: COLUMN gpano_metadata.projectiontype; Type: COMMENT; Schema: image; Owner: postgres
--

COMMENT ON COLUMN gpano_metadata.projectiontype IS 'Projection type used in the image file. Google products currently support the value equirectangular.';


--
-- TOC entry 3739 (class 0 OID 0)
-- Dependencies: 208
-- Name: COLUMN gpano_metadata.poseheadingdegrees; Type: COMMENT; Schema: image; Owner: postgres
--

COMMENT ON COLUMN gpano_metadata.poseheadingdegrees IS 'Compass heading, measured in degrees, for the center the image. Value must be >= 0 and < 360.';


--
-- TOC entry 3740 (class 0 OID 0)
-- Dependencies: 208
-- Name: COLUMN gpano_metadata.posepitchdegrees; Type: COMMENT; Schema: image; Owner: postgres
--

COMMENT ON COLUMN gpano_metadata.posepitchdegrees IS 'Pitch, measured in degrees, for the center in the image. Value must be >= -90 and <= 90.';


--
-- TOC entry 3741 (class 0 OID 0)
-- Dependencies: 208
-- Name: COLUMN gpano_metadata.poserolldegrees; Type: COMMENT; Schema: image; Owner: postgres
--

COMMENT ON COLUMN gpano_metadata.poserolldegrees IS 'Roll, measured in degrees, of the image where level with the horizon is 0. Value must be > -180 and <= 180.';


--
-- TOC entry 3742 (class 0 OID 0)
-- Dependencies: 208
-- Name: COLUMN gpano_metadata.initialviewheadingdegrees; Type: COMMENT; Schema: image; Owner: postgres
--

COMMENT ON COLUMN gpano_metadata.initialviewheadingdegrees IS 'The heading angle of the initial view in degrees.';


--
-- TOC entry 3743 (class 0 OID 0)
-- Dependencies: 208
-- Name: COLUMN gpano_metadata.initialviewpitchdegrees; Type: COMMENT; Schema: image; Owner: postgres
--

COMMENT ON COLUMN gpano_metadata.initialviewpitchdegrees IS 'The pitch angle of the initial view in degrees.';


--
-- TOC entry 3744 (class 0 OID 0)
-- Dependencies: 208
-- Name: COLUMN gpano_metadata.initialviewrolldegrees; Type: COMMENT; Schema: image; Owner: postgres
--

COMMENT ON COLUMN gpano_metadata.initialviewrolldegrees IS 'The roll angle of the initial view in degrees.';


--
-- TOC entry 3745 (class 0 OID 0)
-- Dependencies: 208
-- Name: COLUMN gpano_metadata.initialhorizontalfovdegrees; Type: COMMENT; Schema: image; Owner: postgres
--

COMMENT ON COLUMN gpano_metadata.initialhorizontalfovdegrees IS 'The initial horizontal field of view that the viewer should display (in degrees). This is similar to a zoom level.';


--
-- TOC entry 3746 (class 0 OID 0)
-- Dependencies: 208
-- Name: COLUMN gpano_metadata.firstphotodate; Type: COMMENT; Schema: image; Owner: postgres
--

COMMENT ON COLUMN gpano_metadata.firstphotodate IS 'Date and time for the first image created in the photo sphere.';


--
-- TOC entry 3747 (class 0 OID 0)
-- Dependencies: 208
-- Name: COLUMN gpano_metadata.sourcephotoscount; Type: COMMENT; Schema: image; Owner: postgres
--

COMMENT ON COLUMN gpano_metadata.sourcephotoscount IS 'Number of source images used to create the photo sphere.';


--
-- TOC entry 3748 (class 0 OID 0)
-- Dependencies: 208
-- Name: COLUMN gpano_metadata.exposurelockused; Type: COMMENT; Schema: image; Owner: postgres
--

COMMENT ON COLUMN gpano_metadata.exposurelockused IS 'When individual source photographs were captured, whether or not the camera’s exposure setting was locked. ';


--
-- TOC entry 3749 (class 0 OID 0)
-- Dependencies: 208
-- Name: COLUMN gpano_metadata.croppedareaimagewidthpixels; Type: COMMENT; Schema: image; Owner: postgres
--

COMMENT ON COLUMN gpano_metadata.croppedareaimagewidthpixels IS ' Original width in pixels of the image (equal to the actual image’s width for unedited images).';


--
-- TOC entry 3750 (class 0 OID 0)
-- Dependencies: 208
-- Name: COLUMN gpano_metadata.croppedareaimageheightpixels; Type: COMMENT; Schema: image; Owner: postgres
--

COMMENT ON COLUMN gpano_metadata.croppedareaimageheightpixels IS 'Original height in pixels of the image (equal to the actual image’s height for unedited images).';


--
-- TOC entry 3751 (class 0 OID 0)
-- Dependencies: 208
-- Name: COLUMN gpano_metadata.fullpanoheightpixels; Type: COMMENT; Schema: image; Owner: postgres
--

COMMENT ON COLUMN gpano_metadata.fullpanoheightpixels IS 'Original full height from which the image was cropped. If only a partial photo sphere was captured, this specifies the height of what the full photo sphere would have been.';


--
-- TOC entry 3752 (class 0 OID 0)
-- Dependencies: 208
-- Name: COLUMN gpano_metadata.croppedarealeftpixels; Type: COMMENT; Schema: image; Owner: postgres
--

COMMENT ON COLUMN gpano_metadata.croppedarealeftpixels IS 'Column where the left edge of the image was cropped from the full sized photo sphere.';


--
-- TOC entry 3753 (class 0 OID 0)
-- Dependencies: 208
-- Name: COLUMN gpano_metadata.croppedareatoppixels; Type: COMMENT; Schema: image; Owner: postgres
--

COMMENT ON COLUMN gpano_metadata.croppedareatoppixels IS 'Row where the top edge of the image was cropped from the full sized photo sphere.';


--
-- TOC entry 3754 (class 0 OID 0)
-- Dependencies: 208
-- Name: COLUMN gpano_metadata.initialcameradolly; Type: COMMENT; Schema: image; Owner: postgres
--

COMMENT ON COLUMN gpano_metadata.initialcameradolly IS 'This optional parameter moves the virtual camera position along the line of sight, away from the center of the photo sphere. A rear surface position is represented by the value -1.0, while a front surface position is represented by 1.0. For normal viewing, this parameter should be set to 0.';


--
-- TOC entry 209 (class 1259 OID 1853676)
-- Name: gpano_metadata_gid_seq; Type: SEQUENCE; Schema: image; Owner: postgres
--

CREATE SEQUENCE gpano_metadata_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE image.gpano_metadata_gid_seq OWNER TO postgres;

--
-- TOC entry 3755 (class 0 OID 0)
-- Dependencies: 209
-- Name: gpano_metadata_gid_seq; Type: SEQUENCE OWNED BY; Schema: image; Owner: postgres
--

ALTER SEQUENCE gpano_metadata_gid_seq OWNED BY gpano_metadata.gid;


--
-- TOC entry 210 (class 1259 OID 1853678)
-- Name: gps; Type: TABLE; Schema: image; Owner: postgres; Tablespace: 
--

CREATE TABLE gps (
    gid integer,
    img_id integer,
    altitude real,
    azimuth real,
    abspeed real,
    the_geom public.geometry,
    lat real,
    lon real
);


ALTER TABLE image.gps OWNER TO postgres;

--
-- TOC entry 3756 (class 0 OID 0)
-- Dependencies: 210
-- Name: TABLE gps; Type: COMMENT; Schema: image; Owner: postgres
--

COMMENT ON TABLE gps IS 'basic information about position, derived from GPS measurements (can be interpolated)';


--
-- TOC entry 3757 (class 0 OID 0)
-- Dependencies: 210
-- Name: COLUMN gps.altitude; Type: COMMENT; Schema: image; Owner: postgres
--

COMMENT ON COLUMN gps.altitude IS 'altitude in meters (an be interpolated)';


--
-- TOC entry 3758 (class 0 OID 0)
-- Dependencies: 210
-- Name: COLUMN gps.azimuth; Type: COMMENT; Schema: image; Owner: postgres
--

COMMENT ON COLUMN gps.azimuth IS 'direction of motion, in degrees, clockwise  from the north';


--
-- TOC entry 3759 (class 0 OID 0)
-- Dependencies: 210
-- Name: COLUMN gps.abspeed; Type: COMMENT; Schema: image; Owner: postgres
--

COMMENT ON COLUMN gps.abspeed IS 'absolute speed at measurement time, in km/h (can be interpolated)';


--
-- TOC entry 3760 (class 0 OID 0)
-- Dependencies: 210
-- Name: COLUMN gps.lat; Type: COMMENT; Schema: image; Owner: postgres
--

COMMENT ON COLUMN gps.lat IS 'latitude (can be interpolated)';


--
-- TOC entry 3761 (class 0 OID 0)
-- Dependencies: 210
-- Name: COLUMN gps.lon; Type: COMMENT; Schema: image; Owner: postgres
--

COMMENT ON COLUMN gps.lon IS 'longitude, in degrees WGS84 ';


--
-- TOC entry 211 (class 1259 OID 1853684)
-- Name: image_type; Type: TABLE; Schema: image; Owner: postgres; Tablespace: 
--

CREATE TABLE image_type (
    gid integer NOT NULL,
    code character varying(50) NOT NULL,
    description character varying(255)
);


ALTER TABLE image.image_type OWNER TO postgres;

--
-- TOC entry 3762 (class 0 OID 0)
-- Dependencies: 211
-- Name: TABLE image_type; Type: COMMENT; Schema: image; Owner: postgres
--

COMMENT ON TABLE image_type IS 'possible types of images';


--
-- TOC entry 3763 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN image_type.code; Type: COMMENT; Schema: image; Owner: postgres
--

COMMENT ON COLUMN image_type.code IS 'alfanumeric descriptor of image type';


--
-- TOC entry 3764 (class 0 OID 0)
-- Dependencies: 211
-- Name: COLUMN image_type.description; Type: COMMENT; Schema: image; Owner: postgres
--

COMMENT ON COLUMN image_type.description IS 'short text descriptino of the image type';


--
-- TOC entry 212 (class 1259 OID 1853687)
-- Name: image_type_gid_seq; Type: SEQUENCE; Schema: image; Owner: postgres
--

CREATE SEQUENCE image_type_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE image.image_type_gid_seq OWNER TO postgres;

--
-- TOC entry 3765 (class 0 OID 0)
-- Dependencies: 212
-- Name: image_type_gid_seq; Type: SEQUENCE OWNED BY; Schema: image; Owner: postgres
--

ALTER SEQUENCE image_type_gid_seq OWNED BY image_type.gid;


--
-- TOC entry 213 (class 1259 OID 1853689)
-- Name: img; Type: TABLE; Schema: image; Owner: postgres; Tablespace: 
--

CREATE TABLE img (
    gid integer,
    source text,
    gps integer,
    survey integer,
    "timestamp" timestamp without time zone,
    filename character varying(100),
    type character varying,
    repository character varying(255),
    frame_id integer,
    gpano integer,
    width integer,
    height integer
);


ALTER TABLE image.img OWNER TO postgres;

--
-- TOC entry 3766 (class 0 OID 0)
-- Dependencies: 213
-- Name: TABLE img; Type: COMMENT; Schema: image; Owner: postgres
--

COMMENT ON TABLE img IS 'image descriptor';


--
-- TOC entry 3767 (class 0 OID 0)
-- Dependencies: 213
-- Name: COLUMN img.gps; Type: COMMENT; Schema: image; Owner: postgres
--

COMMENT ON COLUMN img.gps IS 'info from GPS ';


--
-- TOC entry 3768 (class 0 OID 0)
-- Dependencies: 213
-- Name: COLUMN img.survey; Type: COMMENT; Schema: image; Owner: postgres
--

COMMENT ON COLUMN img.survey IS 'code of the survey that generated the images';


--
-- TOC entry 3769 (class 0 OID 0)
-- Dependencies: 213
-- Name: COLUMN img."timestamp"; Type: COMMENT; Schema: image; Owner: postgres
--

COMMENT ON COLUMN img."timestamp" IS 'creation of the image, in Universal Coordinated Time (UTC)';


--
-- TOC entry 3770 (class 0 OID 0)
-- Dependencies: 213
-- Name: COLUMN img.filename; Type: COMMENT; Schema: image; Owner: postgres
--

COMMENT ON COLUMN img.filename IS 'name of the physical file of the image, if existing, with extension';


--
-- TOC entry 3771 (class 0 OID 0)
-- Dependencies: 213
-- Name: COLUMN img.type; Type: COMMENT; Schema: image; Owner: postgres
--

COMMENT ON COLUMN img.type IS 'type of image';


--
-- TOC entry 3772 (class 0 OID 0)
-- Dependencies: 213
-- Name: COLUMN img.repository; Type: COMMENT; Schema: image; Owner: postgres
--

COMMENT ON COLUMN img.repository IS 'physical path to the repository hosting the image file, if existing ';


--
-- TOC entry 3773 (class 0 OID 0)
-- Dependencies: 213
-- Name: COLUMN img.frame_id; Type: COMMENT; Schema: image; Owner: postgres
--

COMMENT ON COLUMN img.frame_id IS 'id of the frame in an omnidirectional PGR sequence';


--
-- TOC entry 3774 (class 0 OID 0)
-- Dependencies: 213
-- Name: COLUMN img.gpano; Type: COMMENT; Schema: image; Owner: postgres
--

COMMENT ON COLUMN img.gpano IS 'gpano metadata';


--
-- TOC entry 3775 (class 0 OID 0)
-- Dependencies: 213
-- Name: COLUMN img.width; Type: COMMENT; Schema: image; Owner: postgres
--

COMMENT ON COLUMN img.width IS 'number of columns';


--
-- TOC entry 3776 (class 0 OID 0)
-- Dependencies: 213
-- Name: COLUMN img.height; Type: COMMENT; Schema: image; Owner: postgres
--

COMMENT ON COLUMN img.height IS 'number of rows';


SET search_path = survey, pg_catalog;

--
-- TOC entry 214 (class 1259 OID 1853695)
-- Name: survey; Type: TABLE; Schema: survey; Owner: postgres; Tablespace: 
--

CREATE TABLE survey (
    gid integer NOT NULL,
    name character varying(100),
    description character varying(255),
    type character varying(100),
    resp character varying(255)
);


ALTER TABLE survey.survey OWNER TO postgres;

--
-- TOC entry 3777 (class 0 OID 0)
-- Dependencies: 214
-- Name: TABLE survey; Type: COMMENT; Schema: survey; Owner: postgres
--

COMMENT ON TABLE survey IS 'main description of the survey';


--
-- TOC entry 3778 (class 0 OID 0)
-- Dependencies: 214
-- Name: COLUMN survey.gid; Type: COMMENT; Schema: survey; Owner: postgres
--

COMMENT ON COLUMN survey.gid IS 'unique id';


--
-- TOC entry 3779 (class 0 OID 0)
-- Dependencies: 214
-- Name: COLUMN survey.name; Type: COMMENT; Schema: survey; Owner: postgres
--

COMMENT ON COLUMN survey.name IS 'survey (short) name ';


--
-- TOC entry 3780 (class 0 OID 0)
-- Dependencies: 214
-- Name: COLUMN survey.description; Type: COMMENT; Schema: survey; Owner: postgres
--

COMMENT ON COLUMN survey.description IS 'short description of the survey';


--
-- TOC entry 3781 (class 0 OID 0)
-- Dependencies: 214
-- Name: COLUMN survey.type; Type: COMMENT; Schema: survey; Owner: postgres
--

COMMENT ON COLUMN survey.type IS 'survey type';


--
-- TOC entry 3782 (class 0 OID 0)
-- Dependencies: 214
-- Name: COLUMN survey.resp; Type: COMMENT; Schema: survey; Owner: postgres
--

COMMENT ON COLUMN survey.resp IS 'name of survey responsible';


--
-- TOC entry 215 (class 1259 OID 1853701)
-- Name: survey_gid_seq; Type: SEQUENCE; Schema: survey; Owner: postgres
--

CREATE SEQUENCE survey_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE survey.survey_gid_seq OWNER TO postgres;

--
-- TOC entry 3783 (class 0 OID 0)
-- Dependencies: 215
-- Name: survey_gid_seq; Type: SEQUENCE OWNED BY; Schema: survey; Owner: postgres
--

ALTER SEQUENCE survey_gid_seq OWNED BY survey.gid;


--
-- TOC entry 216 (class 1259 OID 1853703)
-- Name: survey_type; Type: TABLE; Schema: survey; Owner: postgres; Tablespace: 
--

CREATE TABLE survey_type (
    gid integer NOT NULL,
    code character varying(100),
    description character varying(255)
);


ALTER TABLE survey.survey_type OWNER TO postgres;

--
-- TOC entry 3784 (class 0 OID 0)
-- Dependencies: 216
-- Name: TABLE survey_type; Type: COMMENT; Schema: survey; Owner: postgres
--

COMMENT ON TABLE survey_type IS 'list the different types of surveys which can generate or modify assset contents';


--
-- TOC entry 3785 (class 0 OID 0)
-- Dependencies: 216
-- Name: COLUMN survey_type.gid; Type: COMMENT; Schema: survey; Owner: postgres
--

COMMENT ON COLUMN survey_type.gid IS 'unique id';


--
-- TOC entry 3786 (class 0 OID 0)
-- Dependencies: 216
-- Name: COLUMN survey_type.code; Type: COMMENT; Schema: survey; Owner: postgres
--

COMMENT ON COLUMN survey_type.code IS 'alfanumeric identifier of the survey type';


--
-- TOC entry 3787 (class 0 OID 0)
-- Dependencies: 216
-- Name: COLUMN survey_type.description; Type: COMMENT; Schema: survey; Owner: postgres
--

COMMENT ON COLUMN survey_type.description IS 'short textual description of the type';


--
-- TOC entry 217 (class 1259 OID 1853706)
-- Name: survey_type_gid_seq; Type: SEQUENCE; Schema: survey; Owner: postgres
--

CREATE SEQUENCE survey_type_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE survey.survey_type_gid_seq OWNER TO postgres;

--
-- TOC entry 3788 (class 0 OID 0)
-- Dependencies: 217
-- Name: survey_type_gid_seq; Type: SEQUENCE OWNED BY; Schema: survey; Owner: postgres
--

ALTER SEQUENCE survey_type_gid_seq OWNED BY survey_type.gid;


SET search_path = taxonomy, pg_catalog;

--
-- TOC entry 218 (class 1259 OID 1853708)
-- Name: dic_attribute_type_gid_seq; Type: SEQUENCE; Schema: taxonomy; Owner: postgres
--

CREATE SEQUENCE dic_attribute_type_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE taxonomy.dic_attribute_type_gid_seq OWNER TO postgres;

--
-- TOC entry 3789 (class 0 OID 0)
-- Dependencies: 218
-- Name: dic_attribute_type_gid_seq; Type: SEQUENCE OWNED BY; Schema: taxonomy; Owner: postgres
--

ALTER SEQUENCE dic_attribute_type_gid_seq OWNED BY dic_attribute_type.gid;


--
-- TOC entry 219 (class 1259 OID 1853710)
-- Name: dic_attribute_value; Type: TABLE; Schema: taxonomy; Owner: postgres; Tablespace: 
--

CREATE TABLE dic_attribute_value (
    gid integer NOT NULL,
    attribute_type_code character varying(254),
    attribute_value character varying(254),
    description character varying(254),
    extended_description character varying(1024)
);


ALTER TABLE taxonomy.dic_attribute_value OWNER TO postgres;

--
-- TOC entry 3790 (class 0 OID 0)
-- Dependencies: 219
-- Name: TABLE dic_attribute_value; Type: COMMENT; Schema: taxonomy; Owner: postgres
--

COMMENT ON TABLE dic_attribute_value IS 'The attribute value dictionary table. Contains information about the attribute values.';


--
-- TOC entry 3791 (class 0 OID 0)
-- Dependencies: 219
-- Name: COLUMN dic_attribute_value.gid; Type: COMMENT; Schema: taxonomy; Owner: postgres
--

COMMENT ON COLUMN dic_attribute_value.gid IS 'Unique attribute value identifier';


--
-- TOC entry 3792 (class 0 OID 0)
-- Dependencies: 219
-- Name: COLUMN dic_attribute_value.attribute_type_code; Type: COMMENT; Schema: taxonomy; Owner: postgres
--

COMMENT ON COLUMN dic_attribute_value.attribute_type_code IS 'Code of the attribute type to which the value refers to';


--
-- TOC entry 3793 (class 0 OID 0)
-- Dependencies: 219
-- Name: COLUMN dic_attribute_value.attribute_value; Type: COMMENT; Schema: taxonomy; Owner: postgres
--

COMMENT ON COLUMN dic_attribute_value.attribute_value IS 'Value of the attribute';


--
-- TOC entry 3794 (class 0 OID 0)
-- Dependencies: 219
-- Name: COLUMN dic_attribute_value.description; Type: COMMENT; Schema: taxonomy; Owner: postgres
--

COMMENT ON COLUMN dic_attribute_value.description IS 'Short textual description of the attribute value';


--
-- TOC entry 3795 (class 0 OID 0)
-- Dependencies: 219
-- Name: COLUMN dic_attribute_value.extended_description; Type: COMMENT; Schema: taxonomy; Owner: postgres
--

COMMENT ON COLUMN dic_attribute_value.extended_description IS 'Extended textual description of the attribute value';


--
-- TOC entry 220 (class 1259 OID 1853716)
-- Name: dic_attribute_value_gid_seq; Type: SEQUENCE; Schema: taxonomy; Owner: postgres
--

CREATE SEQUENCE dic_attribute_value_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE taxonomy.dic_attribute_value_gid_seq OWNER TO postgres;

--
-- TOC entry 3796 (class 0 OID 0)
-- Dependencies: 220
-- Name: dic_attribute_value_gid_seq; Type: SEQUENCE OWNED BY; Schema: taxonomy; Owner: postgres
--

ALTER SEQUENCE dic_attribute_value_gid_seq OWNED BY dic_attribute_value.gid;


--
-- TOC entry 221 (class 1259 OID 1853718)
-- Name: dic_hazard; Type: TABLE; Schema: taxonomy; Owner: postgres; Tablespace: 
--

CREATE TABLE dic_hazard (
    gid integer NOT NULL,
    code character varying(254),
    description character varying(254),
    extended_description character varying(1024),
    attribute_type_code character varying(254)
);


ALTER TABLE taxonomy.dic_hazard OWNER TO postgres;

--
-- TOC entry 3797 (class 0 OID 0)
-- Dependencies: 221
-- Name: TABLE dic_hazard; Type: COMMENT; Schema: taxonomy; Owner: postgres
--

COMMENT ON TABLE dic_hazard IS 'The hazard dictionary table. Contains information about the hazard type to which the taxonomy attribute type is linked to.';


--
-- TOC entry 3798 (class 0 OID 0)
-- Dependencies: 221
-- Name: COLUMN dic_hazard.gid; Type: COMMENT; Schema: taxonomy; Owner: postgres
--

COMMENT ON COLUMN dic_hazard.gid IS 'Unique hazard identifier';


--
-- TOC entry 3799 (class 0 OID 0)
-- Dependencies: 221
-- Name: COLUMN dic_hazard.code; Type: COMMENT; Schema: taxonomy; Owner: postgres
--

COMMENT ON COLUMN dic_hazard.code IS 'Identifier for the hazard type';


--
-- TOC entry 3800 (class 0 OID 0)
-- Dependencies: 221
-- Name: COLUMN dic_hazard.description; Type: COMMENT; Schema: taxonomy; Owner: postgres
--

COMMENT ON COLUMN dic_hazard.description IS 'Short textual description of the hazard type';


--
-- TOC entry 3801 (class 0 OID 0)
-- Dependencies: 221
-- Name: COLUMN dic_hazard.extended_description; Type: COMMENT; Schema: taxonomy; Owner: postgres
--

COMMENT ON COLUMN dic_hazard.extended_description IS 'Extended textual description of the hazard type';


--
-- TOC entry 3802 (class 0 OID 0)
-- Dependencies: 221
-- Name: COLUMN dic_hazard.attribute_type_code; Type: COMMENT; Schema: taxonomy; Owner: postgres
--

COMMENT ON COLUMN dic_hazard.attribute_type_code IS 'Code of the taxonomy attribute type to which the hazard type is linked to';


--
-- TOC entry 222 (class 1259 OID 1853724)
-- Name: dic_hazard_gid_seq; Type: SEQUENCE; Schema: taxonomy; Owner: postgres
--

CREATE SEQUENCE dic_hazard_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE taxonomy.dic_hazard_gid_seq OWNER TO postgres;

--
-- TOC entry 3803 (class 0 OID 0)
-- Dependencies: 222
-- Name: dic_hazard_gid_seq; Type: SEQUENCE OWNED BY; Schema: taxonomy; Owner: postgres
--

ALTER SEQUENCE dic_hazard_gid_seq OWNED BY dic_hazard.gid;


--
-- TOC entry 223 (class 1259 OID 1853726)
-- Name: dic_qualifier_type; Type: TABLE; Schema: taxonomy; Owner: postgres; Tablespace: 
--

CREATE TABLE dic_qualifier_type (
    gid integer NOT NULL,
    code character varying(254),
    description character varying(254),
    extended_description character varying(1024)
);


ALTER TABLE taxonomy.dic_qualifier_type OWNER TO postgres;

--
-- TOC entry 3804 (class 0 OID 0)
-- Dependencies: 223
-- Name: TABLE dic_qualifier_type; Type: COMMENT; Schema: taxonomy; Owner: postgres
--

COMMENT ON TABLE dic_qualifier_type IS 'The qualifier type dictionary table. Contains information about the qualifier types.';


--
-- TOC entry 3805 (class 0 OID 0)
-- Dependencies: 223
-- Name: COLUMN dic_qualifier_type.gid; Type: COMMENT; Schema: taxonomy; Owner: postgres
--

COMMENT ON COLUMN dic_qualifier_type.gid IS 'Unique qualifier type identifier';


--
-- TOC entry 3806 (class 0 OID 0)
-- Dependencies: 223
-- Name: COLUMN dic_qualifier_type.code; Type: COMMENT; Schema: taxonomy; Owner: postgres
--

COMMENT ON COLUMN dic_qualifier_type.code IS 'Code of the qualifier type';


--
-- TOC entry 3807 (class 0 OID 0)
-- Dependencies: 223
-- Name: COLUMN dic_qualifier_type.description; Type: COMMENT; Schema: taxonomy; Owner: postgres
--

COMMENT ON COLUMN dic_qualifier_type.description IS 'Short textual description of the qualifier type';


--
-- TOC entry 3808 (class 0 OID 0)
-- Dependencies: 223
-- Name: COLUMN dic_qualifier_type.extended_description; Type: COMMENT; Schema: taxonomy; Owner: postgres
--

COMMENT ON COLUMN dic_qualifier_type.extended_description IS 'Extended textual description of the qualifier type';


--
-- TOC entry 224 (class 1259 OID 1853732)
-- Name: dic_qualifier_type_gid_seq; Type: SEQUENCE; Schema: taxonomy; Owner: postgres
--

CREATE SEQUENCE dic_qualifier_type_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE taxonomy.dic_qualifier_type_gid_seq OWNER TO postgres;

--
-- TOC entry 3809 (class 0 OID 0)
-- Dependencies: 224
-- Name: dic_qualifier_type_gid_seq; Type: SEQUENCE OWNED BY; Schema: taxonomy; Owner: postgres
--

ALTER SEQUENCE dic_qualifier_type_gid_seq OWNED BY dic_qualifier_type.gid;


--
-- TOC entry 225 (class 1259 OID 1853734)
-- Name: dic_qualifier_value; Type: TABLE; Schema: taxonomy; Owner: postgres; Tablespace: 
--

CREATE TABLE dic_qualifier_value (
    gid integer NOT NULL,
    qualifier_type_code character varying(254),
    qualifier_value character varying(254),
    description character varying(254),
    extended_description character varying(1024)
);


ALTER TABLE taxonomy.dic_qualifier_value OWNER TO postgres;

--
-- TOC entry 3810 (class 0 OID 0)
-- Dependencies: 225
-- Name: TABLE dic_qualifier_value; Type: COMMENT; Schema: taxonomy; Owner: postgres
--

COMMENT ON TABLE dic_qualifier_value IS 'The qualifier value dictionary table. Contains information about the qualifier values.';


--
-- TOC entry 3811 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN dic_qualifier_value.gid; Type: COMMENT; Schema: taxonomy; Owner: postgres
--

COMMENT ON COLUMN dic_qualifier_value.gid IS 'Unique qualifier value identifier';


--
-- TOC entry 3812 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN dic_qualifier_value.qualifier_type_code; Type: COMMENT; Schema: taxonomy; Owner: postgres
--

COMMENT ON COLUMN dic_qualifier_value.qualifier_type_code IS 'Code of the qualifier type to which the value refers to';


--
-- TOC entry 3813 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN dic_qualifier_value.qualifier_value; Type: COMMENT; Schema: taxonomy; Owner: postgres
--

COMMENT ON COLUMN dic_qualifier_value.qualifier_value IS 'Value of the qualifier';


--
-- TOC entry 3814 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN dic_qualifier_value.description; Type: COMMENT; Schema: taxonomy; Owner: postgres
--

COMMENT ON COLUMN dic_qualifier_value.description IS 'Short textual description of the qualifier value';


--
-- TOC entry 3815 (class 0 OID 0)
-- Dependencies: 225
-- Name: COLUMN dic_qualifier_value.extended_description; Type: COMMENT; Schema: taxonomy; Owner: postgres
--

COMMENT ON COLUMN dic_qualifier_value.extended_description IS 'Extended textual description of the qualifier value';


--
-- TOC entry 226 (class 1259 OID 1853740)
-- Name: dic_qualifier_value_gid_seq; Type: SEQUENCE; Schema: taxonomy; Owner: postgres
--

CREATE SEQUENCE dic_qualifier_value_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE taxonomy.dic_qualifier_value_gid_seq OWNER TO postgres;

--
-- TOC entry 3816 (class 0 OID 0)
-- Dependencies: 226
-- Name: dic_qualifier_value_gid_seq; Type: SEQUENCE OWNED BY; Schema: taxonomy; Owner: postgres
--

ALTER SEQUENCE dic_qualifier_value_gid_seq OWNED BY dic_qualifier_value.gid;


--
-- TOC entry 227 (class 1259 OID 1853742)
-- Name: dic_taxonomy; Type: TABLE; Schema: taxonomy; Owner: postgres; Tablespace: 
--

CREATE TABLE dic_taxonomy (
    gid integer NOT NULL,
    code character varying(254),
    description character varying(254),
    extended_description character varying(1024),
    version_date date
);


ALTER TABLE taxonomy.dic_taxonomy OWNER TO postgres;

--
-- TOC entry 3817 (class 0 OID 0)
-- Dependencies: 227
-- Name: TABLE dic_taxonomy; Type: COMMENT; Schema: taxonomy; Owner: postgres
--

COMMENT ON TABLE dic_taxonomy IS 'The taxonomy dictionary table. Contains information about the taxonomy to which the attribute type is linked to.';


--
-- TOC entry 3818 (class 0 OID 0)
-- Dependencies: 227
-- Name: COLUMN dic_taxonomy.gid; Type: COMMENT; Schema: taxonomy; Owner: postgres
--

COMMENT ON COLUMN dic_taxonomy.gid IS 'Unique taxonomy identifier';


--
-- TOC entry 3819 (class 0 OID 0)
-- Dependencies: 227
-- Name: COLUMN dic_taxonomy.code; Type: COMMENT; Schema: taxonomy; Owner: postgres
--

COMMENT ON COLUMN dic_taxonomy.code IS 'Code of the taxonomy';


--
-- TOC entry 3820 (class 0 OID 0)
-- Dependencies: 227
-- Name: COLUMN dic_taxonomy.description; Type: COMMENT; Schema: taxonomy; Owner: postgres
--

COMMENT ON COLUMN dic_taxonomy.description IS 'Short textual description of the taxonomy';


--
-- TOC entry 3821 (class 0 OID 0)
-- Dependencies: 227
-- Name: COLUMN dic_taxonomy.extended_description; Type: COMMENT; Schema: taxonomy; Owner: postgres
--

COMMENT ON COLUMN dic_taxonomy.extended_description IS 'Extended textual description of the taxonomy';


--
-- TOC entry 3822 (class 0 OID 0)
-- Dependencies: 227
-- Name: COLUMN dic_taxonomy.version_date; Type: COMMENT; Schema: taxonomy; Owner: postgres
--

COMMENT ON COLUMN dic_taxonomy.version_date IS 'Version of the taxonomy (date of the version)';


--
-- TOC entry 228 (class 1259 OID 1853748)
-- Name: dic_taxonomy_gid_seq; Type: SEQUENCE; Schema: taxonomy; Owner: postgres
--

CREATE SEQUENCE dic_taxonomy_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE taxonomy.dic_taxonomy_gid_seq OWNER TO postgres;

--
-- TOC entry 3823 (class 0 OID 0)
-- Dependencies: 228
-- Name: dic_taxonomy_gid_seq; Type: SEQUENCE OWNED BY; Schema: taxonomy; Owner: postgres
--

ALTER SEQUENCE dic_taxonomy_gid_seq OWNED BY dic_taxonomy.gid;


SET search_path = asset, pg_catalog;

--
-- TOC entry 3405 (class 2604 OID 1853750)
-- Name: gid; Type: DEFAULT; Schema: asset; Owner: postgres
--

ALTER TABLE ONLY object ALTER COLUMN gid SET DEFAULT nextval('object_gid_seq'::regclass);


--
-- TOC entry 3406 (class 2604 OID 1853751)
-- Name: gid; Type: DEFAULT; Schema: asset; Owner: postgres
--

ALTER TABLE ONLY object_attribute ALTER COLUMN gid SET DEFAULT nextval('object_attribute_gid_seq'::regclass);


--
-- TOC entry 3407 (class 2604 OID 1853752)
-- Name: gid; Type: DEFAULT; Schema: asset; Owner: postgres
--

ALTER TABLE ONLY object_attribute_qualifier ALTER COLUMN gid SET DEFAULT nextval('object_attribute_qualifier_gid_seq'::regclass);


--
-- TOC entry 3409 (class 2604 OID 1853753)
-- Name: mat_type; Type: DEFAULT; Schema: asset; Owner: postgres
--

ALTER TABLE ONLY ve_object ALTER COLUMN mat_type SET DEFAULT 'MAT99'::character varying;


--
-- TOC entry 3410 (class 2604 OID 1853754)
-- Name: mat_tech; Type: DEFAULT; Schema: asset; Owner: postgres
--

ALTER TABLE ONLY ve_object ALTER COLUMN mat_tech SET DEFAULT 'MATT99'::character varying;


--
-- TOC entry 3411 (class 2604 OID 1853755)
-- Name: mat_prop; Type: DEFAULT; Schema: asset; Owner: postgres
--

ALTER TABLE ONLY ve_object ALTER COLUMN mat_prop SET DEFAULT 'MATP99'::character varying;


--
-- TOC entry 3412 (class 2604 OID 1853756)
-- Name: llrs; Type: DEFAULT; Schema: asset; Owner: postgres
--

ALTER TABLE ONLY ve_object ALTER COLUMN llrs SET DEFAULT 'L99'::character varying;


--
-- TOC entry 3413 (class 2604 OID 1853757)
-- Name: llrs_duct; Type: DEFAULT; Schema: asset; Owner: postgres
--

ALTER TABLE ONLY ve_object ALTER COLUMN llrs_duct SET DEFAULT 'DU99'::character varying;


--
-- TOC entry 3414 (class 2604 OID 1853758)
-- Name: height; Type: DEFAULT; Schema: asset; Owner: postgres
--

ALTER TABLE ONLY ve_object ALTER COLUMN height SET DEFAULT 'H99'::character varying;


--
-- TOC entry 3415 (class 2604 OID 1853759)
-- Name: yr_built; Type: DEFAULT; Schema: asset; Owner: postgres
--

ALTER TABLE ONLY ve_object ALTER COLUMN yr_built SET DEFAULT 'Y99'::character varying;


--
-- TOC entry 3416 (class 2604 OID 1853760)
-- Name: occupy; Type: DEFAULT; Schema: asset; Owner: postgres
--

ALTER TABLE ONLY ve_object ALTER COLUMN occupy SET DEFAULT 'OC99'::character varying;


--
-- TOC entry 3417 (class 2604 OID 1853761)
-- Name: occupy_dt; Type: DEFAULT; Schema: asset; Owner: postgres
--

ALTER TABLE ONLY ve_object ALTER COLUMN occupy_dt SET DEFAULT 'OCCDT99'::character varying;


--
-- TOC entry 3418 (class 2604 OID 1853762)
-- Name: position; Type: DEFAULT; Schema: asset; Owner: postgres
--

ALTER TABLE ONLY ve_object ALTER COLUMN "position" SET DEFAULT 'BP99'::character varying;


--
-- TOC entry 3419 (class 2604 OID 1853763)
-- Name: plan_shape; Type: DEFAULT; Schema: asset; Owner: postgres
--

ALTER TABLE ONLY ve_object ALTER COLUMN plan_shape SET DEFAULT 'PLF99'::character varying;


--
-- TOC entry 3420 (class 2604 OID 1853764)
-- Name: str_irreg; Type: DEFAULT; Schema: asset; Owner: postgres
--

ALTER TABLE ONLY ve_object ALTER COLUMN str_irreg SET DEFAULT 'IR99'::character varying;


--
-- TOC entry 3421 (class 2604 OID 1853765)
-- Name: str_irreg_dt; Type: DEFAULT; Schema: asset; Owner: postgres
--

ALTER TABLE ONLY ve_object ALTER COLUMN str_irreg_dt SET DEFAULT 'IRP99'::character varying;


--
-- TOC entry 3422 (class 2604 OID 1853766)
-- Name: str_irreg_type; Type: DEFAULT; Schema: asset; Owner: postgres
--

ALTER TABLE ONLY ve_object ALTER COLUMN str_irreg_type SET DEFAULT 'IRT99'::character varying;


--
-- TOC entry 3423 (class 2604 OID 1853767)
-- Name: nonstrcexw; Type: DEFAULT; Schema: asset; Owner: postgres
--

ALTER TABLE ONLY ve_object ALTER COLUMN nonstrcexw SET DEFAULT 'EW99'::character varying;


--
-- TOC entry 3424 (class 2604 OID 1853768)
-- Name: roof_shape; Type: DEFAULT; Schema: asset; Owner: postgres
--

ALTER TABLE ONLY ve_object ALTER COLUMN roof_shape SET DEFAULT 'R99'::character varying;


--
-- TOC entry 3425 (class 2604 OID 1853769)
-- Name: roofcovmat; Type: DEFAULT; Schema: asset; Owner: postgres
--

ALTER TABLE ONLY ve_object ALTER COLUMN roofcovmat SET DEFAULT 'RMT99'::character varying;


--
-- TOC entry 3426 (class 2604 OID 1853770)
-- Name: roofsysmat; Type: DEFAULT; Schema: asset; Owner: postgres
--

ALTER TABLE ONLY ve_object ALTER COLUMN roofsysmat SET DEFAULT 'RSM99'::character varying;


--
-- TOC entry 3427 (class 2604 OID 1853771)
-- Name: roofsystyp; Type: DEFAULT; Schema: asset; Owner: postgres
--

ALTER TABLE ONLY ve_object ALTER COLUMN roofsystyp SET DEFAULT 'RST99'::character varying;


--
-- TOC entry 3428 (class 2604 OID 1853772)
-- Name: roof_conn; Type: DEFAULT; Schema: asset; Owner: postgres
--

ALTER TABLE ONLY ve_object ALTER COLUMN roof_conn SET DEFAULT 'RCN99'::character varying;


--
-- TOC entry 3429 (class 2604 OID 1853773)
-- Name: floor_mat; Type: DEFAULT; Schema: asset; Owner: postgres
--

ALTER TABLE ONLY ve_object ALTER COLUMN floor_mat SET DEFAULT 'F99'::character varying;


--
-- TOC entry 3430 (class 2604 OID 1853774)
-- Name: floor_type; Type: DEFAULT; Schema: asset; Owner: postgres
--

ALTER TABLE ONLY ve_object ALTER COLUMN floor_type SET DEFAULT 'FT99'::character varying;


--
-- TOC entry 3431 (class 2604 OID 1853775)
-- Name: floor_conn; Type: DEFAULT; Schema: asset; Owner: postgres
--

ALTER TABLE ONLY ve_object ALTER COLUMN floor_conn SET DEFAULT 'FWC99'::character varying;


--
-- TOC entry 3432 (class 2604 OID 1853776)
-- Name: foundn_sys; Type: DEFAULT; Schema: asset; Owner: postgres
--

ALTER TABLE ONLY ve_object ALTER COLUMN foundn_sys SET DEFAULT 'FOS99'::character varying;


SET search_path = history, pg_catalog;

--
-- TOC entry 3433 (class 2604 OID 1853777)
-- Name: gid; Type: DEFAULT; Schema: history; Owner: postgres
--

ALTER TABLE ONLY logged_actions ALTER COLUMN gid SET DEFAULT nextval('logged_actions_gid_seq'::regclass);


SET search_path = image, pg_catalog;

--
-- TOC entry 3442 (class 2604 OID 1853778)
-- Name: gid; Type: DEFAULT; Schema: image; Owner: postgres
--

ALTER TABLE ONLY gpano_metadata ALTER COLUMN gid SET DEFAULT nextval('gpano_metadata_gid_seq'::regclass);


--
-- TOC entry 3443 (class 2604 OID 1853779)
-- Name: gid; Type: DEFAULT; Schema: image; Owner: postgres
--

ALTER TABLE ONLY image_type ALTER COLUMN gid SET DEFAULT nextval('image_type_gid_seq'::regclass);


SET search_path = survey, pg_catalog;

--
-- TOC entry 3444 (class 2604 OID 1853780)
-- Name: gid; Type: DEFAULT; Schema: survey; Owner: postgres
--

ALTER TABLE ONLY survey ALTER COLUMN gid SET DEFAULT nextval('survey_gid_seq'::regclass);


--
-- TOC entry 3445 (class 2604 OID 1853781)
-- Name: gid; Type: DEFAULT; Schema: survey; Owner: postgres
--

ALTER TABLE ONLY survey_type ALTER COLUMN gid SET DEFAULT nextval('survey_type_gid_seq'::regclass);


SET search_path = taxonomy, pg_catalog;

--
-- TOC entry 3408 (class 2604 OID 1853782)
-- Name: gid; Type: DEFAULT; Schema: taxonomy; Owner: postgres
--

ALTER TABLE ONLY dic_attribute_type ALTER COLUMN gid SET DEFAULT nextval('dic_attribute_type_gid_seq'::regclass);


--
-- TOC entry 3446 (class 2604 OID 1853783)
-- Name: gid; Type: DEFAULT; Schema: taxonomy; Owner: postgres
--

ALTER TABLE ONLY dic_attribute_value ALTER COLUMN gid SET DEFAULT nextval('dic_attribute_value_gid_seq'::regclass);


--
-- TOC entry 3447 (class 2604 OID 1853784)
-- Name: gid; Type: DEFAULT; Schema: taxonomy; Owner: postgres
--

ALTER TABLE ONLY dic_hazard ALTER COLUMN gid SET DEFAULT nextval('dic_hazard_gid_seq'::regclass);


--
-- TOC entry 3448 (class 2604 OID 1853785)
-- Name: gid; Type: DEFAULT; Schema: taxonomy; Owner: postgres
--

ALTER TABLE ONLY dic_qualifier_type ALTER COLUMN gid SET DEFAULT nextval('dic_qualifier_type_gid_seq'::regclass);


--
-- TOC entry 3449 (class 2604 OID 1853786)
-- Name: gid; Type: DEFAULT; Schema: taxonomy; Owner: postgres
--

ALTER TABLE ONLY dic_qualifier_value ALTER COLUMN gid SET DEFAULT nextval('dic_qualifier_value_gid_seq'::regclass);


--
-- TOC entry 3450 (class 2604 OID 1853787)
-- Name: gid; Type: DEFAULT; Schema: taxonomy; Owner: postgres
--

ALTER TABLE ONLY dic_taxonomy ALTER COLUMN gid SET DEFAULT nextval('dic_taxonomy_gid_seq'::regclass);


SET search_path = asset, pg_catalog;

--
-- TOC entry 3641 (class 0 OID 1853609)
-- Dependencies: 196
-- Data for Name: object; Type: TABLE DATA; Schema: asset; Owner: postgres
--



--
-- TOC entry 3642 (class 0 OID 1853615)
-- Dependencies: 197
-- Data for Name: object_attribute; Type: TABLE DATA; Schema: asset; Owner: postgres
--



--
-- TOC entry 3824 (class 0 OID 0)
-- Dependencies: 198
-- Name: object_attribute_gid_seq; Type: SEQUENCE SET; Schema: asset; Owner: postgres
--

SELECT pg_catalog.setval('object_attribute_gid_seq', 54000, true);


--
-- TOC entry 3644 (class 0 OID 1853623)
-- Dependencies: 199
-- Data for Name: object_attribute_qualifier; Type: TABLE DATA; Schema: asset; Owner: postgres
--



--
-- TOC entry 3825 (class 0 OID 0)
-- Dependencies: 200
-- Name: object_attribute_qualifier_gid_seq; Type: SEQUENCE SET; Schema: asset; Owner: postgres
--

SELECT pg_catalog.setval('object_attribute_qualifier_gid_seq', 110000, true);


--
-- TOC entry 3826 (class 0 OID 0)
-- Dependencies: 201
-- Name: object_gid_seq; Type: SEQUENCE SET; Schema: asset; Owner: postgres
--

SELECT pg_catalog.setval('object_gid_seq', 2000, true);


SET search_path = history, pg_catalog;

--
-- TOC entry 3648 (class 0 OID 1853654)
-- Dependencies: 206
-- Data for Name: logged_actions; Type: TABLE DATA; Schema: history; Owner: postgres
--



--
-- TOC entry 3827 (class 0 OID 0)
-- Dependencies: 207
-- Name: logged_actions_gid_seq; Type: SEQUENCE SET; Schema: history; Owner: postgres
--

SELECT pg_catalog.setval('logged_actions_gid_seq', 1, false);


SET search_path = image, pg_catalog;

--
-- TOC entry 3650 (class 0 OID 1853663)
-- Dependencies: 208
-- Data for Name: gpano_metadata; Type: TABLE DATA; Schema: image; Owner: postgres
--



--
-- TOC entry 3828 (class 0 OID 0)
-- Dependencies: 209
-- Name: gpano_metadata_gid_seq; Type: SEQUENCE SET; Schema: image; Owner: postgres
--

SELECT pg_catalog.setval('gpano_metadata_gid_seq', 1, false);


--
-- TOC entry 3652 (class 0 OID 1853678)
-- Dependencies: 210
-- Data for Name: gps; Type: TABLE DATA; Schema: image; Owner: postgres
--



--
-- TOC entry 3653 (class 0 OID 1853684)
-- Dependencies: 211
-- Data for Name: image_type; Type: TABLE DATA; Schema: image; Owner: postgres
--

INSERT INTO image_type (gid, code, description) VALUES (2, 'pict', 'generic simple picture');
INSERT INTO image_type (gid, code, description) VALUES (1, 'pano', 'panoramic or omnidirectional image');


--
-- TOC entry 3829 (class 0 OID 0)
-- Dependencies: 212
-- Name: image_type_gid_seq; Type: SEQUENCE SET; Schema: image; Owner: postgres
--

SELECT pg_catalog.setval('image_type_gid_seq', 2, true);


--
-- TOC entry 3655 (class 0 OID 1853689)
-- Dependencies: 213
-- Data for Name: img; Type: TABLE DATA; Schema: image; Owner: postgres
--



SET search_path = survey, pg_catalog;

--
-- TOC entry 3656 (class 0 OID 1853695)
-- Dependencies: 214
-- Data for Name: survey; Type: TABLE DATA; Schema: survey; Owner: postgres
--



--
-- TOC entry 3830 (class 0 OID 0)
-- Dependencies: 215
-- Name: survey_gid_seq; Type: SEQUENCE SET; Schema: survey; Owner: postgres
--

SELECT pg_catalog.setval('survey_gid_seq', 1, false);


--
-- TOC entry 3658 (class 0 OID 1853703)
-- Dependencies: 216
-- Data for Name: survey_type; Type: TABLE DATA; Schema: survey; Owner: postgres
--

INSERT INTO survey_type (gid, code, description) VALUES (1, 'RRVS', 'Remote Rapid Visual Survey');
INSERT INTO survey_type (gid, code, description) VALUES (3, 'OTH', 'Other (unspecified)');
INSERT INTO survey_type (gid, code, description) VALUES (2, 'IDCT', 'Inventory Data Capture Tool');


--
-- TOC entry 3831 (class 0 OID 0)
-- Dependencies: 217
-- Name: survey_type_gid_seq; Type: SEQUENCE SET; Schema: survey; Owner: postgres
--

SELECT pg_catalog.setval('survey_type_gid_seq', 1, false);


SET search_path = taxonomy, pg_catalog;

--
-- TOC entry 3647 (class 0 OID 1853638)
-- Dependencies: 203
-- Data for Name: dic_attribute_type; Type: TABLE DATA; Schema: taxonomy; Owner: postgres
--

INSERT INTO dic_attribute_type (gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order) VALUES (19, 'ROOFSYSTYP', 'Roof System Type', NULL, 'GEM20', 4, NULL);
INSERT INTO dic_attribute_type (gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order) VALUES (20, 'ROOF_CONN', 'Roof Connections', NULL, 'GEM20', 5, NULL);
INSERT INTO dic_attribute_type (gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order) VALUES (1, 'MAT_TYPE', 'Material Type', NULL, 'GEM20', 1, NULL);
INSERT INTO dic_attribute_type (gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order) VALUES (2, 'MAT_TECH', 'Material Technology', NULL, 'GEM20', 2, NULL);
INSERT INTO dic_attribute_type (gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order) VALUES (3, 'MAT_PROP', 'Material Property', NULL, 'GEM20', 3, NULL);
INSERT INTO dic_attribute_type (gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order) VALUES (21, 'FLOOR_MAT', 'Floor Material', NULL, 'GEM20', 1, NULL);
INSERT INTO dic_attribute_type (gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order) VALUES (4, 'LLRS', 'Type of Lateral Load-Resisting System', NULL, 'GEM20', 1, NULL);
INSERT INTO dic_attribute_type (gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order) VALUES (5, 'LLRS_DUCT', 'System Ductility', NULL, 'GEM20', 2, NULL);
INSERT INTO dic_attribute_type (gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order) VALUES (22, 'FLOOR_TYPE', 'Floor System Type', NULL, 'GEM20', 2, NULL);
INSERT INTO dic_attribute_type (gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order) VALUES (6, 'HEIGHT', 'Height', NULL, 'GEM20', 1, NULL);
INSERT INTO dic_attribute_type (gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order) VALUES (23, 'FLOOR_CONN', 'Floor Connections', NULL, 'GEM20', 3, NULL);
INSERT INTO dic_attribute_type (gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order) VALUES (7, 'YR_BUILT', 'Date of Construction or Retrofit', NULL, 'GEM20', 1, NULL);
INSERT INTO dic_attribute_type (gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order) VALUES (24, 'FOUNDN_SYS', 'Foundation System', NULL, 'GEM20', 1, NULL);
INSERT INTO dic_attribute_type (gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order) VALUES (8, 'OCCUPY', 'Building Occupancy Class - General', NULL, 'GEM20', 1, NULL);
INSERT INTO dic_attribute_type (gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order) VALUES (9, 'OCCUPY_DT', 'Building Occupancy Class - Detail', NULL, 'GEM20', 2, NULL);
INSERT INTO dic_attribute_type (gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order) VALUES (10, 'POSITION', 'Building Position within a Block', NULL, 'GEM20', 1, NULL);
INSERT INTO dic_attribute_type (gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order) VALUES (11, 'PLAN_SHAPE', 'Shape of the Building Plan', NULL, 'GEM20', 1, NULL);
INSERT INTO dic_attribute_type (gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order) VALUES (12, 'STR_IRREG', 'Regular or Irregular', NULL, 'GEM20', 1, NULL);
INSERT INTO dic_attribute_type (gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order) VALUES (13, 'STR_IRREG_DT', 'Plan Irregularity or Vertical Irregularity', NULL, 'GEM20', 2, NULL);
INSERT INTO dic_attribute_type (gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order) VALUES (14, 'STR_IRREG_TYPE', 'Type of Irregularity', NULL, 'GEM20', 3, NULL);
INSERT INTO dic_attribute_type (gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order) VALUES (15, 'NONSTRCEXW', 'Exterior walls', NULL, 'GEM20', 1, NULL);
INSERT INTO dic_attribute_type (gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order) VALUES (16, 'ROOF_SHAPE', 'Roof Shape', NULL, 'GEM20', 1, NULL);
INSERT INTO dic_attribute_type (gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order) VALUES (17, 'ROOFCOVMAT', 'Roof Covering', NULL, 'GEM20', 2, NULL);
INSERT INTO dic_attribute_type (gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order) VALUES (18, 'ROOFSYSMAT', 'Roof System Material', NULL, 'GEM20', 3, NULL);
INSERT INTO dic_attribute_type (gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order) VALUES (25, 'BUILD_TYPE', 'Building Type', NULL, 'EMCA', 1, NULL);
INSERT INTO dic_attribute_type (gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order) VALUES (26, 'BUILD_SUBTYPE', 'Building Subtype', NULL, 'EMCA', 2, NULL);
INSERT INTO dic_attribute_type (gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order) VALUES (27, 'VULN', 'Structural Vulnerability Class', NULL, 'EMS98', 1, NULL);


--
-- TOC entry 3832 (class 0 OID 0)
-- Dependencies: 218
-- Name: dic_attribute_type_gid_seq; Type: SEQUENCE SET; Schema: taxonomy; Owner: postgres
--

SELECT pg_catalog.setval('dic_attribute_type_gid_seq', 1, false);


--
-- TOC entry 3661 (class 0 OID 1853710)
-- Dependencies: 219
-- Data for Name: dic_attribute_value; Type: TABLE DATA; Schema: taxonomy; Owner: postgres
--

INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (92, 'LLRS', 'LH', 'LH - Hybrid lateral load-resisting system', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (93, 'LLRS', 'LO', 'LO - Other lateral load-resisting system', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (94, 'LLRS_DUCT', 'DU99', 'DU99 - Ductility unknown', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (95, 'LLRS_DUCT', 'DUC', 'DUC - Ductile', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (96, 'LLRS_DUCT', 'DNO', 'DNO - Non-ductile', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (97, 'LLRS_DUCT', 'DBD', 'DBD - Equipped with base isolation and/or energy dissipation devices', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (1, 'MAT_TYPE', 'MAT99', 'MAT99 - Unknown material', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (2, 'MAT_TYPE', 'C99', 'C99 - Concrete, unknown reinforcement', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (3, 'MAT_TYPE', 'CU', 'CU - Concrete, unreinforced', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (4, 'MAT_TYPE', 'CR', 'CR - Concrete, reinforced', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (5, 'MAT_TYPE', 'SRC', 'SRC - Concrete, composite with steel section', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (6, 'MAT_TYPE', 'S', 'S - Steel', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (7, 'MAT_TYPE', 'ME', 'ME - Metal (except steel)', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (8, 'MAT_TYPE', 'M99', 'M99 - Masonry, unknown reinforcement', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (9, 'MAT_TYPE', 'MUR', 'MUR - Masonry, unreinforced', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (10, 'MAT_TYPE', 'MCF', 'MCF - Masonry, confined', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (11, 'MAT_TYPE', 'MR', 'MR - Masonry, reinforced', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (12, 'MAT_TYPE', 'E99', 'E99 - Earth, unknown reinforcement', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (13, 'MAT_TYPE', 'EU', 'EU - Earth, unreinforced', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (14, 'MAT_TYPE', 'ER', 'ER - Earth, reinforced', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (15, 'MAT_TYPE', 'W', 'W - Wood', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (32, 'MAT_TECH', 'STRUB', 'STRUB - Rubble (field stone) or semi-dressed stone', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (16, 'MAT_TYPE', 'MATO', 'MATO - Other material', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (31, 'MAT_TECH', 'ST99', 'ST99 - Stone, unknown technology', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (30, 'MAT_TECH', 'ADO', 'ADO - Adobe blocks', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (29, 'MAT_TECH', 'MUN99', 'MUN99 - Masonry unit, unknown', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (33, 'MAT_TECH', 'STDRE', 'STDRE - Dressed stone', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (34, 'MAT_TECH', 'CL99', 'CL99 - Fired clay unit, unknown type', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (35, 'MAT_TECH', 'CLBRS', 'CLBRS - Fired clay solid bricks', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (36, 'MAT_TECH', 'CLBRH', 'CLBRH - Fired clay hollow bricks', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (37, 'MAT_TECH', 'CLBLH', 'CLBLH - Fired clay hollow blocks or tiles', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (38, 'MAT_TECH', 'CB99', 'CB99 - Concrete blocks, unknown type', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (98, 'HEIGHT', 'H99', 'H99 - Number of storeys unknown', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (17, 'MAT_TECH', 'CT99', 'CT99 - Unknown concrete technology', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (18, 'MAT_TECH', 'CIP', 'CIP - Cast-in-place concrete', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (19, 'MAT_TECH', 'PC', 'PC - Precast concrete', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (20, 'MAT_TECH', 'CIPPS', 'CIPPS - Cast-in-place prestressed concrete', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (21, 'MAT_TECH', 'PCPS', 'PCPS - Precast prestressed concrete', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (22, 'MAT_TECH', 'S99', 'S99 - Steel, unknown', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (23, 'MAT_TECH', 'SL', 'SL - Cold-formed steel members', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (24, 'MAT_TECH', 'SR', 'SR - Hot-rolled steel members', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (25, 'MAT_TECH', 'SO', 'SO - Steel, other', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (26, 'MAT_TECH', 'ME99', 'ME99 - Metal, unknown', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (27, 'MAT_TECH', 'MEIR', 'MEIR - Iron', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (28, 'MAT_TECH', 'MEO', 'MEO - Metal, other', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (39, 'MAT_TECH', 'CBS', 'CBS - Concrete blocks, solid', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (40, 'MAT_TECH', 'CBH', 'CBH - Concrete blocks, hollow', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (41, 'MAT_TECH', 'MO', 'MO - Masonry unit, other', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (42, 'MAT_TECH', 'MR99', 'MR99 - Masonry reinforcement, unknown', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (43, 'MAT_TECH', 'RS', 'RS - Steel reinforced', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (99, 'HEIGHT', 'H', 'H - Number of storeys above ground', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (44, 'MAT_TECH', 'RW', 'RW - Wood-reinforced', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (45, 'MAT_TECH', 'RB', 'RB - Bamboo-, cane- or rope-reinforcement', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (46, 'MAT_TECH', 'RCM', 'RCM - Fibre reinforcing mesh', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (100, 'HEIGHT', 'HB', 'HB - Number of storeys below ground', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (47, 'MAT_TECH', 'RCB', 'RCB - Reinforced concrete bands', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (48, 'MAT_TECH', 'ET99', 'ET99 - Unknown earth technology', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (49, 'MAT_TECH', 'ETR', 'ETR - Rammed earth', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (101, 'HEIGHT', 'HF', 'HF - Height of ground floor level above grade', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (50, 'MAT_TECH', 'ETC', 'ETC - Cob or wet construction', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (51, 'MAT_TECH', 'ETO', 'ETO - Earth technology, other', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (52, 'MAT_TECH', 'W99', 'W99 - Wood, unknown', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (53, 'MAT_TECH', 'WHE', 'WHE - Heavy wood', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (54, 'MAT_TECH', 'WLI', 'WLI - Light wood members', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (55, 'MAT_TECH', 'WS', 'WS - Solid wood', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (56, 'MAT_TECH', 'WWD', 'WWD - Wattle and daub', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (57, 'MAT_TECH', 'WBB', 'WBB - Bamboo', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (58, 'MAT_TECH', 'WO', 'WO - Wood, other', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (103, 'YR_BUILT', 'Y99', 'Y99 - Year unknown', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (104, 'YR_BUILT', 'YEX', 'YEX - Exact  date of construction or retrofit', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (106, 'YR_BUILT', 'YPRE', 'YPRE - Latest possible date of construction or retrofit', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (60, 'MAT_PROP', 'SC99', 'SC99 - Steel connections, unknown', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (62, 'MAT_PROP', 'WEL', 'WEL - Welded connections', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (63, 'MAT_PROP', 'RIV', 'RIV - Riveted connections', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (64, 'MAT_PROP', 'BOL', 'BOL - Bolted connections', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (65, 'MAT_PROP', 'MO99', 'MO99 - Mortar type unknown', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (66, 'MAT_PROP', 'MON', 'MON - No mortar', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (67, 'MAT_PROP', 'MOM', 'MOM - Mud mortar', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (68, 'MAT_PROP', 'MOL', 'MOL - Lime mortar', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (69, 'MAT_PROP', 'MOC', 'MOC - Cement mortar', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (70, 'MAT_PROP', 'MOCL', 'MOCL - Cement: lime mortar', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (71, 'MAT_PROP', 'SP99', 'SP99 - Stone, unknown type', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (109, 'OCCUPY', 'RES', 'RES - Residential', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (72, 'MAT_PROP', 'SPLI', 'SPLI - Limestone', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (73, 'MAT_PROP', 'SPSA', 'SPSA - Sandstone', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (74, 'MAT_PROP', 'SPTU', 'SPTU - Tuff', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (75, 'MAT_PROP', 'SPSL', 'SPSL - Slate', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (76, 'MAT_PROP', 'SPGR', 'SPGR - Granite', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (77, 'MAT_PROP', 'SPBA', 'SPBA - Basalt', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (78, 'MAT_PROP', 'SPO', 'SPO - Stone, other type', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (80, 'MAT_TECH', 'MATT99', 'MATT99 - Unknown material technology', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (81, 'MAT_PROP', 'MATP99', 'MATP99 - Unknown material property', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (84, 'LLRS', 'LFM', 'LFM - Moment frame', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (82, 'LLRS', 'L99', 'L99 - Unknown lateral load-resisting system', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (83, 'LLRS', 'LN', 'LN - No lateral load-resisting system', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (85, 'LLRS', 'LFINF', 'LFINF - Infilled frame', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (86, 'LLRS', 'LFBR', 'LFBR - Braced frame', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (87, 'LLRS', 'LPB', 'LPN - Post and beam', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (88, 'LLRS', 'LWAL', 'LWAL - Wall', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (89, 'LLRS', 'LDUAL', 'LDUAL - Dual frame-wall system', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (90, 'LLRS', 'LFLS', 'LFLS - Flat slab/plate or infilled waffle slab', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (91, 'LLRS', 'LFLSINF', 'LFLSINF - Infilled flat slab/plate or infilled waffle slab', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (105, 'YR_BUILT', 'YBET', 'YBET - Upper and lower bound for the date of construction or retrofit', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (107, 'YR_BUILT', 'YAPP', 'YAPP - Approximate date of construction or retrofit', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (235, 'ROOFCOVMAT', 'RMT99', 'RMT99 - Unknown roof covering', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (147, 'OCCUPY_DT', 'MIX4', 'MIX4 - Mostly residential and industrial', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (148, 'OCCUPY_DT', 'MIX5', 'MIX5 - Mostly industrial and commercial', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (149, 'OCCUPY_DT', 'MIX6', 'MIX6 - Mostly industrial and residential', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (150, 'OCCUPY_DT', 'IND99', 'IND99 - Industiral, unknown type', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (236, 'ROOFCOVMAT', 'RMN', 'RMN - Concrete rood without additional covering', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (151, 'OCCUPY_DT', 'IND1', 'IND1 - Heavy industrial', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (152, 'OCCUPY_DT', 'IND2', 'IND2 - Light industrial', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (153, 'OCCUPY_DT', 'AGR99', 'AGR99 - Agriculture, unknown type', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (154, 'OCCUPY_DT', 'AGR1', 'AGR1 - Produce storage', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (155, 'OCCUPY_DT', 'AGR2', 'AGR2 - Animal shelter', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (156, 'OCCUPY_DT', 'AGR3', 'AGR3 - Agricultural processing', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (157, 'OCCUPY_DT', 'ASS99', 'ASS99 - Assembly, unknown type', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (158, 'OCCUPY_DT', 'ASS1', 'ASS1 - Religious gathering', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (159, 'OCCUPY_DT', 'ASS2', 'ASS2 - Arena', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (160, 'OCCUPY_DT', 'ASS3', 'ASS3 - Cinema or concert hall', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (161, 'OCCUPY_DT', 'ASS4', 'ASS4 - Other gatherings', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (162, 'OCCUPY_DT', 'GOV99', 'GOV99 - Government, unknown type', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (163, 'OCCUPY_DT', 'GOV1', 'GOV1 - Government, general services', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (164, 'OCCUPY_DT', 'GOV2', 'GOV2 - Government, emergency services', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (165, 'OCCUPY_DT', 'EDU99', 'EDU99 - Education, unknown type', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (166, 'OCCUPY_DT', 'EDU1', 'EDU1 - Pre-school facility', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (167, 'OCCUPY_DT', 'EDU2', 'EDU2 - School', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (196, 'STR_IRREG', 'IRIR', 'IRIR - Irregular structure', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (170, 'POSITION', 'BPD', 'BPD - Detached building', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (171, 'POSITION', 'BP1', 'BP1 - Adjoining building(s) on one side', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (197, 'STR_IRREG_DT', 'IRPP', 'IRPP - Plan irregularity - primary', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (172, 'POSITION', 'BP2', 'BP2 - Adjoining building(s) on two sides', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (173, 'POSITION', 'BP3', 'BP3 - Adjoining building(s) on three sides', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (198, 'STR_IRREG_DT', 'IRPS', 'IRPS - Plan irregularity - secondary', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (199, 'STR_IRREG_DT', 'IRVP', 'IRVP - Vertical irregularity - primary', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (200, 'STR_IRREG_DT', 'IRVS', 'IRVS - Vertical irregularity - secondary', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (201, 'STR_IRREG_TYPE', 'IRN', 'INR - No irregularity', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (202, 'STR_IRREG_TYPE', 'TOR', 'TOR - Torsion eccentricity', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (203, 'STR_IRREG_TYPE', 'REC', 'REC - Re-entrant corner', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (204, 'STR_IRREG_TYPE', 'IRHO', 'IRHO - Other plan irregularity', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (237, 'ROOFCOVMAT', 'RMT1', 'RMT1 - Clay or concrete tile roof covering', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (205, 'STR_IRREG_TYPE', 'SOS', 'SOS - Soft storey', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (206, 'STR_IRREG_TYPE', 'CRW', 'CRW - Cripple wall', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (207, 'STR_IRREG_TYPE', 'SHC', 'SHC - Short column', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (208, 'STR_IRREG_TYPE', 'POP', 'POP - Pounding potential', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (209, 'STR_IRREG_TYPE', 'SET', 'SET - Setback', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (210, 'STR_IRREG_TYPE', 'CHV', 'CHV - Change in vertical structure (includes large overhangs)', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (211, 'STR_IRREG_TYPE', 'IRVO', 'IRVO - Other vertical irregularity', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (238, 'ROOFCOVMAT', 'RMT2', 'RMT2 - Fibre cement or metal tile roof covering', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (239, 'ROOFCOVMAT', 'RMT3', 'RMT3 - Membrane roof covering', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (240, 'ROOFCOVMAT', 'RMT4', 'RMT4 - Slate roof covering', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (212, 'NONSTRCEXW', 'EW99', 'EW99 - Unknown material of exterior walls', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (213, 'NONSTRCEXW', 'EWC', 'EWC - Concrete exterior walls', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (214, 'NONSTRCEXW', 'EWG', 'EWG - Glass exterior walls', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (215, 'NONSTRCEXW', 'EWE', 'EWE - Earthen exterior walls', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (216, 'NONSTRCEXW', 'EWMA', 'EWMA - Masonry exterior walls', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (241, 'ROOFCOVMAT', 'RMT5', 'RMT5 - Stone slab roof covering', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (242, 'ROOFCOVMAT', 'RMT6', 'RMT6 - Metal or asbestos sheet roof covering', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (243, 'ROOFCOVMAT', 'RMT7', 'RMT7 - Wooden or asphalt shingle roof covering', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (244, 'ROOFCOVMAT', 'RMT8', 'RMT8 - Vegetative roof covering', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (245, 'ROOFCOVMAT', 'RMT9', 'RMT9 - Earthen roof covering', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (228, 'ROOF_SHAPE', 'RSH4', 'RSH4 - Pitched with dormers', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (229, 'ROOF_SHAPE', 'RSH5', 'RSH5 - Monopitch', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (230, 'ROOF_SHAPE', 'RSH6', 'RSH6 - Sawtooth', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (231, 'ROOF_SHAPE', 'RSH7', 'RSH7 - Curved', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (232, 'ROOF_SHAPE', 'RSH8', 'RSH8 - Complex regular', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (233, 'ROOF_SHAPE', 'RSH9', 'RSH9 - Complex irregular', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (234, 'ROOF_SHAPE', 'RSHO', 'RSHO - Roof shape, other', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (246, 'ROOFCOVMAT', 'RMT10', 'RMT10 - Solar panelled roofs', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (247, 'ROOFCOVMAT', 'RMT11', 'RMT11 - Tensile membrane or fabric roof', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (248, 'ROOFCOVMAT', 'RMTO', 'RMTO - Roof covering, other', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (249, 'ROOFSYSMAT', 'RM', 'RM - Masonry roof', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (250, 'ROOFSYSMAT', 'RE', 'RE - Earthen roof', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (251, 'ROOFSYSMAT', 'RC', 'RC - Concrete roof', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (252, 'ROOFSYSMAT', 'RME', 'RME - Metal roof', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (253, 'ROOFSYSMAT', 'RWO', 'RWO - Wooden roof', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (254, 'ROOFSYSMAT', 'RFA', 'RFA - Fabric roof', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (255, 'ROOFSYSMAT', 'RO', 'RO - Roof material, other', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (256, 'ROOFSYSTYP', 'RM99', 'RM99 - Masonry roof, unknown', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (257, 'ROOFSYSTYP', 'RM1', 'RM1 - Vaulted masonry roof', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (258, 'ROOFSYSTYP', 'RM2', 'RM2 - Shallow-arched masonry roof', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (259, 'ROOFSYSTYP', 'RM3', 'RM3 - Composite masonry and concrete roof system', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (260, 'ROOFSYSTYP', 'RE99', 'RE99 - Earthen roof, unknown', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (261, 'ROOFSYSTYP', 'RE1', 'RE1 - Vaulted earthen roof, unknown', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (281, 'ROOF_CONN', 'RWCP', 'RWCP - Roof-wall diaphragm connection present', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (283, 'ROOF_CONN', 'RTDN', 'RTDN - Roof tie-down not provided', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (282, 'ROOF_CONN', 'RTD99', 'RTD99 - Roof tie-down unknown', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (284, 'ROOF_CONN', 'RTDP', 'RTDP - Roof tie-down present', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (285, 'FLOOR_MAT', 'FN', 'FN - No elevated or suspended floor', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (286, 'FLOOR_MAT', 'F99', 'F99 - Floor material, unknown', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (288, 'FLOOR_MAT', 'FE', 'FE - Earthen floor', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (290, 'FLOOR_MAT', 'FME', 'FME - Metal floor', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (294, 'FLOOR_TYPE', 'FM1', 'FM1 - Vaulted masonry floor', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (297, 'FLOOR_TYPE', 'FE99', 'FE99 - Earthen floor, unknown', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (298, 'FLOOR_TYPE', 'FC99', 'FC99 - Concrete floor, unknown', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (134, 'OCCUPY_DT', 'COM3', 'COM3 - Offices, professional/technical services', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (135, 'OCCUPY_DT', 'COM4', 'COM4 - Hospital/medical clinic', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (136, 'OCCUPY_DT', 'COM5', 'COM5 - Entertainment', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (137, 'OCCUPY_DT', 'COM6', 'COM6 - Public building', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (138, 'OCCUPY_DT', 'COM7', 'COM7 - Covered parking garage', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (139, 'OCCUPY_DT', 'COM8', 'COM8 - Bus station', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (108, 'OCCUPY', 'OC99', 'OC99 - Unknown occupancy', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (110, 'OCCUPY', 'COM', 'COM - Commercial and public', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (111, 'OCCUPY', 'MIX', 'MIX - Mixed use', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (112, 'OCCUPY', 'IND', 'IND - Industrial', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (113, 'OCCUPY', 'AGR', 'AGR - Agriculture', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (114, 'OCCUPY', 'ASS', 'ASS - Assembly', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (115, 'OCCUPY', 'GOV', 'GOV - Government', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (116, 'OCCUPY', 'EDU', 'EDU - Education', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (117, 'OCCUPY', 'OCO', 'OCO - Other occupancy type', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (140, 'OCCUPY_DT', 'COM9', 'COM9 - Railway station', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (141, 'OCCUPY_DT', 'COM10', 'COM10 - Airport', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (142, 'OCCUPY_DT', 'COM11', 'COM11 - Recreation and leisure', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (143, 'OCCUPY_DT', 'MIX99', 'MIX99 - Mixed, unknown type', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (144, 'OCCUPY_DT', 'MIX1', 'MIX1 - Mostly residential and commercial', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (145, 'OCCUPY_DT', 'MIX2', 'MIX2 - Mostly commercial and residential', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (146, 'OCCUPY_DT', 'MIX3', 'MIX3 - Mostly commercial and industrial', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (176, 'PLAN_SHAPE', 'PLFSQO', 'PLFSQO - Square, with an opening in plan', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (177, 'PLAN_SHAPE', 'PLFR', 'PLFR - Rectangular, solid', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (178, 'PLAN_SHAPE', 'PLFRO', 'PLFRO - Rectangular, with an opening in plan', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (179, 'PLAN_SHAPE', 'PLFL', 'PLFL - L-shape', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (180, 'PLAN_SHAPE', 'PLFC', 'PLFC - Curved, solid', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (181, 'PLAN_SHAPE', 'PLFCO', 'PLFCO - Curved, with an opening in plan', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (182, 'PLAN_SHAPE', 'PLFD', 'PLFD - Triangular, solid', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (118, 'OCCUPY_DT', 'RES99', 'RES99 - Residential, unknown type', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (119, 'OCCUPY_DT', 'RES1', 'RES1 - Single dwelling', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (120, 'OCCUPY_DT', 'RES2', 'RES2 - Multi-unit, unknown type', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (121, 'OCCUPY_DT', 'RES2A', 'RES2A - 2 Units (duplex)', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (122, 'OCCUPY_DT', 'RES2B', 'RES2B - 3-4 Units', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (123, 'OCCUPY_DT', 'RES2C', 'RES2C - 5-9 Units', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (124, 'OCCUPY_DT', 'RES2D', 'RES2D - 10-19 Units', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (168, 'OCCUPY_DT', 'EDU3', 'EDU3 - College/university offices and/or classrooms', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (125, 'OCCUPY_DT', 'RES2E', 'RES2E - 20-49 Units', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (126, 'OCCUPY_DT', 'RES2F', 'RES2F - 50+ Units', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (127, 'OCCUPY_DT', 'RES3', 'RES3 - Temporary lodging', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (128, 'OCCUPY_DT', 'RES4', 'RES4 - Institutional housing', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (129, 'OCCUPY_DT', 'RES5', 'RES5 - Mobile home', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (130, 'OCCUPY_DT', 'RES6', 'RES6 - Informal housing', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (131, 'OCCUPY_DT', 'COM99', 'COM99 - Commercial and public, unknown type', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (132, 'OCCUPY_DT', 'COM1', 'COM1 - Retail trade', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (133, 'OCCUPY_DT', 'COM2', 'COM2 - Wholesale trade and storage (warehouse)', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (169, 'OCCUPY_DT', 'EDU4', 'EDU4 - College/university research facilities and/or labs', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (183, 'PLAN_SHAPE', 'PLFDO', 'PLFDO - Triangular, with an opening in plan', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (184, 'PLAN_SHAPE', 'PLFP', 'PLFP - Polygonal, solid (e.g. trapezoid, pentagon, hexagon)', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (262, 'ROOFSYSTYP', 'RC99', 'RC99 - Concrete roof, unknown', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (263, 'ROOFSYSTYP', 'RC1', 'RC1 - Cast-in-place beamless reinforced concrete roof', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (174, 'PLAN_SHAPE', 'PLF99', 'PLF99 - Unknown plan shape', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (175, 'PLAN_SHAPE', 'PLFSQ', 'PLFSQ - Square, solid', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (185, 'PLAN_SHAPE', 'PLFPO', 'PLFPO - Polygonal, with an opening in plan', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (217, 'NONSTRCEXW', 'EWME', 'EWME - Metal exterior walls', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (186, 'PLAN_SHAPE', 'PLFE', 'PLFE - E-shape', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (187, 'PLAN_SHAPE', 'PLFH', 'PLFH - H-shape', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (188, 'PLAN_SHAPE', 'PLFS', 'PLFS - S-shape', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (189, 'PLAN_SHAPE', 'PLFT', 'PLFT - T-shape', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (190, 'PLAN_SHAPE', 'PLFU', 'PLFU - U- or C-shape', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (191, 'PLAN_SHAPE', 'PLFX', 'PLFX - X-shape', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (192, 'PLAN_SHAPE', 'PLFY', 'PLFY - Y-shape', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (193, 'PLAN_SHAPE', 'PLFI', 'PLFI - Irregular plan shape', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (264, 'ROOFSYSTYP', 'RC2', 'RC2 - Cast-in-place beam-supported reinforced concrete roof', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (265, 'ROOFSYSTYP', 'RC3', 'RC3 - Precast concrete roof with reinforced concrete topping', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (194, 'STR_IRREG', 'IR99', 'IR99 - Unknown structural irregularity', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (195, 'STR_IRREG', 'IRRE', 'IRRE - Regular structure', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (266, 'ROOFSYSTYP', 'RC4', 'RC4 - Precast concrete roof without reinforced concrete topping', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (267, 'ROOFSYSTYP', 'RME99', 'RME99 - Metal roof, unknown', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (268, 'ROOFSYSTYP', 'RME1', 'RME1 - Metal beams or trusses supporting light roofing', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (269, 'ROOFSYSTYP', 'RME2', 'RME2 - Metal roof beams supporting precast concrete slabs', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (270, 'ROOFSYSTYP', 'RME3', 'RME3 - Composite steel roof deck and concrete slab', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (271, 'ROOFSYSTYP', 'RWO99', 'RWO99 - Wooden roof, unknown', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (218, 'NONSTRCEXW', 'EWV', 'EWV - Vegetative exterior walls', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (219, 'NONSTRCEXW', 'EWW', 'EWW - Wooden exterior walls', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (220, 'NONSTRCEXW', 'EWSL', 'EWSL - Stucco finish on light framing for exterior walls', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (221, 'NONSTRCEXW', 'EWPL', 'EWPL - Plastic/vinyl exterior walls, various', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (222, 'NONSTRCEXW', 'EWCB', 'EWCB - Cement-based boards for exterior walls', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (223, 'NONSTRCEXW', 'EWO', 'EWO - Material of exterior walls, other', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (272, 'ROOFSYSTYP', 'RWO1', 'RWO1 - Wooden structure with roof covering', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (273, 'ROOFSYSTYP', 'RWO2', 'RWO2 - Wooden beams or trusses with heavy roof covering', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (274, 'ROOFSYSTYP', 'RWO3', 'RWO3 - Wood-based sheets on rafters or purlins', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (224, 'ROOF_SHAPE', 'R99', 'R99 - Unknown roof shape', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (225, 'ROOF_SHAPE', 'RSH1', 'RSH1 - Flat', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (226, 'ROOF_SHAPE', 'RSH2', 'RSH2 - Pitched with gable ends', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (227, 'ROOF_SHAPE', 'RSH3', 'RSH3 - Pitched and hipped', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (275, 'ROOFSYSTYP', 'RWO4', 'RWO4 - Plywood panels or other light-weight panels for roof', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (276, 'ROOFSYSTYP', 'RWO5', 'RWO5 - Bamboo, straw or thatch roof', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (277, 'ROOFSYSTYP', 'RFA1', 'RFA1 - Inflatable or tensile membrane roof', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (278, 'ROOFSYSTYP', 'RFAO', 'RFAO - Fabric roof, other', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (279, 'ROOF_CONN', 'RWC99', 'RWC99 - Roof-wall diaphragm connection unknown', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (280, 'ROOF_CONN', 'RWCN', 'RWCN - Roof-wall diaphragm connection not provided', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (287, 'FLOOR_MAT', 'FM', 'FM - Masonry floor', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (289, 'FLOOR_MAT', 'FC', 'FC - Concrete floor', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (291, 'FLOOR_MAT', 'FW', 'FW - Wooden floor', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (292, 'FLOOR_MAT', 'FO', 'FO - Floor material, other', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (304, 'FLOOR_TYPE', 'FME1', 'FME1 - Metal beams, trusses or joists supporting light flooring', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (305, 'FLOOR_TYPE', 'FME2', 'FME2 - Metal floor beams supporting precast concrete slabs', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (306, 'FLOOR_TYPE', 'FME3', 'FME3 - Composite steel deck and concrete slab', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (293, 'FLOOR_TYPE', 'FM99', 'FM99 - Masonry floor, unknown', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (295, 'FLOOR_TYPE', 'FM2', 'FM2 - Shallow-arched masonry floor', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (296, 'FLOOR_TYPE', 'FM3', 'FM3 - Composite cast-in-place reinforced concrete and masonry floor system', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (299, 'FLOOR_TYPE', 'FC1', 'FC1 - Cast-in-place beamless reinforced concrete floor', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (300, 'FLOOR_TYPE', 'FC2', 'FC2 - Cast-in-place beam-supported reinforced concrete floor', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (301, 'FLOOR_TYPE', 'FC3', 'FC3 - Precast concrete flor with reinforced concrete topping', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (302, 'FLOOR_TYPE', 'FC4', 'FC4 - Precast concrete floor without reinforced concrete topping', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (303, 'FLOOR_TYPE', 'FME99', 'FME99 - Metal floor, unknown', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (307, 'FLOOR_TYPE', 'FW99', 'FW99 - Wooden floor, unknown', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (308, 'FLOOR_TYPE', 'FW1', 'FW1 - Wooden beams or trusses and joists supporting light flooring', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (309, 'FLOOR_TYPE', 'FW2', 'FW2 - Wooden beams or trusses and joists supporting heavy flooring', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (310, 'FLOOR_TYPE', 'FW3', 'FW3 - Wood-based sheets on joists or beams', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (311, 'FLOOR_TYPE', 'FW4', 'FW4 - Plywood panels or other light-weight panels for floor', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (312, 'FLOOR_CONN', 'FWC99', 'FWC99 - Floor-wall diaphragm connection unknown', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (313, 'FLOOR_CONN', 'FWCN', 'FWCN - Floor-wall diaphragm connection not provided', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (314, 'FLOOR_CONN', 'FWCP', 'FWCP - Floor-wall diaphragm connection present', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (315, 'FOUNDN_SYS', 'FOS99', 'FOS99 - Unknown foundation system', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (316, 'FOUNDN_SYS', 'FOSSL', 'FOSSL - Shallow foundation, with lateral capacity', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (317, 'FOUNDN_SYS', 'FOSN', 'FOSN - Shallow foundation, no lateral capacity', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (318, 'FOUNDN_SYS', 'FOSDL', 'FOSDL - Deep foundation, with lateral capacity', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (319, 'FOUNDN_SYS', 'FOSDN', 'FOSDN - Deep foundation, no lateral capacity', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (320, 'FOUNDN_SYS', 'FOSO', 'FOSO - Foundation, other', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (321, 'OCCUPY_DT', 'OCCDT99', 'OCCDT99 - Occupancy detail, unknown', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (322, 'POSITION', 'BP99', 'BP99 - Position, unknown', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (324, 'STR_IRREG_TYPE', 'IRT99', 'IRT99 - Structural irregularity type, unknown', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (323, 'STR_IRREG_DT', 'IRP99', 'IRP99 - Structural irregularity detail, unknown', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (357, 'ROOFSYSMAT', 'RSM99', 'RSM99 - Roof system material, unknown', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (358, 'ROOFSYSTYP', 'RST99', 'RST99 - Roof system type, unknown', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (360, 'ROOF_CONN', 'RCN99', 'RCN99 - Roof connection, unknown', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (361, 'FLOOR_TYPE', 'FT99', 'FT99 - Floor type, unknown', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (362, 'BUILD_TYPE', 'EMCA1', 'EMCA1 - Load bearing masonry wall buildings', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (363, 'BUILD_TYPE', 'EMCA2', 'EMCA2 - Monolithic reinforced concrete buildings', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (364, 'BUILD_TYPE', 'EMCA3', 'EMCA3 - Precast concrete buildings', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (365, 'BUILD_TYPE', 'EMCA4', 'EMCA4 - Non-engineered earthen buildings', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (366, 'BUILD_TYPE', 'EMCA5', 'EMCA5 - Wooden buildings', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (367, 'BUILD_TYPE', 'EMCA6', 'EMCA6 - Steel buildings', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (368, 'BUILD_SUBTYPE', 'EMCA1_1', 'EMCA1.1 - Unreinforced masonry buildings with walls of brick masonry, stone, or blocks in cement or mixed mortar (no seismic design) - wooden floors', 'DX /MUR+CLBRS+MOC /LWAL+DNO /DY /MUR+CLBRS+MOC /LWAL+DNO /YAPP:1940-1955 /HBET:2,3 /RES+RES2E /BP3 /PLFR /IRRE /EWMA /RSH3+RMT4+RO+RWCP /FW /FOSS');
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (369, 'BUILD_SUBTYPE', 'EMCA1_2', 'EMCA1.2 - Unreinforced masonry - buildings with walls of brick masonry, stone, or blocks in cement or mixed mortar (no seismic design) - precast concrete floors', 'DX /MUR+MOCL /LWAL+DNO /DY /MUR+MOCL /LWAL+DNO /YBET:1975,1990 /HBET:1,2+HBEX:0+HFBET:0.5,1.0+HD:0 /RES+RES2A / /PLFR /IRRE /EWMA /RSH3+RMT4+RWO+RWO3+RTDP /FC+FC3+FWCP /FOSS ');
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (370, 'BUILD_SUBTYPE', 'EMCA1_3', 'EMCA1.3 - Confined masonry', 'DX /MCF+MOC /LWAL+DNO /DY /MCF+MOC /LWAL+DNO /YBET:1961,2012 /HBET:1,5+HBEX:0+HFBET:0.5,1.5+HD:0 /RES+RES2E / /PLFR /IRIR+IRVP:SOS /EWMA /RSH3+RMT4+RWO+RWO3+RTDP /FC+FC3+FWCP /FOSSL');
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (371, 'BUILD_SUBTYPE', 'EMCA1_4', 'EMCA1.4 - Masonry with seismic provisions (e.g. seismic belts)', 'DX /MR+CLBRS+RCB+MOCL /LWAL+DNO /DY /MR+CLBRS+RCB+MOCL /LWAL+DNO /YBET:1948,1959 /HBET:1,3+HBEX:0+HFBET:0.3,0.8+HD:0 /RES+RES2D /BPD /PLFR /IRRE /EWMA /RSH3+RMT4+RWO+RWO3+RTDP /FW+FW3+FWCP /FOSSL');
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (372, 'BUILD_SUBTYPE', 'EMCA2_1', 'EMCA2.1 - Buildings with monolithic concrete moment frames', 'DX /CR+CIP /LFM+DUC /DY /CR+CIP /LFM+DUC /YBET:1950,2012 /HBET:3,7+HBEX:0+HFBET:0.8,1.2+HD:0 /RES+RES2E /BPD /PLFR /IRRE /EWCB /RSH1+RMN+RC+RC3+RTDP /FC+FC3+FWCN /FOSDL');
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (373, 'BUILD_SUBTYPE', 'EMCA2_2', 'EMCA2.2 - Buildings with monolithic concrete frame and shear walls (dual system)', 'DX /CR+CIP /LDUAL+DNO /DY /CR+CIP /LDUAL+DNO /YBET:1987,2012 /HBET:7,25+HBBET:1,3+HFBET:1.2,2.0+HD:0 /RES+RES2F /BPD /PLFR /IRIR+IRVP:CHV /EWMA /RSH1+RMN+RC+RC2+RTDP /FC+FC2+FWCP /FOSDL');
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (374, 'BUILD_SUBTYPE', 'EMCA2_3', 'EMCA2.3 - Buildings with monolithic concrete frames and brick infill walls', 'DX /CR+CIP /LFINF+DNO /DY /CR+CIP /LFINF+DNO /YBET:1975,1995 /HBET:3,7+HBEX:0+HFBET:1,1.5+HD:0 /RES+RES2E /BPD /PLFR /IRRE /EWMA /RSH1+RMN+RC+RC3+RTDP /FC+FC3+FWCN /FOSDL');
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (375, 'BUILD_SUBTYPE', 'EMCA2_4', 'EMCA2.4 - Buildings with monolithic reinforced concrete walls', 'DX /CR+CIP /LWAL+DNO /DY /CR+CIP /LWAL+DNO /YBET:1980,2012 /HBET:8,16+HBEX:1+HFBET:1,1.5+HD:0 /RES+RES2F /BPD /PLFR /IRIR+IRVP:SOS /EWC /RSH1+RMN+RC+RC3+RTDP /FC+FC3+FWCN /FOSDL');
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (376, 'BUILD_SUBTYPE', 'EMCA3_1', 'EMCA3.1 - Precast concrete large panel buildings with monolithic panel joints - Seria 105', 'DX /CR+PC /LWAL+DUC /DY /CR+PC /LWAL+DUC /YBET:1964,2012 /HBET:1,16+HBEX:1+HFBET:1,1.8+HD:0 /RES+RES2F /BPD /PLFR /IRRE /EWC /RSH1+RMN+RC+RC3+RTDP /FC+FC3+FWCP /FOSDL');
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (377, 'BUILD_SUBTYPE', 'EMCA3_2', 'EMCA3.2 - Precast concrete large panel buildings with panel connections achieved by welding of embedment plates - Seria 464', '');
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (378, 'BUILD_SUBTYPE', 'EMCA3_3', 'EMCA3.3 - Precast concrete flat slab buildings (consisting of columns and slabs) - Seria KUB', 'DX /CR+PC /LFLS+DUC /DY /CR+PC /LFLS+DUC /YBET:1980,1990 /HBET:5,9+HBEX:1+HFBET:0.8,1.5+HD:0 /RES+RES2F /BPD /PLFR /IRRE /EWC /RSH1+RMN+RC+RC3+RTDP /FC+FC3+FWCP /FOSDL');
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (379, 'BUILD_SUBTYPE', 'EMCA3_4', 'EMCA3.4 - Prefabricated RC frame with linear elements with welded joints in the zone of maximum loads or with rigid walls in one direction - Seria 111, IIS-04', 'DX /CR+PC /LFLS+DUC /DY /CR+PC /LFLS+DUC /YBET:1966,1970 /HBET:6,7+HBEX:1+HFBET:1,1.5+HD:0 /RES+RES2E /BPD /PLFR /IRRE /EWC /RSH1+RMN+RC+RC3+RTDP /FC+FC3+FWCP /FOSDL');
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (380, 'BUILD_SUBTYPE', 'EMCA4_1', 'EMCA4.1 - Buildings with adobe or earthen walls', 'DX /MUR+ADO+MOM /LWAL+DNO /DY /MUR+ADO+MOM /LWAL+DNO /YBET:1850,2012 /HEX:1+HBEX:0+HFBET:0.3,0.5+HD:0 /RES+RES1 /BPD /PLFR /IRIR+IRPP:TOR /EWE /RSH2+RMT4+RWO+RWO3+RTDN /FW+FW3+FWCN /FOSSL');
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (381, 'BUILD_SUBTYPE', 'EMCA5_1', 'EMCA5.1 - Buildings with load-bearing braced wooden frames', 'DX /W /LWAL+DUC /DY /W /LWAL+DUC /YBET:1950,1970 /HBET:1,2+HBEX:0+HFBET:0.3,0.5+HD:0 /RES+RES2C /BPD /PLFR /IRRE /EWW /RSH2+RMT4+RWO+RWO3+RTDP /FW+FW3+FWCP /FOSSL');
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (382, 'BUILD_SUBTYPE', 'EMCA5_2', 'EMCA5.2 - Building with a wooden frame and mud infill', 'DX /W+WLI /LO+DUC /DY /W+WLI /LO+DUC /YBET:0,2012 /HBET:1,2+HBEX:0+HFBET:0.3,0.5+HD:0 /RES+RES1 /BPD /PLFR /IRRE /EWE /RSH2+RMT4+RWO+RWO3+RTDP /FW+FW3+FWCP /FOSSL');
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (383, 'BUILD_SUBTYPE', 'EMCA6_1', 'EMCA6.1 - Steel buildings', 'DX /S+SL+RIV /LFM+DNO /DY /S+SL+RIV /LFM+DNO /YAPP:2008 /HEX:1+HFEX:3+HD:15 /RES+RES1 /BPD /PLFR /IRRE /EWPL /RSH3+RMT6+RME+RME1+RWCP /FME+FME3 /FOSSL');
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (384, 'VULN', 'VULN_EX', 'Exact vulnerability class', NULL);
INSERT INTO dic_attribute_value (gid, attribute_type_code, attribute_value, description, extended_description) VALUES (385, 'VULN', 'VULN_BET', 'Lower and upper class of vulnerability', NULL);


--
-- TOC entry 3833 (class 0 OID 0)
-- Dependencies: 220
-- Name: dic_attribute_value_gid_seq; Type: SEQUENCE SET; Schema: taxonomy; Owner: postgres
--

SELECT pg_catalog.setval('dic_attribute_value_gid_seq', 1, false);


--
-- TOC entry 3663 (class 0 OID 1853718)
-- Dependencies: 221
-- Data for Name: dic_hazard; Type: TABLE DATA; Schema: taxonomy; Owner: postgres
--

INSERT INTO dic_hazard (gid, code, description, extended_description, attribute_type_code) VALUES (1, 'EQ', 'EQ - Earthquake', NULL, 'MAT_TYPE');
INSERT INTO dic_hazard (gid, code, description, extended_description, attribute_type_code) VALUES (2, 'EQ', 'EQ - Earthquake', NULL, 'MAT_TECH');
INSERT INTO dic_hazard (gid, code, description, extended_description, attribute_type_code) VALUES (3, 'EQ', 'EQ - Earthquake', NULL, 'MAT_PROP');
INSERT INTO dic_hazard (gid, code, description, extended_description, attribute_type_code) VALUES (4, 'EQ', 'EQ - Earthquake', NULL, 'LLRS');
INSERT INTO dic_hazard (gid, code, description, extended_description, attribute_type_code) VALUES (5, 'EQ', 'EQ - Earthquake', NULL, 'LLRS_DUCT');
INSERT INTO dic_hazard (gid, code, description, extended_description, attribute_type_code) VALUES (6, 'EQ', 'EQ - Earthquake', NULL, 'HEIGHT');
INSERT INTO dic_hazard (gid, code, description, extended_description, attribute_type_code) VALUES (7, 'EQ', 'EQ - Earthquake', NULL, 'YR_BUILT');
INSERT INTO dic_hazard (gid, code, description, extended_description, attribute_type_code) VALUES (8, 'EQ', 'EQ - Earthquake', NULL, 'OCCUPY');
INSERT INTO dic_hazard (gid, code, description, extended_description, attribute_type_code) VALUES (9, 'EQ', 'EQ - Earthquake', NULL, 'OCCUPY_DT');
INSERT INTO dic_hazard (gid, code, description, extended_description, attribute_type_code) VALUES (10, 'EQ', 'EQ - Earthquake', NULL, 'POSITION');
INSERT INTO dic_hazard (gid, code, description, extended_description, attribute_type_code) VALUES (11, 'EQ', 'EQ - Earthquake', NULL, 'PLAN_SHAPE');
INSERT INTO dic_hazard (gid, code, description, extended_description, attribute_type_code) VALUES (12, 'EQ', 'EQ - Earthquake', NULL, 'STR_IRREG');
INSERT INTO dic_hazard (gid, code, description, extended_description, attribute_type_code) VALUES (13, 'EQ', 'EQ - Earthquake', NULL, 'STR_IRREG_DT');
INSERT INTO dic_hazard (gid, code, description, extended_description, attribute_type_code) VALUES (14, 'EQ', 'EQ - Earthquake', NULL, 'STR_IRREG_TYPE');
INSERT INTO dic_hazard (gid, code, description, extended_description, attribute_type_code) VALUES (15, 'EQ', 'EQ - Earthquake', NULL, 'NONSTRCEXW');
INSERT INTO dic_hazard (gid, code, description, extended_description, attribute_type_code) VALUES (16, 'EQ', 'EQ - Earthquake', NULL, 'ROOF_SHAPE');
INSERT INTO dic_hazard (gid, code, description, extended_description, attribute_type_code) VALUES (17, 'EQ', 'EQ - Earthquake', NULL, 'ROOFCOVMAT');
INSERT INTO dic_hazard (gid, code, description, extended_description, attribute_type_code) VALUES (18, 'EQ', 'EQ - Earthquake', NULL, 'ROOFSYSMAT');
INSERT INTO dic_hazard (gid, code, description, extended_description, attribute_type_code) VALUES (19, 'EQ', 'EQ - Earthquake', NULL, 'ROOFSYSTYP');
INSERT INTO dic_hazard (gid, code, description, extended_description, attribute_type_code) VALUES (20, 'EQ', 'EQ - Earthquake', NULL, 'ROOF_CONN');
INSERT INTO dic_hazard (gid, code, description, extended_description, attribute_type_code) VALUES (21, 'EQ', 'EQ - Earthquake', NULL, 'FLOOR_MAT');
INSERT INTO dic_hazard (gid, code, description, extended_description, attribute_type_code) VALUES (22, 'EQ', 'EQ - Earthquake', NULL, 'FLOOR_TYPE');
INSERT INTO dic_hazard (gid, code, description, extended_description, attribute_type_code) VALUES (23, 'EQ', 'EQ - Earthquake', NULL, 'FLOOR_CONN');
INSERT INTO dic_hazard (gid, code, description, extended_description, attribute_type_code) VALUES (24, 'EQ', 'EQ - Earthquake', NULL, 'FOUNDN_SYS');
INSERT INTO dic_hazard (gid, code, description, extended_description, attribute_type_code) VALUES (25, 'EQ', 'EQ - Earthquake', NULL, 'BUILD_TYPE');
INSERT INTO dic_hazard (gid, code, description, extended_description, attribute_type_code) VALUES (26, 'EQ', 'EQ - Earthquake', NULL, 'BUILD_SUBTYPE');
INSERT INTO dic_hazard (gid, code, description, extended_description, attribute_type_code) VALUES (27, 'EQ', 'EQ - Earthquake', NULL, 'VULN');


--
-- TOC entry 3834 (class 0 OID 0)
-- Dependencies: 222
-- Name: dic_hazard_gid_seq; Type: SEQUENCE SET; Schema: taxonomy; Owner: postgres
--

SELECT pg_catalog.setval('dic_hazard_gid_seq', 1, false);


--
-- TOC entry 3665 (class 0 OID 1853726)
-- Dependencies: 223
-- Data for Name: dic_qualifier_type; Type: TABLE DATA; Schema: taxonomy; Owner: postgres
--

INSERT INTO dic_qualifier_type (gid, code, description, extended_description) VALUES (1, 'BELIEF', 'Uncertainty measured as subjective degree of belief', NULL);
INSERT INTO dic_qualifier_type (gid, code, description, extended_description) VALUES (2, 'QUALITY', 'Assessment of quality of attribute information', NULL);
INSERT INTO dic_qualifier_type (gid, code, description, extended_description) VALUES (3, 'SOURCE', 'Source of information', NULL);
INSERT INTO dic_qualifier_type (gid, code, description, extended_description) VALUES (4, 'VALIDTIME', 'Valid time of real-world object (e.g., construction period)', NULL);


--
-- TOC entry 3835 (class 0 OID 0)
-- Dependencies: 224
-- Name: dic_qualifier_type_gid_seq; Type: SEQUENCE SET; Schema: taxonomy; Owner: postgres
--

SELECT pg_catalog.setval('dic_qualifier_type_gid_seq', 1, false);


--
-- TOC entry 3667 (class 0 OID 1853734)
-- Dependencies: 225
-- Data for Name: dic_qualifier_value; Type: TABLE DATA; Schema: taxonomy; Owner: postgres
--

INSERT INTO dic_qualifier_value (gid, qualifier_type_code, qualifier_value, description, extended_description) VALUES (1, 'BELIEF', 'BLOW', NULL, NULL);
INSERT INTO dic_qualifier_value (gid, qualifier_type_code, qualifier_value, description, extended_description) VALUES (2, 'BELIEF', 'BHIGH', NULL, NULL);
INSERT INTO dic_qualifier_value (gid, qualifier_type_code, qualifier_value, description, extended_description) VALUES (3, 'BELIEF', 'BP', 'Percentage 1-100 - use add_numeric_1 to enter belief value', NULL);
INSERT INTO dic_qualifier_value (gid, qualifier_type_code, qualifier_value, description, extended_description) VALUES (4, 'BELIEF', 'B99', 'Unknown', NULL);
INSERT INTO dic_qualifier_value (gid, qualifier_type_code, qualifier_value, description, extended_description) VALUES (5, 'QUALITY', 'QLOW', NULL, NULL);
INSERT INTO dic_qualifier_value (gid, qualifier_type_code, qualifier_value, description, extended_description) VALUES (6, 'QUALITY', 'QMEDIUM', NULL, NULL);
INSERT INTO dic_qualifier_value (gid, qualifier_type_code, qualifier_value, description, extended_description) VALUES (7, 'QUALITY', 'QHIGH', NULL, NULL);
INSERT INTO dic_qualifier_value (gid, qualifier_type_code, qualifier_value, description, extended_description) VALUES (8, 'SOURCE', 'OSM', 'OpenStreetMap', NULL);
INSERT INTO dic_qualifier_value (gid, qualifier_type_code, qualifier_value, description, extended_description) VALUES (9, 'SOURCE', 'RS', 'Remote Sensing', NULL);
INSERT INTO dic_qualifier_value (gid, qualifier_type_code, qualifier_value, description, extended_description) VALUES (10, 'SOURCE', 'RVS', 'Rapid Visual Screening', NULL);
INSERT INTO dic_qualifier_value (gid, qualifier_type_code, qualifier_value, description, extended_description) VALUES (11, 'SOURCE', 'RRVS', 'Remote Rapid Visual Screening', NULL);
INSERT INTO dic_qualifier_value (gid, qualifier_type_code, qualifier_value, description, extended_description) VALUES (12, 'SOURCE', 'OF', 'Official Source (e.g. cadastral data or census)', NULL);
INSERT INTO dic_qualifier_value (gid, qualifier_type_code, qualifier_value, description, extended_description) VALUES (13, 'VALIDTIME', 'BUILT', 'Start timestamp of lifetime', NULL);
INSERT INTO dic_qualifier_value (gid, qualifier_type_code, qualifier_value, description, extended_description) VALUES (14, 'VALIDTIME', 'MODIF', 'Modification timestamp of lifetime', NULL);
INSERT INTO dic_qualifier_value (gid, qualifier_type_code, qualifier_value, description, extended_description) VALUES (15, 'VALIDTIME', 'DESTR', 'End timestamp of lifetime', NULL);


--
-- TOC entry 3836 (class 0 OID 0)
-- Dependencies: 226
-- Name: dic_qualifier_value_gid_seq; Type: SEQUENCE SET; Schema: taxonomy; Owner: postgres
--

SELECT pg_catalog.setval('dic_qualifier_value_gid_seq', 1, false);


--
-- TOC entry 3669 (class 0 OID 1853742)
-- Dependencies: 227
-- Data for Name: dic_taxonomy; Type: TABLE DATA; Schema: taxonomy; Owner: postgres
--

INSERT INTO dic_taxonomy (gid, code, description, extended_description, version_date) VALUES (1, 'GEM20', 'GEM Building Taxonomy V2.0', NULL, '2013-03-12');
INSERT INTO dic_taxonomy (gid, code, description, extended_description, version_date) VALUES (2, 'SENSUM', 'SENSUM Indicators', NULL, '2013-11-12');
INSERT INTO dic_taxonomy (gid, code, description, extended_description, version_date) VALUES (3, 'EMCA', 'EMCA Building Typology', NULL, '2013-04-16');
INSERT INTO dic_taxonomy (gid, code, description, extended_description, version_date) VALUES (4, 'EMS98', 'European Macroseismic Scale 1998', NULL, '1998-01-01');


--
-- TOC entry 3837 (class 0 OID 0)
-- Dependencies: 228
-- Name: dic_taxonomy_gid_seq; Type: SEQUENCE SET; Schema: taxonomy; Owner: postgres
--

SELECT pg_catalog.setval('dic_taxonomy_gid_seq', 1, false);


SET search_path = asset, pg_catalog;

--
-- TOC entry 3457 (class 2606 OID 1853789)
-- Name: pk_object; Type: CONSTRAINT; Schema: asset; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY object_attribute
    ADD CONSTRAINT pk_object PRIMARY KEY (gid);


--
-- TOC entry 3453 (class 2606 OID 1853791)
-- Name: pk_object_0; Type: CONSTRAINT; Schema: asset; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY object
    ADD CONSTRAINT pk_object_0 PRIMARY KEY (gid);


--
-- TOC entry 3463 (class 2606 OID 1853793)
-- Name: pk_object_attribute_qualifier; Type: CONSTRAINT; Schema: asset; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY object_attribute_qualifier
    ADD CONSTRAINT pk_object_attribute_qualifier PRIMARY KEY (gid);


SET search_path = history, pg_catalog;

--
-- TOC entry 3470 (class 2606 OID 1853795)
-- Name: logged_actions_pkey; Type: CONSTRAINT; Schema: history; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY logged_actions
    ADD CONSTRAINT logged_actions_pkey PRIMARY KEY (gid);


SET search_path = image, pg_catalog;

--
-- TOC entry 3474 (class 2606 OID 1853797)
-- Name: pk_gpano_metadata; Type: CONSTRAINT; Schema: image; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY gpano_metadata
    ADD CONSTRAINT pk_gpano_metadata PRIMARY KEY (gid);


--
-- TOC entry 3476 (class 2606 OID 1853799)
-- Name: pk_gps; Type: CONSTRAINT; Schema: image; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY gps
    ADD CONSTRAINT pk_gps UNIQUE (gid);


--
-- TOC entry 3478 (class 2606 OID 1853801)
-- Name: pk_image_type; Type: CONSTRAINT; Schema: image; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY image_type
    ADD CONSTRAINT pk_image_type PRIMARY KEY (gid);


--
-- TOC entry 3480 (class 2606 OID 1853803)
-- Name: pk_image_type_0; Type: CONSTRAINT; Schema: image; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY image_type
    ADD CONSTRAINT pk_image_type_0 UNIQUE (code);


SET search_path = survey, pg_catalog;

--
-- TOC entry 3487 (class 2606 OID 1853805)
-- Name: pk_survey; Type: CONSTRAINT; Schema: survey; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY survey
    ADD CONSTRAINT pk_survey PRIMARY KEY (gid);


--
-- TOC entry 3489 (class 2606 OID 1853807)
-- Name: pk_survey_type; Type: CONSTRAINT; Schema: survey; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY survey_type
    ADD CONSTRAINT pk_survey_type PRIMARY KEY (gid);


--
-- TOC entry 3491 (class 2606 OID 1853809)
-- Name: pk_survey_type_0; Type: CONSTRAINT; Schema: survey; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY survey_type
    ADD CONSTRAINT pk_survey_type_0 UNIQUE (code);


SET search_path = taxonomy, pg_catalog;

--
-- TOC entry 3465 (class 2606 OID 1853811)
-- Name: idx_dic_attribute_type; Type: CONSTRAINT; Schema: taxonomy; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY dic_attribute_type
    ADD CONSTRAINT idx_dic_attribute_type UNIQUE (code);


--
-- TOC entry 3468 (class 2606 OID 1853813)
-- Name: pk_dic_attribute_type; Type: CONSTRAINT; Schema: taxonomy; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY dic_attribute_type
    ADD CONSTRAINT pk_dic_attribute_type PRIMARY KEY (gid);


--
-- TOC entry 3494 (class 2606 OID 1853815)
-- Name: pk_dic_attribute_value; Type: CONSTRAINT; Schema: taxonomy; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY dic_attribute_value
    ADD CONSTRAINT pk_dic_attribute_value PRIMARY KEY (gid);


--
-- TOC entry 3496 (class 2606 OID 1853817)
-- Name: pk_dic_attribute_value_0; Type: CONSTRAINT; Schema: taxonomy; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY dic_attribute_value
    ADD CONSTRAINT pk_dic_attribute_value_0 UNIQUE (attribute_value);


--
-- TOC entry 3501 (class 2606 OID 1853819)
-- Name: pk_dic_qualifier_type; Type: CONSTRAINT; Schema: taxonomy; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY dic_qualifier_type
    ADD CONSTRAINT pk_dic_qualifier_type UNIQUE (code);


--
-- TOC entry 3506 (class 2606 OID 1853821)
-- Name: pk_dic_qualifier_value; Type: CONSTRAINT; Schema: taxonomy; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY dic_qualifier_value
    ADD CONSTRAINT pk_dic_qualifier_value PRIMARY KEY (gid);


--
-- TOC entry 3508 (class 2606 OID 1853823)
-- Name: pk_dic_qualifier_value_0; Type: CONSTRAINT; Schema: taxonomy; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY dic_qualifier_value
    ADD CONSTRAINT pk_dic_qualifier_value_0 UNIQUE (qualifier_value);


--
-- TOC entry 3510 (class 2606 OID 1853825)
-- Name: pk_dic_taxonomy; Type: CONSTRAINT; Schema: taxonomy; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY dic_taxonomy
    ADD CONSTRAINT pk_dic_taxonomy PRIMARY KEY (gid);


--
-- TOC entry 3512 (class 2606 OID 1853827)
-- Name: pk_dic_taxonomy_0; Type: CONSTRAINT; Schema: taxonomy; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY dic_taxonomy
    ADD CONSTRAINT pk_dic_taxonomy_0 UNIQUE (code);


--
-- TOC entry 3499 (class 2606 OID 1853829)
-- Name: pk_hazard; Type: CONSTRAINT; Schema: taxonomy; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY dic_hazard
    ADD CONSTRAINT pk_hazard PRIMARY KEY (gid);


--
-- TOC entry 3503 (class 2606 OID 1853831)
-- Name: pk_qualifier_type; Type: CONSTRAINT; Schema: taxonomy; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY dic_qualifier_type
    ADD CONSTRAINT pk_qualifier_type PRIMARY KEY (gid);


SET search_path = asset, pg_catalog;

--
-- TOC entry 3451 (class 1259 OID 1853832)
-- Name: idx_object; Type: INDEX; Schema: asset; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_object ON object USING btree (survey_gid);


--
-- TOC entry 3454 (class 1259 OID 1853833)
-- Name: idx_object_attribute; Type: INDEX; Schema: asset; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_object_attribute ON object_attribute USING btree (object_id);


--
-- TOC entry 3459 (class 1259 OID 1853834)
-- Name: idx_object_attribute_qualifier; Type: INDEX; Schema: asset; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_object_attribute_qualifier ON object_attribute_qualifier USING btree (attribute_id);


--
-- TOC entry 3460 (class 1259 OID 1853835)
-- Name: idx_object_attribute_qualifier_0; Type: INDEX; Schema: asset; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_object_attribute_qualifier_0 ON object_attribute_qualifier USING btree (qualifier_type_code);


--
-- TOC entry 3461 (class 1259 OID 1853836)
-- Name: idx_object_attribute_qualifier_1; Type: INDEX; Schema: asset; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_object_attribute_qualifier_1 ON object_attribute_qualifier USING btree (qualifier_value);


--
-- TOC entry 3455 (class 1259 OID 1853837)
-- Name: idx_object_attribute_value; Type: INDEX; Schema: asset; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_object_attribute_value ON object_attribute USING btree (attribute_value);


--
-- TOC entry 3458 (class 1259 OID 1853838)
-- Name: pk_object_attribute_type_code; Type: INDEX; Schema: asset; Owner: postgres; Tablespace: 
--

CREATE INDEX pk_object_attribute_type_code ON object_attribute USING btree (attribute_type_code);


SET search_path = history, pg_catalog;

--
-- TOC entry 3471 (class 1259 OID 1853839)
-- Name: logged_changes_action_idx; Type: INDEX; Schema: history; Owner: postgres; Tablespace: 
--

CREATE INDEX logged_changes_action_idx ON logged_actions USING btree (transaction_type);


--
-- TOC entry 3472 (class 1259 OID 1853840)
-- Name: logged_changes_table_id_idx; Type: INDEX; Schema: history; Owner: postgres; Tablespace: 
--

CREATE INDEX logged_changes_table_id_idx ON logged_actions USING btree (table_id);


SET search_path = image, pg_catalog;

--
-- TOC entry 3481 (class 1259 OID 1853841)
-- Name: idx_img; Type: INDEX; Schema: image; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_img ON img USING btree (gps);


--
-- TOC entry 3482 (class 1259 OID 1853842)
-- Name: idx_img_0; Type: INDEX; Schema: image; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_img_0 ON img USING btree (survey);


--
-- TOC entry 3483 (class 1259 OID 1853843)
-- Name: idx_img_1; Type: INDEX; Schema: image; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_img_1 ON img USING btree (type);


--
-- TOC entry 3484 (class 1259 OID 1853844)
-- Name: idx_img_2; Type: INDEX; Schema: image; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_img_2 ON img USING btree (gpano);


SET search_path = survey, pg_catalog;

--
-- TOC entry 3485 (class 1259 OID 1853845)
-- Name: idx_survey; Type: INDEX; Schema: survey; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_survey ON survey USING btree (type);


SET search_path = taxonomy, pg_catalog;

--
-- TOC entry 3466 (class 1259 OID 1853846)
-- Name: idx_dic_attribute_type_0; Type: INDEX; Schema: taxonomy; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_dic_attribute_type_0 ON dic_attribute_type USING btree (taxonomy_code);


--
-- TOC entry 3492 (class 1259 OID 1853847)
-- Name: idx_dic_attribute_value; Type: INDEX; Schema: taxonomy; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_dic_attribute_value ON dic_attribute_value USING btree (attribute_type_code);


--
-- TOC entry 3504 (class 1259 OID 1853848)
-- Name: idx_dic_qualifier_value; Type: INDEX; Schema: taxonomy; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_dic_qualifier_value ON dic_qualifier_value USING btree (qualifier_type_code);


--
-- TOC entry 3497 (class 1259 OID 1853849)
-- Name: idx_hazard; Type: INDEX; Schema: taxonomy; Owner: postgres; Tablespace: 
--

CREATE INDEX idx_hazard ON dic_hazard USING btree (attribute_type_code);


SET search_path = asset, pg_catalog;

--
-- TOC entry 3524 (class 2620 OID 1853850)
-- Name: object_trigger; Type: TRIGGER; Schema: asset; Owner: postgres
--

CREATE TRIGGER object_trigger INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_object FOR EACH ROW EXECUTE PROCEDURE edit_object_view();


--
-- TOC entry 3515 (class 2606 OID 1853851)
-- Name: fk_attribute_gid; Type: FK CONSTRAINT; Schema: asset; Owner: postgres
--

ALTER TABLE ONLY object_attribute_qualifier
    ADD CONSTRAINT fk_attribute_gid FOREIGN KEY (attribute_id) REFERENCES object_attribute(gid);


--
-- TOC entry 3514 (class 2606 OID 1853856)
-- Name: fk_object_gid; Type: FK CONSTRAINT; Schema: asset; Owner: postgres
--

ALTER TABLE ONLY object_attribute
    ADD CONSTRAINT fk_object_gid FOREIGN KEY (object_id) REFERENCES object(gid);


--
-- TOC entry 3513 (class 2606 OID 1853861)
-- Name: fk_object_survey; Type: FK CONSTRAINT; Schema: asset; Owner: postgres
--

ALTER TABLE ONLY object
    ADD CONSTRAINT fk_object_survey FOREIGN KEY (survey_gid) REFERENCES survey.survey(gid);


SET search_path = image, pg_catalog;

--
-- TOC entry 3517 (class 2606 OID 1853866)
-- Name: fk_img_gpano_metadata; Type: FK CONSTRAINT; Schema: image; Owner: postgres
--

ALTER TABLE ONLY img
    ADD CONSTRAINT fk_img_gpano_metadata FOREIGN KEY (gpano) REFERENCES gpano_metadata(gid);


--
-- TOC entry 3518 (class 2606 OID 1853871)
-- Name: fk_img_gps; Type: FK CONSTRAINT; Schema: image; Owner: postgres
--

ALTER TABLE ONLY img
    ADD CONSTRAINT fk_img_gps FOREIGN KEY (gps) REFERENCES gps(gid);


--
-- TOC entry 3519 (class 2606 OID 1853876)
-- Name: fk_img_image_type; Type: FK CONSTRAINT; Schema: image; Owner: postgres
--

ALTER TABLE ONLY img
    ADD CONSTRAINT fk_img_image_type FOREIGN KEY (type) REFERENCES image_type(code);


SET search_path = survey, pg_catalog;

--
-- TOC entry 3520 (class 2606 OID 1853881)
-- Name: fk_survey_survey_type; Type: FK CONSTRAINT; Schema: survey; Owner: postgres
--

ALTER TABLE ONLY survey
    ADD CONSTRAINT fk_survey_survey_type FOREIGN KEY (type) REFERENCES survey_type(code);


SET search_path = taxonomy, pg_catalog;

--
-- TOC entry 3521 (class 2606 OID 1853886)
-- Name: fk_attribute_type_code; Type: FK CONSTRAINT; Schema: taxonomy; Owner: postgres
--

ALTER TABLE ONLY dic_attribute_value
    ADD CONSTRAINT fk_attribute_type_code FOREIGN KEY (attribute_type_code) REFERENCES dic_attribute_type(code);


--
-- TOC entry 3522 (class 2606 OID 1853891)
-- Name: fk_attribute_type_code; Type: FK CONSTRAINT; Schema: taxonomy; Owner: postgres
--

ALTER TABLE ONLY dic_hazard
    ADD CONSTRAINT fk_attribute_type_code FOREIGN KEY (attribute_type_code) REFERENCES dic_attribute_type(code);


--
-- TOC entry 3516 (class 2606 OID 1853896)
-- Name: fk_dic_attribute_type; Type: FK CONSTRAINT; Schema: taxonomy; Owner: postgres
--

ALTER TABLE ONLY dic_attribute_type
    ADD CONSTRAINT fk_dic_attribute_type FOREIGN KEY (taxonomy_code) REFERENCES dic_taxonomy(code);


--
-- TOC entry 3523 (class 2606 OID 1853901)
-- Name: fk_dic_qualifier_value; Type: FK CONSTRAINT; Schema: taxonomy; Owner: postgres
--

ALTER TABLE ONLY dic_qualifier_value
    ADD CONSTRAINT fk_dic_qualifier_value FOREIGN KEY (qualifier_type_code) REFERENCES dic_qualifier_type(code);


-- Completed on 2016-01-13 10:00:29 CET

--
-- PostgreSQL database dump complete
--
