
# coding: utf-8

####################################################
# Script that either:
# a) generate a metadata.csv based on config file and input gps infoframefiles, or
# b) update a set of images based on the input metadata (.csv) file, using exiftool
#
# Last modified: 07.10.2016
# Author: M.Pittore, M. Haas
# Contact: pittore@gfz-potsdam.de
# 
####################################################

import argparse
import os
import sys
import csv
from geographiclib.geodesic import Geodesic
from scipy.interpolate import UnivariateSpline
import glob
import pandas as pd
import re
import datetime

def parse_args(argv):
    try:
        #command line functionality
        parser = argparse.ArgumentParser()
        parser.add_argument('-m','--mode',type=str,help="""
        operating mode:
        'gen-meta' only generates the metadata files;
        'update-meta' accepts a metadata file and updates images´ metadata;""",required=True)
        parser.add_argument('-d','--deltafile',type=str,help="""
        Optional camera delta file usually created by camDelta.py in directory 
        containing the original pgr files, if not provided no deviation between 
        camera-car-heading is assumed""",required=False)
        parser.add_argument('-f','--metafile',type=str,help="""
        metadata file to be processed to update images´ metadata.
        (required if mode='update-meta')""",required=False)
        parser.add_argument('-c','--configfile',type=str,help="""
        Name of the config file containing information about the survey, 
        see config.ini.
        (required if mode='gen-meta')""",required=False)
        parser.add_argument('-i','--dir_gps',type=str,help="""
        directory where the gps_infoframe files are stored.
        (required if mode='gen-meta')""",required=False)
        parser.add_argument('-o','--out_dir',type=str,help="""
        directory where the metadata will be written to.
        (required if mode='gen-meta')""",required=False)
        parser.add_argument('-g','--dir_img',type=str,help="""
        directory where the extracted frames are stored (.jpg).
        (required if mode='update-meta')""",required=False)    
        args = parser.parse_args(argv)
        return args
    except:
        print 'could not parse arguments.'
        return 


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

def get_gpsinfoframefiles(in_dir):
    #get all frame info files in the specified folder
    try:
        gpsfiles = [f for f in glob.glob(in_dir+'/*.csv')]
        gpsfiles.sort()
        nr_gpsfiles = len(gpsfiles)
        1/(nr_gpsfiles > 0)
    except:
        print 'Could not find any gps (.csv) files in: {}'.format(in_dir)
        raise Exception
    return gpsfiles

def get_imgfiles(in_dir):
    #get all extracted image files in the specified folder
    try:
        imgfiles = [f for f in glob.glob(in_dir_img+'/*.jpg')]
        imgfiles.sort()
        nr_imgfiles = len(imgfiles)
        1/(nr_imgfiles > 0)
    except:
        print 'Could not find any jpg files in: {}'.format(in_dir_img)
        raise Exception
    return imgfiles

def get_deltainfo(in_delta,unique_streams=[]):
    #Gather delta.csv content
    delta = {}
    if unique_streams:
        for key in unique_streams:
            delta[key] = 0.
    try:
        with open(in_delta,'rb') as f:
            reader = csv.reader(f,delimiter=',')
            next(reader,None)
            for row in reader:
                delta[row[0]] = float(row[1])
        print 'Using {} as camera-car heading delta...'.format(in_delta)
    except:
        print 'Warning: Provided no delta.csv file, as can be created by createCamDelta.py.\nAssuming no deviation between car and camera heading.'

    #if unique streams have been provided, check consistency
    if unique_streams:
        if len(delta.keys())!=len(unique_streams):
            print 'Found a delta.csv file in {}. But its length does not correspond to the number of streams found in the directory.'.format(in_delta)
            raise Exception  

    return delta

def get_seqname(filename):
    m = re.search('_[0-9]+_[0-9]+.csv$',filename)
    seq_name = filename[:-len(m.group())].split(os.sep)[-1]
    return seq_name

def unique_streams_fromimages(imgfiles):
    #determine unique streams from the set of image files
    #the filenames always terminate with a 6 digit number _******.jpg
    try:
        unique_streams = [s[:-11].split(os.sep)[-1] for s in imgfiles]
        unique_streams = set(unique_streams)
    except:
        print 'Could not determine unique streams'
        raise Exception
    return unique_streams

def unique_streams_fromgpsfiles(gpsfiles):
    #determine unique streams from the set of image files
    #the filenames always terminate with a 6 digit number _******.jpg
    try:
        streams=[get_seqname(s) for s in gpsfiles]
        unique_streams = set(streams)
    except:
        print 'Could not determine unique streams'
        raise Exception
    return unique_streams


#############################
# interpolate lat lon, altitude and time using the defined GPS epoch
# using a degree 3 spline
#############################   

def interpolate_coords(df):
    #get approximate time using first gps time available and from there on camera clock
    #camera first cycle sec
    cam_t0 = float(df['TSCycleSeconds'][0])
    #indices of all non zero gps times
    idx_non_zero_gps = [i for i,t in enumerate(df['bValidGPS']) if t]
    cycle_sec=[int(cs) for cs in df['TSCycleSeconds']]
    #since these are cycles with 128 seconds convert to monoton sequence
    cam_sec = []
    init=0
    for cs in cycle_sec:
        if init==0:
            init = 1
            old = cs
            cam_sec.append(0)
        dt = cs-old
        if dt < 0: 
            dt = dt+128
        old = cs
        cam_sec.append(cam_sec[-1]+dt)
    #remove first element added for calculation
    cam_sec=cam_sec[1:]

    #determine fractions of a second (later converted to microseconds) via cycle count of camera (8000 Hz)
    cam_cycles = [float(c)/8000.0 for c in df['TSCycleCount']]
    cam_time = [sum(x) for x in zip(cam_sec, cam_cycles)]
    delta_t = [t1-t2 for t1,t2 in zip(cam_time[1:],cam_time[:-1])]
    #interpolate gps using cam_time
    #get first index of image sequences with same gps time
    #in order to avoid multiple datapoints with same info
    idx_interp = []
    gps_time = []
    for i,t in enumerate(df['TSSeconds']):
        if t not in gps_time and df['bValidGPS'][i]:
            gps_time.append(t)
            idx_interp.append(i)   
    #time used for polynomial fit     
    itime = [t for i,t in enumerate(cam_time) if i in idx_interp]
    #gps data used for polynomial fit 
    gps_lat = [float(s) for i,s in enumerate(df['GGALatitude']) if i in idx_interp]
    gps_lon = [float(s) for i,s in enumerate(df['GGALongitude']) if i in idx_interp]
    gps_alt = [float(s) for i,s in enumerate(df['GGAAltitude']) if i in idx_interp]
    gps_time2= [float(s) for i,s in enumerate(gps_time)]
    
    #polynomyial
    s_lat = UnivariateSpline(x=itime, y=gps_lat,s=0,k=3)
    s_lon = UnivariateSpline(x=itime, y=gps_lon,s=0,k=3)
    s_alt = UnivariateSpline(x=itime, y=gps_alt,s=0,k=3)
    s_time = UnivariateSpline(x=itime, y=gps_time2,s=0,k=3)

    #get interpolated values
    lat = [float(s_lat(t)) for t in cam_time]
    lon = [float(s_lon(t)) for t in cam_time]
    altitude = [float(s_alt(t)) for t in cam_time]
    intime = [float(s_time(t)) for t in cam_time]
    
    #calculate gps speed for coordinate point pairs
    pairs = list(zip(lat,lon))
    geo = [Geodesic.WGS84.Inverse(p1[0],p1[1],p2[0],p2[1]) for p1,p2 in zip(pairs[:-1],pairs[1:])]
    vel = [g['s12']/float(dt)*3.6 for g,dt in zip(geo,delta_t)]

    #storing velocities assuming first image was taken at same speed as second
    abspeed = [vel[0]] + vel 
    #azimuth for coordinate point pairs
    azi = [g['azi1'] for g in geo]
    #storing azimuth assuming last image has same azimuth as second last 
    azimuth = azi + [azi[-1]]
    #create utc time line starting with first gps time (unfortunately no delay info available, and only 1Hz)
    #first non zero gps time
    #timeformat = '%Y-%m-%d %H:%M:%S'
    #gps_t = df['TSSeconds'][idx_non_zero_gps]
    #utctimestamp = [datetime.datetime.utcfromtimestamp(t).strftime(timeformat) for t in gps_t]
    
    return lat, lon, altitude, abspeed, azimuth, intime


#############################
#attach metadata to jpg files according to metadata 
#############################   

def update_metadata(metadata,in_dir_img):
    fieldnames = list(metadata.keys())
    fieldnames.sort()
    #append the exiftool location (i.e. current folder) to the os.path
    os.environ['PATH'] += os.pathsep + os.getcwd() 
    
    #iterate over images in the metadata dictionary
    for i in range(len(metadata['FileName'])):
        image_filename=metadata['FileName'][i]
        imgpath = os.path.join(in_dir_img,image_filename)
        if not os.path.isfile(imgpath):
            print 'file {} not found.',format(imgpath)
        else:
            #init command
            #exiftool base command (check OS version: exiftool.exe is for Windows OS)
            cmd = 'exiftool.exe -config gfz.ns -overwrite_original'
            for key in fieldnames:
                cmd = cmd + ' -{}="{}"'.format(key,metadata[key][i])
            cmd = cmd + ' {}'.format(imgpath)
            os.system(cmd)

#############################
# generate asingle csv containing metadata + filename
############################ #   

def generate_metadata(df,config,in_dir_img):
    #create a dictionary that keeps all metadata for the sequence
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

    #iterate over images in the frame-info file
    for i, image in df.iterrows():
        #check that the image exists (has been extracted)
        image_filename = image['seqName']+'_{:06d}.jpg'.format(image['frameID'])
        imgpath = os.path.join(in_dir_img,image_filename)
        if not os.path.isfile(imgpath):
            print 'file {} not found.',format(imgpath)
        else:
            #append base meta provided by config file
            for key in config.keys():
                meta[key].append(config[key][0])
            #append other values
            meta['FileName'].append(image_filename)
            meta['Repository'].append(in_dir_img)
            meta['FrameId'].append(image['frameID'])
            real_azimuth = image['iAzimuth']#+delta[stream_id]
            meta['PoseHeadingDegrees'].append(real_azimuth)
            meta['FirstPhotoDate'].append(image['UTCTimeStamp'])
            meta['GPSAltitude'].append(image['iAlt'])
            meta['GPSAzimuth'].append(image['iAzimuth'])
            meta['GPSSpeed'].append(image['iAbsVel'])
            meta['GPSSpeedRef'].append('km/h')
            meta['GPSLatitude'].append(image['iLat'])
            meta['GPSLongitude'].append(image['iLon'])

    return meta


#append meta2 keys to meta1 
def append_metadata(meta1,meta2):
    meta1keys = meta1.keys()
    meta2keys = meta2.keys()
    #if empty init meta1
    if not meta1keys:
        for k in meta2keys:
            meta1[k] = []
    for k in meta2keys:
        for i,val in enumerate(meta2[k]):
            meta1[k].append(val)
    return meta1

def save_metadata(metadata,out_dir,filename='metadata.csv'):
    with open(os.path.join(out_dir,filename),'wb') as f:
        fieldnames = list(metadata.keys())
        fieldnames.sort()
        writer = csv.DictWriter(f,fieldnames=fieldnames)
        writer.writeheader()
        for i in range(len(metadata[fieldnames[0]])):
            row={}
            for key in fieldnames:
                row[key] = metadata[key][i]
            writer.writerow(row)

def load_metadata(in_meta):
    meta = {}
    with open(in_meta,'r') as f:
        metareader = csv.DictReader(f)
        fieldnames = metareader.fieldnames
        #init keys
        for key in fieldnames:
            meta[key] = []
            #populate keys
        try:
            for row in metareader:
                for key in fieldnames:
                    meta[key].append(row[key]) 
        except csv.Error as e:
            sys.exit('file {}, line {}: {}'.format(in_meta, metareader.line_num, e))
    return meta



def main(argv):
    
    # init folders - DEBUG ONLY - under LINUX
    in_dir_gps = '/home/max/Desktop/Documents/GFZ_sync/ACTIVITIES/RRVS/new_version/gps_tmp'
    in_dir_img = '/home/max/Desktop/Documents/GFZ_sync/ACTIVITIES/RRVS/new_version/test_images'
    out_dir = '/home/max/Desktop/Documents/GFZ_sync/ACTIVITIES/RRVS/new_version'
    in_config = '/home/max/Desktop/Documents/GFZ_sync/ACTIVITIES/RRVS/new_version/permanent-dev/config-rieti.ini'
    in_delta = ''
    
    opMode = 'update-meta'
    
    args = parse_args(argv)
    
    if args:
        opMode = args.mode
        in_dir_gps = args.dir_gps
        in_delta = args.deltafile
        in_config = args.configfile
        in_dir_img = args.dir_img
        out_dir = args.out_dir
        in_meta = args.metafile
    else:
        print 'use default parameters'

    if opMode=='gen-meta':
        
        print """generating metadata.
        Delta file:{}
        Config file: {}
        Input gps folder: {}
        Images folder: {}
        Output folder: {} """.format(in_delta,in_config,in_dir_gps,in_dir_img,out_dir)
        
        config = get_config(in_config)
        gpsfiles = get_gpsinfoframefiles(in_dir_gps)
        unique_streams = unique_streams_fromgpsfiles(gpsfiles)
        delta = get_deltainfo(in_delta,unique_streams)
        #read all gps info frames (in csv format) and generate a single csv file
        df_all = pd.DataFrame()
        meta_all = {}
        for s in gpsfiles:
            #extract sequence name from gpsframe-info files
            seq_name = get_seqname(s)
            print 'processing {} ...'.format(seq_name)
            #load sequence data
            df = pd.read_csv(s)
            #interpolate coordinates
            lat, lon, altitude, abspeed, azimuth, itime = interpolate_coords(df)
            #populate dataframe with interpolated data
            df['iLat'] = lat
            df['iLon'] = lon
            df['iAlt'] = altitude
            df['iAbsVel'] = abspeed
            df['iAzimuth'] = azimuth
            #add sequence name
            df['seqName'] = seq_name
            #add utc timestamp from internal clock (ieee1394)
            timeformat = '%Y-%m-%d %H:%M:%S'
            intime = [int(t) for t in itime]
            #gps_t = [t for i,t in df['TSSeconds'] where df['bValidGPS'][i]]
            utctimestamp = [datetime.datetime.utcfromtimestamp(t).strftime(timeformat) for t in intime]
            df['UTCTimeStamp'] = utctimestamp

            #generate metadata for the extracted images. 
            seq_meta = generate_metadata(df,config,in_dir_img)
            save_metadata(seq_meta,out_dir,seq_name+'_metadata.csv')

            #append metadata to global one ?
            append_metadata(meta_all,seq_meta)

            #append dataframe to the global one
            if (not df_all.empty):
                df_all = df_all.append(df)
            else:
                df_all = df

        #save the global dataframe and global metadata as a csv files
        print 'saving global datasets and metadata...'
        df_all = df_all.set_index(['frameID'])       
        df_all.to_csv(os.path.join(out_dir,'test_all.csv'))
        save_metadata(meta_all,out_dir,'meta_all.csv')
    
    elif opMode=='update-meta':
        
        print """updating images metadata.
        Input metadata: {}
        Images folder: {}""".format(in_meta,in_dir_img) 
        
        seq_meta = load_metadata(in_meta)
        update_metadata(seq_meta,in_dir_img)
        
    else:
        print 'operation mode {} unknown.'.format(opMode)
    
    print 'processing completed. exit.'


if __name__ == "__main__":
    main(sys.argv[1:])



