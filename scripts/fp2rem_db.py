###############################################
# Script that creates an SQL script to write
# footprints from a shapefile to a REM database
# Author: M.Haas mhaas@gfz-potsdam.de
# input: 1) shapefile with footprints
#        2) name of survey in REM db for which
#           these footprints should be used
#        3) optionally: source of footprints
# output: sql file
#############################
import os

shapefile = 'madaba.shp'
sql_out = 'fp2rem.sql'
source = 'OSM'
survey_name='madaba2015'

#create a table with the shapefile layer containing postgis geometry
cmd = "shp2pgsql -s 4326 -g the_geom {} temporary_footprint_data > {}".format(shapefile,sql_out)
os.system(cmd)

#write inserts in ve_objects for each row in sql_out
#INSERT INTO asset.ve_object (gid, survey_gid, description, source, accuracy, the_geom, object_id, mat_type, mat_tech, mat_prop, llrs, llrs_duct, height, yr_built, occupy, occupy_dt, "position", plan_shape, str_irreg, str_irreg_dt, str_irreg_type, nonstrcexw, roof_shape, roofcovmat, roofsysmat, roofsystyp, roof_conn, floor_mat, floor_type, floor_conn, foundn_sys, build_type, build_subtype, vuln, rrvs_status, vuln_1, vuln_2, height_1, height_2, object_id1, mat_type_bp, mat_tech_bp, mat_prop_bp,llrs_bp, llrs_duct_bp, height_bp, yr_built_bp, occupy_bp, occupy_dt_bp, position_bp, plan_shape_bp, str_irreg_bp, str_irreg_dt_bp, str_irreg_type_bp, nonstrcexw_bp, roof_shape_bp, roofcovmat_bp, roofsysmat_bp, roofsystyp_bp, roof_conn_bp, floor_mat_bp, floor_type_bp, floor_conn_bp, foundn_sys_bp, build_type_bp, build_subtype_bp, vuln_bp, yr_built_vt, yr_built_vt1, object_id2, mat_type_src, mat_tech_src, mat_prop_src, llrs_src, llrs_duct_src, height_src, yr_built_src, occupy_src,occupy_dt_src, position_src, plan_shape_src, str_irreg_src, str_irreg_dt_src, str_irreg_type_src, nonstrcexw_src, roof_shape_src, roofcovmat_src, roofsysmat_src, roofsystyp_src, roof_conn_src, floor_mat_src, floor_type_src, floor_conn_src, foundn_sys_src, build_type_src, build_subtype_src, vuln_src) SELECT 1724, NULL, NULL, NULL, NULL, the_geom, 1724 , 'MAT99', 'MATT99', 'SPO', 'L99', 'DU99', 'H', 'Y99', 'OC99', 'OCCDT99', 'BP99', 'PLF99', 'IR99', 'IRP99', 'IRT99', 'EW99', 'R99', 'RMT99', 'RSM99', 'RST99', 'RCN99', 'F99', 'FT99', 'FWC99', 'FOS99', NULL, NULL, NULL, 'UNMODIFIED', NULL, NULL, 222, NULL, 1724, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1724, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
query="INSERT INTO asset.ve_object (survey_gid, source, the_geom, mat_type, mat_tech, mat_prop, llrs, llrs_duct, height, yr_built, occupy, occupy_dt, position, plan_shape, str_irreg, str_irreg_dt, str_irreg_type, nonstrcexw, roof_shape, roofcovmat, roofsysmat, roofsystyp, roof_conn, floor_mat, floor_type, floor_conn, foundn_sys, height, rrvs_status) SELECT survey.survey.gid, '{}', temporary_footprint_data.the_geom, 'MAT99', 'MATT99', 'SPO', 'L99', 'DU99', 'H', 'Y99', 'OC99', 'OCCDT99',
'BP99','PLF99','IR99', 'IRP99', 'IRT99','EW99','R99', 'RMT99', 'RSM99', 'RST99', 'RCN99', 'F99', 'FT99', 'FWC99', 'FOS99',99,'UNMODIFIED' FROM temporary_footprint_data,survey.survey WHERE survey.survey.name='{}';".format(source,survey_name)

with open(sql_out,'a') as f:
    f.write(query)
    query = "DROP TABLE temporary_footprint_data"
    f.write(query)
