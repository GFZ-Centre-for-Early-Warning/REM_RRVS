# Script that generates a GRVS image dataset from a provided street network
# It writes most of the metadata similar to Permanent
# Requires postgis
import postgresql_module as sql
import subprocess
import os
import csv
import argparse

###########################
#PARAMETERS
###########################
in_shp='/home/mhaas/PhD/InternationalTrainingCourse/2017/basel_streets.shp'
osm=True
epsg=4326
spacing = 0.0001

user = 'user'
password = 'password'
host = 'host'
dbname = 'streets2rem'
###########################

#command line functionality
parser = argparse.ArgumentParser()
parser.add_argument('-c','--config',type=str,help='Name of the config file containing information about the survey, see config.ini ',required=True)
args = parser.parse_args()

#gather config content
config={}
with open(args.config,'rb') as f:
    reader = csv.reader(f,delimiter=';',skipinitialspace=True)
    for row in reader:
        config[row[0]] =[row[1],row[2]]

#create a dictionary that keeps all metadata for the survey
meta = {}
#initialize all keys defined in config
for key in config.keys():
    meta[key]=[]
#initialize additional keys
meta['filename']=[]
meta['repository']=[]
meta['frame_id']=[]
meta['poseheadingdegrees']=[]
meta['firstphotodate']=[]
meta['altitude']=[]
meta['azimuth']=[]
meta['abspeed']=[]
meta['lat']=[]
meta['lon']=[]


###################################################
# Generate fake image locations from street network
###################################################
create = 'user={} password={} host={}'.format(user,password,host)
conn = 'user={} password={} host={} dbname={}'.format(user,password,host,dbname)
#TODO: in grvs reinclude imgAzimuth --> just set it to 0 (North) for google panos

#create the database
postgres = sql.postgresql(create)
cmd = 'DROP DATABASE IF EXISTS {};'.format(dbname)
print cmd
res = postgres.execute(cmd)

cmd = 'CREATE DATABASE {};'.format(dbname)
print cmd
res = postgres.execute(cmd)
postgres.close()

#open connection add postgis
postgres = sql.postgresql(conn)
cmd = 'CREATE EXTENSION postgis;'
print cmd
res = postgres.execute(cmd)

#read streetnetwork
cmd = 'shp2pgsql -s {}:4326 -W "latin1" {} ways > ways.sql'.format(epsg, in_shp)
print cmd
os.system(cmd)
#os.environ['PGPASSWORD']=password

#cmd = 'psql --u {} --host {} --d {} -f ways.sql'.format(user,host,dbname)
#print cmd
#os.system(cmd)
postgres.execute(open("ways.sql","r").read())

#clean if osm line source (contains also other types of lines like admin, water etc.)
if osm:
    cmds=["DELETE FROM ways WHERE other_tags LIKE '%admin%';",
        "DELETE FROM ways WHERE waterway <> '';",
        "DELETE FROM ways WHERE barrier <> '';",
        "DELETE FROM ways WHERE other_tags LIKE '%bicycle%';",
        "DELETE FROM ways WHERE other_tags LIKE '%Trail%';",
        "DELETE FROM ways WHERE other_tags LIKE '%foot%';",
        "DELETE FROM ways WHERE other_tags LIKE '%seamark%';",
        "DELETE FROM ways WHERE highway LIKE '%footway%';",
        "DELETE FROM ways WHERE highway LIKE '%pedestrian%';",
        "DELETE FROM ways WHERE highway LIKE '%track%';",
        "DELETE FROM ways WHERE highway LIKE '%path%';",
        "DELETE FROM ways WHERE man_made LIKE '%pier%';",
        "DELETE FROM ways WHERE other_tags LIKE '%natural%';",
        "DELETE FROM ways WHERE other_tags LIKE '%ferry%';",
        "DELETE FROM ways WHERE other_tags LIKE '%boat%';",
        "DELETE FROM ways WHERE other_tags LIKE '%maritime%';",
        "DELETE FROM ways WHERE other_tags LIKE '%aeroway%';",
        "DELETE FROM ways WHERE other_tags LIKE '%Military%';"]
    for cmd in cmds:
        print cmd
        res = postgres.execute(cmd)

#convert lines to evenly spaced points
#check if exists
cmd = "select exists(select relname from pg_class where relname='img')"
res = postgres.execute(cmd)
#drop it if it exists
if res[0][0]:
    cmd = 'DROP TABLE img;'
    print cmd
    res = postgres.execute(cmd)
#create a new table with the points
cmd = 'CREATE TABLE img AS (SELECT ST_PointN( way, generate_series(1, ST_NPoints(way))) as geom FROM ( SELECT ST_segmentize((ST_Dump(geom)).geom::geometry,{}) AS way FROM ways) AS dumped);'.format(spacing)
print cmd
res = postgres.execute(cmd)
#gather data
cmd = 'SELECT ST_X(geom),ST_Y(geom) FROM img;'
print cmd
res = postgres.execute(cmd)

postgres.close()

########################################
# Metadata creation
########################################

#write same file as metadata.py --> can be converted with sql.py to an sql file
#go through all locations and create metadata
for i,f in enumerate(res):
    #set the values defined in the config
    for key in config.keys():
        meta[key].append(config[key][1])
    #append other values
    meta['filename'].append(i)
    meta['repository'].append('Google Streetview')
    meta['frame_id'].append(i)
    meta['poseheadingdegrees'].append(0)
    meta['firstphotodate'].append(0)
    meta['altitude'].append(0)
    meta['azimuth'].append(0)
    meta['abspeed'].append(0)
    meta['lat'].append(f[1])
    meta['lon'].append(f[0])

with open('gmetadata.csv','w') as f:
    fieldnames = list(meta.keys())
    fieldnames.sort()
    writer = csv.DictWriter(f,fieldnames=fieldnames)
    writer.writeheader()
    for i in range(len(meta['lat'])):
        row={}
        for key in fieldnames:
            row[key] = meta[key][i]
        writer.writerow(row)
