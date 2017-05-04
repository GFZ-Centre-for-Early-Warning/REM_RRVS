####################################################
# Script that resamples a metadata.csv file as generated 
# by extract_images.py 
# Two sampling approaches are available
#   1) fixed rate sampling (e.g. every 10th image) 
#   2) distance sampling (e.g. image every 2 meters)
#
# Last modified: 15.02.2016
# Author: M.Haas 
# Contact: mhaas@gfz-potsdam.de
####################################################
import argparse
import os
import csv
from geographiclib.geodesic import Geodesic
import multiprocessing

#command line functionality
parser = argparse.ArgumentParser()
parser.add_argument('-i','--in_file',type=str,help='input metadata file as created by extract.py',required=True)
parser.add_argument('-t','--type',type=str,help='sampling type f: fixed sampling rate, d: distance',required=True)
parser.add_argument('-s','--sample',type=str,help='1) image rate to be sampled (f-type), 2) distance in meters (d-type) ',required=True)
args = parser.parse_args()

#read meta data csv
error='Unexpected error'
try:
    try:
        meta={}
        with open(args.in_file,'rb') as f:
            reader = csv.DictReader(f) 
            for row in reader:
                for column, value in row.iteritems():
                    meta.setdefault(column, []).append(value)
    except:
        error = 'Reading meta data from {} failed.'.format(args.in_file)
        raise Exception
    
    #initialize resampled meta data
    resample={}
     
    #determine type of sampling
    if args.type=='f':
        try:
            rate = int(args.sample)
        except:
            error = '{} is not an integer rate'.format(args.sample)
            raise Exception
        try:
            for key in meta.keys():
                resample[key] = [val for i,val in enumerate(meta[key]) if i%rate==0] 
        except:
            error = 'Resampling at fixed rate {} failed'.format(rate)        
            
    elif args.type=='d':
        try:
            dist = float(args.sample)
        except:
            error = '{} is not an float'.format(args.sample)
            raise Exception
        try:
            pairs = list(zip([float(s) for s in meta['GPSLatitude']],[float(s) for s in meta['GPSLongitude']]))
            geo = [Geodesic.WGS84.Inverse(p1[0],p1[1],p2[0],p2[1]) for p1,p2 in zip(pairs[:-1],pairs[1:])]
            dists = [g['s12'] for g in geo]
            cum_dist = 0
            init=0
            idxs = []
            for i,d in enumerate(dists):
                #take first point
                if init==0:
                    init=1    
                    idxs.append(i)
                    cum_dist += d 
                #if threshold was overstepped by last point reset distance sum and append the points index
                elif cum_dist >= dist:
                    cum_dist=d
                    idxs.append(i)
                else:
                    cum_dist += d
        except:
            error = 'Could not spatially resample {} with a minimum distance of {}'.format(args.in_file,dist)
            raise Exception
        try:         
            for key in meta.keys():
                resample[key] = [val for i,val in enumerate(meta[key]) if i in idxs]
        except:
            error = 'Storing resampled metadata failed'
    else:
        error='{} not a recognized sampling type'.format(args.type)
        raise Exception
   
    #write filename list
    try:
        out_file = args.in_file[:-4]+'_resamp_{}{}.filelist'.format(args.type,args.sample)
        with open(out_file,'wb') as f:
            fieldnames = ['FileName']
            writer = csv.DictWriter(f,fieldnames=fieldnames)
            for i in range(len(resample['GPSLatitude'])):
                row={}
                row['FileName'] = os.path.join(resample['Repository'][i],resample['FileName'][i])
                writer.writerow(row)
    except:
        error='Writing resampled filelist {} failed'.format(out_file)
        raise Exception
    
    #write csv
    try:
        out_file = args.in_file[:-4]+'_resamp_{}{}.csv'.format(args.type,args.sample)
        with open(out_file,'wb') as f:
            fieldnames = list(resample.keys())
            fieldnames.sort()
            writer = csv.DictWriter(f,fieldnames=fieldnames)
            writer.writeheader()
            for i in range(len(resample['GPSLatitude'])):
                row={}
                for key in fieldnames:
                    row[key] = resample[key][i]
                writer.writerow(row)
    except:
        error='Writing resampled metadata file {} failed'.format(out_file)
        raise Exception
    
except:
    print 'Error: '+error
else:
    print 'Resampling complete created {}'.format(out_file)
    print 'Filelist written to {}.'.format(out_file[:-4]+'.filelist')
