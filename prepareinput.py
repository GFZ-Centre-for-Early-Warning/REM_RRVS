'''
-----------------------------------------------------------------------------
    Prepare input files for RRVS survey 
-----------------------------------------------------------------------------                         
Created on 24.04.2015
Last modified on 24.04.2015
Author: Marc Wieland
Description: this script produces the gps.js and buildings.js files for a specific application 
			 based on user selection of buildings to be surveyed.
Input: gids of buildings that need to be surveyed
Output: gps.js and buildings.js in /webapp/static/panoimg
----
'''
import psycopg2

# Input parameters#################################################################################################
db_connect = "host=localhost dbname=rrvstool_v01 user=postgres password=postgres"    # database connection string
building_table = 'object_res1.ve_resolution1' # table that holds all the buildings
gps_table = 'panoimg.gps' # table that holds the gps points
###################################################################################################################

starttime=time.time()
print 'Starttime : ' + str(time.strftime("%H:%M:%S"))

# connect to database
try:
    conn=psycopg2.connect(db_connect)
    conn.autocommit = True
except:
    print 'not able to connect to database'
cur = conn.cursor()

###############################################################################
# Main procedure
###############################################################################    

#select buildings

#select gps points within radius of selected buildings

#create geojson file from gps table for map
#TODO: add "var gps = " at the beginning of the json string
drop table if exists panoimg.geojson;
select * into panoimg.geojson from (
SELECT row_to_json(fc)
		 FROM (SELECT 'FeatureCollection' AS type, array_to_json(array_agg(f)) AS features
		 FROM (SELECT 'Feature' AS type, ST_AsGeoJSON(lg.the_geom)::json AS geometry, 
			row_to_json((SELECT l FROM (SELECT img_id, azimuth) AS l)) AS properties
			  FROM panoimg.gps AS lg) AS f)  AS fc
) a;
COPY panoimg.geojson TO '/home/marc/Public/gps.js' USING DELIMITERS ';';

#create geojson file from gps table for map
#TODO: add "var buildings = " at the beginning of the json string
drop table if exists panoimg.geojson;
select * into panoimg.geojson from (
SELECT row_to_json(fc)
		 FROM (SELECT 'FeatureCollection' AS type, array_to_json(array_agg(f)) AS features
		 FROM (SELECT 'Feature' AS type, ST_AsGeoJSON(lg.the_geom)::json AS geometry, 
			row_to_json((SELECT l FROM (SELECT gid) AS l)) AS properties
			  FROM object_res1.ve_resolution1 AS lg) AS f)  AS fc
) a;
COPY panoimg.geojson TO '/home/marc/Public/buildings.js' USING DELIMITERS ';';


###############################################################################
# Program end
###############################################################################    

# Close database connection
cur.close()
conn.close()