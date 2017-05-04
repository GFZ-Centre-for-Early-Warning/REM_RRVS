####################################################
# Script that converts a metadata.csv file
# resampled or not to an SQL script ready for use in 
# a REM database. 
#
# Last modified: 15.02.2016
# Author: M.Haas 
# Contact: mhaas@gfz-potsdam.de
####################################################
from __future__ import print_function
import argparse
import os
import csv

#command line functionality
parser = argparse.ArgumentParser()
parser.add_argument('-i','--in_file',type=str,help='input metadata file as created by extract.py or resample.py',required=True)
parser.add_argument('-d','--destination',type=str,help='provide the forseen final destination path on the filesystem which will be written as basepath to the sql script',required=True)
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
    
    out_file=os.path.abspath(args.in_file[:-4]+'.sql')

    #remove file if exists
    try:
        os.remove(out_file)
    except:
        pass
    
    try:
        with open(out_file,'a') as f:
            survey = ''
            for i in range(len(meta['GPSLongitude'])): 
                #write survey info only if changed (should only happen once, i.e. each script should be for only one survey)
                if meta['SurveyName'][i]!=survey:
                    survey = meta['SurveyName'][i]
                    row = "INSERT INTO survey.survey (name,description,type,resp) VALUES ('{}','{}','{}','{}');\n".format(meta['SurveyName'][i],meta['SurveyDescription'][i],meta['SurveyType'][i],meta['Author'][i])
                    f.write(row)
                #for each image
                #gps info
                row = "INSERT INTO image.gps (altitude,azimuth,abspeed,the_geom,lat,lon) VALUES ({},{},{},public.ST_GeomFromText('POINT({} {})',4326),{},{});\n".format(float(meta['GPSAltitude'][i]),float(meta['GPSAzimuth'][i]),float(meta['GPSSpeed'][i]),float(meta['GPSLongitude'][i]),float(meta['GPSLatitude'][i]),float(meta['GPSLatitude'][i]),float(meta['GPSLongitude'][i]))
                f.write(row)
                #gpano info
                row="INSERT INTO image.gpano_metadata(usepanoramaviewer,capturesoftware,stitchingsoftware,projectiontype,poseheadingdegrees,posepitchdegrees,poserolldegrees,initialviewheadingdegrees,initialviewpitchdegrees,initialviewrolldegrees,initialhorizontalfovdegrees,firstphotodate,sourcephotoscount, exposurelockused,croppedareaimagewidthpixels,croppedareaimageheightpixels,fullpanoheightpixels,fullpanowidthpixels,croppedarealeftpixels,croppedareatoppixels,initialcameradolly) VALUES ({},'{}','{}','{}',{},{},{},{},{},{},{},to_timestamp('{}','YYYY-MM-DD HH24:MI:SS.US'),{},{},{},{},{},{},{},{},{});\n".format(bool(meta['UsePanoramaViewer'][i]),meta['CaptureSoftware'][i],meta['StitchingSoftware'][i],meta['ProjectionType'][i],float(meta['PoseHeadingDegrees'][i]),float(meta['PosePitchDegrees'][i]),float(meta['PoseRollDegrees'][i]),int(meta['InitialViewHeadingDegrees'][i]),int(meta['InitialViewPitchDegrees'][i]),int(meta['InitialViewRollDegrees'][i]),float(meta['InitialHorizontalFOVDegrees'][i]),meta['FirstPhotoDate'][i],int(meta['SourcePhotosCount'][i]),bool(meta['ExposureLockUsed'][i]),int(meta['CroppedAreaImageWidthPixels'][i]),int(meta['CroppedAreaImageHeightPixels'][i]),int(meta['FullPanoHeightPixels'][i]),int(meta['FullPanoWidthPixels'][i]),int(meta['CroppedAreaLeftPixels'][i]),int(meta['CroppedAreaTopPixels'][i]),float(meta['InitialCameraDolly'][i]))
                f.write(row)
                #image info
                row = "INSERT INTO image.img (gps,survey,timestamp,filename,type,repository,frame_id,gpano,width,height) VALUES ((SELECT currval('image.gps_gid_seq')),(SELECT currval('survey.survey_gid_seq')),to_timestamp('{}','YYYY-MM-DD HH24:MI:SS.US'),'{}','{}','{}',{},(SELECT currval('image.gpano_metadata_gid_seq')),{},{});\n".format(meta['FirstPhotoDate'][i],meta['FileName'][i],meta['XMP:ImageType'][i],args.destination,int(meta['FrameId'][i]),int(meta['ImageWidth'][i]),int(meta['ImageHeight'][i]))
                f.write(row)
    except:
        error='Failed to write row with index {} (starting from 0)'.format(i)

except:
    print('Error: '+error)
else:
    print('Created {}'.format(out_file))
