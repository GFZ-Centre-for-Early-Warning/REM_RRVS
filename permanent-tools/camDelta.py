####################################################
# Script that creates csv file for unique pgr files 
# in a directory.Which can be used to manually specify the 
# clockwise angular difference between car heading and
# camera heading (should usually be 0).
# Furthermore it writes the metadata of  
# the images to the jpg file via exiftool and 
# writes a csv ready to be imported in the database.
# 
# Last modified: 22.01.2015
# Author: M.Haas 
# Contact: mhaas@gfz-potsdam.de
####################################################
import argparse
import glob
import os
import csv

#command line functionality
parser = argparse.ArgumentParser()
parser.add_argument('-i','--in_dir',type=str,help='directory to containing the pgr files to be considered',required=True)
args = parser.parse_args()

def write_csv(filename,data):
    '''
    Writes dictionary data to csv file (overwrites existing)
    '''
    with open(filename, 'w') as f:
        fieldnames=['unique_stream','delta']
        writer = csv.DictWriter(f,fieldnames=fieldnames)
        writer.writeheader()
        for i in range(len(data['delta'])):
            row = {}
            for key in fieldnames:
                row[key] = data[key][i]
            writer.writerow(row)

def read_csv(filename,data):
    '''
    Reads single csv file and store to data   
    '''
    with open(filename,'rb') as f:
        reader = csv.reader(f,delimiter=',')
	#skip header
	next(reader,None)
        for row in reader:
            data['unique_stream'].append(row[0])
            data['delta'].append(float(row[1]))

def print_table(data):
    '''
    Prints table row by row with index    
    '''
    print '{} {} {}'.format('unique_stream','delta','row_index')
    for i,s in enumerate(data['unique_stream']):
        print '{:6s}        {:4.2f}  {:3d}'.format(s,data['delta'][i],i)
        
def delta_dialog():
    '''
    Dialog asking for deltas
    '''
    delta = raw_input('Please provide either a single delta value for all or a comma separated list (e.g. 1.0,2.0,3.0) of floats:\n')
    try:
        delta = [float(delta)]
    except:
        try:
            delta = [float(d) for d in delta.split(',')]
        except:
            print 'Error: Neither a valid float nor list of floats!'
            raise Exception
    return delta

def delta_length(delta,length):
    '''
    Adjusts delta length if necessary
    '''
    if len(delta) == 1:
        if length > 1:
            return length*delta
	else:
	    return delta
    elif length == len(delta):
	return delta
    else:
	print 'Error: provided delta list does not match the number of rows to change.'
	raise Exception
        

def update_table(data,streams,delta,idx=None):
    '''
    Updates table    
    '''	
    if idx is None:
        #append to the table
        for i,s in enumerate(streams):
            data['unique_stream'].append(s) 
            data['delta'].append(delta[i])
    else:
        #replace delta values
        for i,j in enumerate(idx):
            data['delta'][j] = delta[i]
    return data

#Actual Interactive Program
print '#################################################'
print '#                                               #'
print '# Program to create/update the delta.csv file   #'
print '#                                               #'
print '# Containing the angular delta (clockwise)      #'
print '# between camera heading and car heading        #'
print '# for each stream found in an input directory   #'
print '#                                               #'
print '#################################################'
print '\n'
print 'Specified Input directory: {}'.format(args.in_dir)
if not os.path.exists(args.in_dir):
    print 'Could not find {}'.format(args.in_dir)
    raise IOError
else:
    csv_file =  args.in_dir+'/delta.csv'


#Find pgr files
try:
    pgr_files = [f for f in glob.glob(args.in_dir+'/*.pgr')]
    pgr_files.sort()
    nr_files = len(pgr_files)
    1/(nr_files > 0)
except:
    print 'Error: Could not find any pgr files in: {}'.format(args.in_dir)
    raise Exception

#determine unique streams
try:
    unique_streams = [s.split('-')[-2][-6:] for s in pgr_files]
    unique_streams = list(set(unique_streams))
    unique_streams.sort()
except:
    error = 'Could not determine unique streams'
    raise Exception

csv_content = {'unique_stream':[],'delta':[]}
#get old table if present
if os.path.exists(csv_file):
    #read the existing delta.csv
    try:
        print 'Found existing delta.csv file. Gathering content.'
        read_csv(csv_file,csv_content)
    except:
        print 'Could not read delta.csv file'
        raise Exception
else:
    print 'Found no existing delta.csv. Will create new table.'

#determine if there are missing files    
try:
    missing_streams = [s for s in unique_streams if s not in csv_content['unique_stream']]
except:
    print 'Something went wrong when determining missing streams in delta.csv'
    raise Exception


if len(missing_streams) > 0:
    print 'Found {} new stream(s):'.format(len(missing_streams))
    print '----------------------------------------------------------------------------------------------'
    for i,s in enumerate(missing_streams):
        print '{} {}'.format(s,i)
    print '----------------------------------------------------------------------------------------------'
    delta = delta_dialog()
    delta = delta_length(delta,len(missing_streams))
    csv_content = update_table(csv_content,missing_streams,delta)
else:
    print 'Found no new streams.'
    print '----------------------------------------------------------------------------------------------'

#Final loop.
while True:
    print 'This is the current table:'
    print_table(csv_content)
    print '----------------------------------------------------------------------------------------------'
    response = raw_input('Type (m)odify, (q)uit, or  (w)rite and quit: ')
    if response == 'q':
        break
    if response == 'w':
        write_csv(csv_file,csv_content)
        break
    if response == 'm':
        idx=raw_input('Provide index or comma separated list of indices of rows you like to provide a new delta value:\n')
        try:
            idx=list(int(idx))
        except:
            try:
                idx = [int(i) for i in idx.split(',')]
            except:
                print 'Error: Neither a valid integer or list of integers.'
            else:
                delta=delta_dialog()
		delta=delta_length(delta,len(idx))
            try:    
                csv_content = update_table(csv_content,'nostream',delta,idx)
            except:
                print 'Error: Updating table failed.'
            else:
                print 'Sucessfully updated table.'
