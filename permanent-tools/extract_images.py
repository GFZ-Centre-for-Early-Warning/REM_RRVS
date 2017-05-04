####################################################
# Script that extracts all images as jpg of all PGR 
# files in a directory using PointGrey APIs. 
# also write as many .csv files as the number of .pgr 
# sequences, containing a set of attributes for each
# extracted frame.
# 
# Last modified: 05.09.2016
# Author: M.Haas - M. Pittore
# Contact: mhaas@gfz-potsdam.de
####################################################

import argparse
import glob
import os
import subprocess
import csv
import datetime
from geographiclib.geodesic import Geodesic
from scipy.interpolate import UnivariateSpline
import multiprocessing
import getpass


#command line functionality
parser = argparse.ArgumentParser()
parser.add_argument('-i','--in_dir',type=str,help='directory to containing the pgr files to be processed',required=True)
parser.add_argument('-c','--config',type=str,help='Name of the config file containing information about the survey, see config.ini ',required=True)
parser.add_argument('-o','--out_dir',type=str,help='directory to store the images and the csv',required=True)
args = parser.parse_args()

#TODO: rename stype,itype in the end in csv

basepath = os.path.join(os.path.expanduser('~'),'Documents')

error = 'Unspecified error'
try:
    #Check if input dir exists
    try:
        1/os.path.exists(args.in_dir)
    except:
        error = 'Input directory: {} does not exist.'.format(args.in_dir)
        raise Exception
    
    #Find pgr files
    try:
        pgr_files = [f for f in glob.glob(args.in_dir+'/*.pgr')]
        pgr_files.sort()
        nr_files = len(pgr_files)
        1/(nr_files > 0)
    except:
        error = 'Could not find any pgr files in: {}'.format(args.in_dir)
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
        unique_streams = [s.split('-')[-2][-6:] for s in pgr_files]
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

    #ladybugProcessStreamParallel processes whole stream --> get only unique files, i.e. first file xxx-000000.pgr
    pgr_files = [f for f in pgr_files if '-000000.pgr'in f]
    
    #Inform user on selection
    print 'Found {} streams in directory {}.'.format(len(pgr_files),args.in_dir)

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

        #TODO: Fix this in later version since this requires using LadyCapPro
        #use this number to determine correct frame_info file 
        frame_info_file = '{}/ladybug_frame_gps_info_{}.txt'.format(basepath,nr_files)
        
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
