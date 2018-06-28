####################################################
# Script that extracts all images as jpg of all MP4
# files in a directory using OpenCV.
# also write as many .csv files as the number of .pgr
# sequences, containing a set of attributes for each
# extracted frame.
#
# Last modified: 01.06.2018
# Author: M.Haas
# Contact: mhaas@gfz-potsdam.de
####################################################

import argparse
import glob
import os
import subprocess
import csv
import datetime
import multiprocessing
import cv2
import pyexiftool


#command line functionality
parser = argparse.ArgumentParser()
parser.add_argument('-i','--in_dir',type=str,help='directory containing the mp4 files to be processed',required=True)
parser.add_argument('-c','--config',type=str,help='Name of the config file containing information about the survey, see config.ini ',required=True)
parser.add_argument('-f','--fit_dir',type=str,help='directory containing the fit files (GMatrix) to be processed',required=True)
parser.add_argument('-o','--out_dir',type=str,help='directory to store the images and the csv',required=True)
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

def nearest(items, pivot):
    return min(items, key=lambda x: abs(x - pivot))

#TODO: rename stype,itype in the end in csv

error = 'Unspecified error'
try:
    #Check if input dir exists
    try:
        1/os.path.exists(args.in_dir)
    except:
        error = 'Input directory: {} does not exist.'.format(args.in_dir)
        raise Exception

    #Find files
    try:
        mp4_files = [f for f in glob.glob(args.in_dir+'/*.MP4')]
        mp4_files.sort()
        nr_files = len(mp4_files)
        1/(nr_files > 0)
    except:
        error = 'Could not find any MP4 files in: {}'.format(args.in_dir)
        raise Exception

    #Create output dir if it does not exist
    if not os.path.exists(args.out_dir):
        try:
            os.mkdir(args.out_dir)
        except:
            error = 'Creating directory: {} failed'.format(args.out_dir)
            raise Exception

    #determine if stream splitted in several files
    try:
        unique_streams = [s.split('-')[-2][-6:] for s in mp4_files]
        unique_streams = set(unique_streams)
    except:
        error = 'Could not determine unique streams'
        raise Exception

    #gather config content
    try:
        config={}
        with open(args.config,'rb') as f:
            reader = csv.reader(f,delimiter=';',skipinitialspace=True)
            for row in reader:
                config[row[0]] =[row[1],row[2]]
    except:
        error = 'Could not read config: {}'.format(args.config)
        raise Exception


    #Inform user on selection
    print 'Found {} streams in directory {}.'.format(len(mp4_files),args.in_dir)

    #if this is a rerun extract only those streams which are not already there
    #determine if present all extracted images for each unique stream
    test = list(unique_streams)
    unique_streams=[]
    for stream_id in test:
        try:
            img_files = [f for f in glob.glob(args.out_dir+'/*.jpg')]
            img_files = [f for f in img_files if stream_id in f]
            img_files.sort()
            nr_files = len(img_files)
        except:
            print 'Could not determine number of created images for stream_id {}'.format(stream_id)

    #Get creation date of file to associate GMatrix
    mp4_creation_dates=[]
    with pyexiftool.ExifTool() as et:
        metadata = et.get_metadata_batch(mp4_files)
    for d in metadata:
        mp4_creation_dates.append(d[[k for k in d.keys() if 'CreateDate' in k][0]])

    #Find corresponding GMatrix files
    try:
        fit_files = [f for f in glob.glob(args.fit_dir+'/*.fit')]
        fit_files.sort()
        nr_files = len(fit_files)
        1/(nr_files > 0)
    except:
        error = 'Could not find any fit files in: {}'.format(args.fit_dir)
        raise Exception

    #get fit file times
    fit_times = [datetime.datetime.strptime(f.split('/')[-1][:-4],'%Y-%m-%d-%H-%M-%S') for f in fit_files]
    mp4_times = [datetime.datetime.strptime(f,'%Y:%m:%d %H:%M:%S') for f in mp4_creation_dates]

#write same file as metadata.py --> can be converted with sql.py to an sql file
#go through all locations and create metadata
#fname = 'V0280048.MP4'
#fitfile ='2018-06-01-12-13-33.fit'

#parse metadata
fields_to_extract=['timestamp','enhanced_altitude','enhanced_speed','utc_timestamp','timestamp_ms','heading','velocity']
fields_to_convert=['position_lat','position_long']
meta = {}
for key in fields_to_extract+fields_to_convert:
for idx,fname in enumerate(mp4_files):
    #extract frames from mp4 file
    try:
        vidcap = cv2.VideoCapture(fname)
        success,image = vidcap.read()
        success
        count = 0
        if success:
            stream = fname.split('.')[-2]
            os.mkdir(stream)
            while success:
              cv2.imwrite("{}/{}_frame{}.jpg".format(stream,stream,count), image)     # save frame as JPEG file
              success,image = vidcap.read()
              print('Read a new frame: ', success)
              count += 1

    #get metadata
    fit_file = [fit_files[i for i,t in enumerate(fit_times) if t==nearest(fit_times,mp4_times[idx])]][0]


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

        #TODO: Fix this in later version since this requires using LadyCapPro
        #use this number to determine correct frame_info file
        #frame_info_file = '{}/ladybug_frame_gps_info_{}.txt'.format(basepath,nr_files)

        #check if the images are complete,i.e. a frameinfo file exists with this content
        if os.path.isfile(frame_info_file):
            #exclude the stream_id if thats the case
            print 'Stream with id {} is already extracted at {} skipping it.'.format(stream_id,args.out_dir)
        else:
            unique_streams.append(stream_id)

    #clean pgr files
    pgr_files = [f for f in pgr_files if f.split('-')[-2][-6:] in unique_streams]

    #Inform user on selection
    print 'Processing {} streams in directory {}. Saving results at {}'.format(len(pgr_files),args.in_dir,args.out_dir)

    for f in pgr_files:
        #extract images from pgr
        try:
            print 'Processing stream {}'.format(f.split('-')[-2])
            program = os.getcwd()+'\\process_stream\\Debug\\process_stream.exe'
            gpsout_filename = f.split('\\')[-1][:-11]
            print gpsout_filename
            # with "-p true" extract only gps info frames
            # otherwise extract gps info frames and images
            cmd='{} -i {} -o {}\\img -p false -g {}\\img_{} -w {}x{}'.format(program,f,args.out_dir,args.out_dir,gpsout_filename,config['width'][1],config['height'][1])
            os.system(cmd)
            #print cmd

        except:
            error = 'Extracting stream frames failed.'
            raise Exception
except:
    print error
    raise RuntimeError
else:
    print 'Extraction finished.'
