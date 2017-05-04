
# coding: utf-8

####################################################
# Script copies all files listed in an input file
# over a different folder
#
# Last modified: 08.10.2016
# Author: M.Pittore
# Contact: pittore@gfz-potsdam.de
# 
####################################################

import sys
import os
import glob
import argparse
import shutil

def parse_args(argv):
    try:
        #command line functionality
        parser = argparse.ArgumentParser()
        parser.add_argument('-i','--input_file',type=str,help="""
        input file listing the  image files to be copied.""",required=True)
        parser.add_argument('-o','--out_dir',type=str,help="""
        directory where the images will be written to.
        NOTE: input and output dir should not coincide, 
        since the images are written with the same filename.""",required=True)
        args = parser.parse_args(argv)
        return args
    except:
        print 'could not parse arguments.'
        return 
       
def get_files(in_file):
    inputfiles = []
    try:
        with open(in_file,'rb') as f:
            inputfiles = f.read().splitlines()
    except:
        print 'Error reading input file: {}'.format(in_file)
        return
    return inputfiles
       
def main(argv):
    args = parse_args(argv[1:])
    if not args:
        sys.exit()
    in_file = args.input_file
    out_dir = args.out_dir

    print """starting copy.
    Input file:{},
    Output folder:{},
    \n""".format(in_file,out_dir)
    inputfiles = get_files(in_file)

    try:
        for f in inputfiles:
            shutil.copy(f, out_dir)
    except:
        print 'error copying files.'
        sys.exit()
    print 'processing done. Exit...'

    
if __name__=='__main__':
    main(sys.argv)