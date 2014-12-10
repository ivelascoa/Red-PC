# from urllib2 import Request, urlopen
from urllib.request import Request, urlopen 
import json
import pandas as pd
# from StringIO import StringIO
from io import StringIO
import numpy as np
import googlemaps
import time
import csv
#import matplotlib.pyplot as plt

# Modify with own key
keyJASL = 'AIzaSyDVWjCMy78Zuk244tB3duLXCK2vSn6NhTQ'
gmaps = googlemaps.Client(key=keyJASL)

fileName = 'Chihuahua_grupo.csv'

Locations = {'idx':[],
             'jdx':[],
             'start_lat':[],
             'start_lon':[],
             'finish_lat':[],
             'finish_lon':[],
             'distance':[]}

with open(fileName,'r') as f:
    for line in f.readlines():
        i,j,stlat,stlon,flat,flon, dist = line.strip().split(',')
        Locations['idx'].append(int(i))
        Locations['jdx'].append(int(j))
        Locations['start_lat'].append(float(stlat))
        Locations['start_lon'].append(float(stlon))
        Locations['finish_lat'].append(float(flat))
        Locations['finish_lon'].append(float(flon))
        Locations['distance'].append(float(dist))
        #Locations.append([int(i),int(j),float(stlat),float(stlon),
        #                  float(flat),float(flon),float(dist)])
    f.close()

print('Before directions')
print(Locations['distance'][0])

# Start with one to prove it works
directions_result = gmaps.directions((Locations['start_lat'][0],
                                      Locations['start_lon'][0]),
                                      (Locations['finish_lat'][0],
                                       Locations['finish_lon'][0]),
                                      region = "mx")

directions = directions_result[0]['legs'][0]
Locations['distance'][0] = directions['distance']['value']/1000

print('After directions fetching')
print(Locations['distance'][0])

# try to print to data frame, then to csv
df = pd.DataFrame(data=Locations,columns=
                  ['idx','jdx','start_lat',
                   'start_lon','finish_lat',
                   'finish_lon','distance'])
ff = open('Prueba.csv','w')
df.to_csv(ff,header=False)
ff.close()
