# from urllib2 import Request, urlopen
from urllib.request import Request, urlopen 
import json
import pandas as pd
# from StringIO import StringIO
from io import StringIO
import numpy as np
import googlemaps
import time
#import matplotlib.pyplot as plt

# Modify with own key
keyJASL = 'AIzaSyDVWjCMy78Zuk244tB3duLXCK2vSn6NhTQ'
gmaps = googlemaps.Client(key=keyJASL)

fileName = 'Chihuahua_grupo.csv'
# Starting with Chihuahua
Locations =  {'idx':[],
             'jdx':[],
             'start_lat':[],
             'start_lon':[],
             'finish_lat':[],
             'finish_lon':[],
              'distance':[]
}

print('We\'re doing: '+fileName)
s = time.time()

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
    f.close()

size_Locations = len(Locations['idx'])


print('Read CSV file, about to compute distances')

for i in range(0,size_Locations):
    directions_result = gmaps.directions((Locations['start_lat'][i],
                                      Locations['start_lon'][i]),
                                      (Locations['finish_lat'][i],
                                       Locations['finish_lon'][i]),
                                      region = "mx")
    directions = directions_result[0]['legs'][0]
    steps = pd.DataFrame.from_dict(directions['steps'])

    Locations['distance'][i] = directions['distance']['value']/1000
    coords     = pd.DataFrame(index = range(steps.shape[0]),
				  columns = ['start_LAT',
					     'start_LON',
					     'end_LAT',	
					     'end_LON'])
    for j in range(steps.shape[0]):
        coords['start_LAT'][i] = steps_df['start_location'][i]['lat']
        coords['start_LON'][i] = steps_df['start_location'][ i ]['lon']
        coords['end_LAT'][i] = steps_df['end_location'][i]['lat']
        coords['end_LON'][i] = steps_df['end_location'][i]['lon']
    

print('We\'re done computing distances, now let\'s create the CSV files!')

    
