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

shapefile = '/home/sysop/survey/data/santiago/osm/osm_santiago_buildings.shp'
sql_out = 'fp2rem.sql'
source = 'OSM'
survey_name='santiago2017'

#create a table with the shapefile layer containing postgis geometry
cmd = "shp2pgsql -s 4326 -W LATIN1 -g the_geom {} temporary_footprint_data > {}".format(shapefile,sql_out)
os.system(cmd)

#write inserts in ve_objects for each row in sql_out
query="INSERT INTO asset.ve_object (survey_gid, source, the_geom, mat_type, mat_tech, mat_prop, llrs, llrs_duct, height, height2, yr_built, occupy, occupy_dt, position, plan_shape, str_irreg, str_irreg_dt, str_irreg_type,str_irreg_2,str_irreg_dt_2,str_irreg_type_2, nonstrcexw, roof_shape, roofcovmat, roofsysmat, roofsystyp, roof_conn, floor_mat, floor_type, floor_conn, foundn_sys, vuln,rrvs_status,height_1,height2_1,year_1) SELECT survey.survey.gid,'{}',temporary_footprint_data.the_geom,'MAT99','MATT99', 'MO99', 'L99', 'DU99', 'H99', 'HB99','Y99', 'OC99', 'OCCDT99','BP99','PLF99','IR99', 'IRP99', 'IRT99','IRRE','IRPS','IRN','EW99','R99', 'RMT99', 'RSM99', 'RST99', 'RCN99', 'F99', 'FT99', 'FWC99', 'FOS99','V99','UNMODIFIED', 99, 99, 99 FROM temporary_footprint_data,survey.survey WHERE survey.survey.name='{}' AND temporary_footprint_data.building NOT LIKE '';".format(source,survey_name)

with open(sql_out,'a') as f:
    f.write(query)
    query = "DROP TABLE temporary_footprint_data"
    f.write(query)
