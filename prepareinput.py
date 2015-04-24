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

TODO: This is a rather static solution with writing to files.
      Ask for building_gid string on start of the application and make it available to the map
      -> than dynamically populate the geojson variables in map.html with the below queries
      -> dont write to file but directly to the variable in the map file (like I did before with php!)
----
'''
import os 
import psycopg2
import numpy as np

# Input parameters#################################################################################################
db_connect = "host=localhost dbname=rrvstool_v01 user=postgres password=postgres"    # database connection string
building_gid = '1743, 1744, 1745' # string list with the gids of buildings to be surveyed
###################################################################################################################

# connect to database
try:
    conn=psycopg2.connect(db_connect)
    conn.autocommit = True
except:
    print 'not able to connect to database'
cur = conn.cursor()

#create geojson file from buildings selection
cur.execute("DROP TABLE IF EXISTS panoimg.geojson;")
cur.execute("SELECT * INTO panoimg.geojson FROM (" +
                "SELECT row_to_json(fc) " +
                    "FROM (SELECT 'FeatureCollection' AS type, array_to_json(array_agg(f)) AS features " +
                    "FROM (SELECT 'Feature' AS type, ST_AsGeoJSON(lg.the_geom)::json AS geometry, " +
                        "row_to_json((SELECT l FROM (SELECT gid) AS l)) AS properties " +
                            "FROM object_res1.ve_resolution1 AS lg) AS f)  AS fc " +
             ") a;")
#TODO: define path relative to application in flask!
cur.execute("COPY panoimg.geojson TO '/webapp/static/panoimg/buildings.js' USING DELIMITERS ';';")
#TODO: add "var buildings = " at the beginning of the json string

#select gps points within radius of 50m (ca 0.0005 degrees) of selected buildings
cur.execute("SELECT a.gid FROM " +
                "panoimg.gps a, " + 
                "(SELECT st_buffer(the_geom, 0.0005) as buffer_geom FROM object_res1.ve_resolution1 " + 
                    "WHERE gid IN (1743, 1744, 1745)) b " +
                "WHERE st_intersects(a.the_geom, b.buffer_geom) GROUP BY a.gid;")
rows = cur.fetchall()
h = np.asarray(rows)
gps_gid = ""
for i in range(len(h)):
    gps_gid += str(h[i])[:-2].replace('[\'', '') + ','
gps_gid = gps_gid[:-1]
print gps_gid

#create geojson file from gps points selection
cur.execute("DROP TABLE IF EXISTS panoimg.geojson;")
cur.execute("SELECT * INTO panoimg.geojson FROM (" +
                "SELECT row_to_json(fc) " +
                    "FROM (SELECT 'FeatureCollection' AS type, array_to_json(array_agg(f)) AS features " +
                    "FROM (SELECT 'Feature' AS type, ST_AsGeoJSON(lg.the_geom)::json AS geometry, " + 
                        "row_to_json((SELECT l FROM (SELECT img_id, azimuth) AS l)) AS properties " +
                            "FROM panoimg.gps AS lg where gid in (" + gps_gid + ") AS f)  AS fc " +
             ") a;")
#TODO: define path relative to application in flask!
cur.execute("COPY panoimg.geojson TO '/webapp/static/panoimg/gps.js' USING DELIMITERS ';';")
#TODO: add "var gps = " at the beginning of the json string

# Close database connection
cur.close()
conn.close()