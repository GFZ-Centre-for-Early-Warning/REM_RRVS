# Script that generates image metadata similar to Permanent
# for a generic set of geocoded imagery within a single directory
# GPS data is read from the imagery
# provides metadata.csv for the RRVS system which can be parsed by the sql generator

import subprocess
import os
import csv
import argparse
import glob
import pyexiftool

###########################
#PARAMETERS
###########################
#in_shp='/home/mhaas/PhD/InternationalTrainingCourse/2017/basel_streets.shp'
#directory of images
#img_dir='/home/mhaas/PhD/field_surveys/Rieti_2016/Norcia360/'
#image suffix
#itype= 'JPG'
#osm=True
#epsg=4326
#spacing = 0.0001

############################

#command line functionality
parser = argparse.ArgumentParser()
parser.add_argument('-c','--config',type=str,help='Name of the config file containing information about the survey, see config.ini ',required=True)
parser.add_argument('-i','--imgdir',type=str,help='Directory containing geocoded images',required=True)
parser.add_argument('-e','--extension',type=str,help='Extension of the files e.g. "JPG"',required=True)
args = parser.parse_args()

#gather config content
def get_config(in_config):
    #gather config content
    #todo: sub in_config with args.config
    try:
        config={}
        with open(in_config,'rb') as f:
            reader = csv.reader(f,delimiter=';',skipinitialspace=True)
            for row in reader:
                config[row[1]]=[row[2]]
    except:
        print 'Could not read config: {}'.format(in_config)
    return config

config=get_config(args.config)


#create a dictionary that keeps all metadata for the survey
meta = {}
#initialize all keys defined in config
for key in config.keys():
    meta[key]=[]
#initialize additional keys
meta['FileName']=[]
meta['Repository']=[]
meta['FrameId']=[]
meta['PoseHeadingDegrees']=[]
meta['FirstPhotoDate']=[]
meta['GPSAltitude']=[]
meta['GPSAzimuth']=[]
meta['GPSSpeed']=[]
meta['GPSSpeedRef']=[]
meta['GPSLatitude']=[]
meta['GPSLongitude']=[]

#############################################
# Gather images in directory and extract gps
#############################################

#Find img files
try:
    img_files = [f for f in glob.glob(args.imgdir+'/*.'+args.extension)]
    img_files.sort()
    nr_files = len(img_files)
    1/(nr_files > 0)
except:
    error = 'Could not find any {} files in: {}'.format(args.extension,args.imgdir)
    raise Exception

#gather metadata as stored in geocoded images
with pyexiftool.ExifTool() as et:
    metadata = et.get_metadata_batch(img_files)

########################################
# Metadata creation
########################################

#write same file as metadata.py --> can be converted with sql.py to an sql file
#go through all locations and create metadata
for i,d in enumerate(metadata):
    try:
        #only keep the ones that are geocoded
        meta['GPSLatitude'].append(d[[k for k in d.keys() if 'GPSLatitude' in k][0]])
        meta['GPSLongitude'].append(d[[k for k in d.keys() if 'GPSLongitude' in k][0]])
        #trial and error assignments
        try:
            meta['GPSAltitude'].append(d[[k for k in d.keys() if 'GPSAltitude' in k][0]])
        except:
            meta['GPSAltitude'].append(0.)
        try:
            meta['GPSAzimuth'].append(d[[k for k in d.keys() if 'GPSImgDirection' in k][0]])
        except:
            meta['GPSAzimuth'].append(0.)

        try:
            meta['GPSSpeed'].append(d[[k for k in d.keys() if 'GPSSpeed' in k][0]])
            meta['GPSSpeedRef'].append(d[[k for k in d.keys() if 'GPSSpeedRef' in k][0]])
        except:
            meta['GPSSpeed'].append(0)
            meta['GPSSpeedRef'].append(0)

        try:
            meta['PoseHeadingDegrees'].append(d[[k for k in d.keys() if 'PoseHeadingDegrees' in k][0]])
        except:
            meta['PoseHeadingDegrees'].append(0)

        meta['FirstPhotoDate'].append(d[[k for k in d.keys() if 'GPSDateStamp' in k][0]])
        meta['FileName'].append(d[[k for k in d.keys() if 'FileName' in k][0]])
        #set the values defined in the config
        meta['FrameId'].append(i)
        meta['Repository'].append(config["SurveyName"])
        for key in config.keys():
            #try to get from image if not use the one in config
            try:
                meta[key].append(d[[k for k in d.keys() if key in k][0]])
            except:
                meta[key].append(config[key][0])
    except:
        print 'WARNING: image {} not geocoded! SKIPPING {}'.format(i,d[[k for k in d.keys() if 'FileName' in k][0]])

with open('imetadata.csv','w') as f:
    fieldnames = list(meta.keys())
    fieldnames.sort()
    writer = csv.DictWriter(f,fieldnames=fieldnames)
    writer.writeheader()
    for i in range(len(meta['GPSLatitude'])):
        row={}
        for key in fieldnames:
            row[key] = meta[key][i]
        writer.writerow(row)
