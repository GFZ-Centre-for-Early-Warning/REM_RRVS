import cv2
import fitparse
import os

fname = 'V0280048.MP4'
fitfile ='2018-06-01-12-13-33.fit'
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

#parse metadata
fields_to_extract=['timestamp','enhanced_altitude','enhanced_speed','utc_timestamp','timestamp_ms','heading','velocity']
fields_to_convert=['position_lat','position_long']
meta = {}
for key in fields_to_extract+fields_to_convert:
    meta[key]=[]

ff=fitparse.FitFile('2018-06-01-12-13-33.fit')
for i,m in enumerate(ff.get_messages('gps_metadata')):
    for f in m.fields:
        if f.name in fields_to_extract:
            meta[f.name].append(f.value)
        if f.name in fields_to_convert:
            meta[f.name].append(f.value*180.0/2**31)

import pandas
metadata = pandas.DataFrame()
for key in fields_to_extract+fields_to_convert:
    metadata[key]=pandas.Series(meta[key])
metadata.to_csv('{}_metadata.csv'.format(stream))

