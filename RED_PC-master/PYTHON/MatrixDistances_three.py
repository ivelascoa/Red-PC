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
keyISAAC = 'AIzaSyCRVZD_oqSEeHGn0T74_O_eedqgcoWW-hc'
keyIVI = 'AIzaSyDdRsqVOSuf_rsTBcWGdw02qgs5uGQe9-Y'
keyOros = 'AIzaSyBD60IkWt5RC24XuZPRQG3yHaZX20YNCP0'
keyMAYTE = 'AIzaSyDiTs4L73aA2b3sIYfsSCLL8AcJm1n_g1w'
keyJOAN = 'AIzaSyBAWQAnJV_L7vYlzyyKy4H-vmg4tBClCLQ'
keyDeLINT = 'AIzaSyBNjDdSkn7YbOL-VtkU8IheoCQKNJk0DNg'
keyANDRE = 'AIzaSyD7-JGjlCrNb7Ic0P44mmci3zUXJClkFEI'
keyROD = 'AIzaSyC2bvTzWmdr_1_kgzJ7fmGbAd1YmuuwLFs'
keyFER = 'AIzaSyDEBFgM8GeV7dOzJaK_71ObkfrGxHuUE7k'
keyMARTIN = 'AIzaSyC4uUFhYqzRsdLb2O8sXqrMdgTDYQC16nM'
keyDAISY = 'AIzaSyBbGe68iy3keQbkMFfyuXNEeN7tq-7Pm5M'
keyHUGO = 'AIzaSyB5jEgkRS2u3qpHYcBixo8Zy2siLVVIcWQ'
keyILSE = 'AIzaSyDQwzc5u1qv9mbQ3fhZEucOy-mfa00-4WU'
keySEBAS = 'AIzaSyDauNdiEztxXlGG6-vF0hZfX2joB0VeeS4'
keyDIEGO = 'AIzaSyDxud7UtMczI3RDzQ4S4TbQqYRUth4xD8k'

keys = [keyDIEGO,
        keySEBAS,
        keyILSE,
	keyHUGO,
	keyMARTIN,
	keyDAISY,
	keyFER,
        keyROD,
        #keyJOAN,
        keyDeLINT,
        keyIVI,
        keyOros,
        keyMAYTE,
        keyJASL,
        keyANDRE, 
        keyISAAC]

keycount = 0
gmaps = googlemaps.Client(key=keys[keycount])

fileNames = ['Chihuahua_grupo.csv',
             'CancunMerida_grupo.csv',
             'CiudadesPrincipales_51_grupo.csv',
             'Puebla_grupo.csv',
             'ChiapasTuxtla_grupo.csv']

# Starting with Chihuahua
Locations =  {'idx':[],
             'jdx':[],
             'start_lat':[],
             'start_lon':[],
             'finish_lat':[],
             'finish_lon':[],
             'distance':[]}

print('We\'re doing: '+fileNames[1])
s = time.time()

with open(fileNames[1],'r') as f:
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

i = 0
j = 0
while i < size_Locations:
    try:
        directions_result = gmaps.directions((Locations['start_lat'][i],
                                              Locations['start_lon'][i]),
                                             (Locations['finish_lat'][i],
                                              Locations['finish_lon'][i]),
                                             region = "mx")
        directions = directions_result[0]['legs'][0]
    
        Locations['distance'][i] = directions['distance']['value']/1000
        
        if j == 2500:
            j = 0
            keycount = keycount + 1
            print('     We\'re changing the key to: ')
            print('    '+str(keys[keycount]))
            print('     We\'re getting there!')
            gmaps=googlemaps.Client(keys[keycount])

        i = i + 1
        j = j + 1
        
    except googlemaps.exceptions.ApiError as ApiError:
        print('\n    We got an API error!! Let\'s try another key.')
        j = 0
        keycount = keycount + 1
        print('     We\'re changing the key to: ')
        print('    '+str(keys[keycount]))
        gmaps=googlemaps.Client(keys[keycount])
        
    except googlemaps.exceptions.Timeout as Timeout:
        print('\n    We got a TIMEOUT!! Let\'s try again.')
        print(Timeout)
        print(' ')
        

print('We\'re done computing distances, creating new CSV file...')

df = pd.DataFrame(data=Locations,columns=
                  ['idx','jdx','start_lat',
                   'start_lon','finish_lat',
                   'finish_lon','distance'])

filetoSave = 'Distance_'+fileNames[1]

ff = open(filetoSave,'w')
df.to_csv(ff,header=False)
ff.close()
s= time.time() - s
# Closing statements
print('We did about: '+str(size_Locations)+' consults to Google,')
print('taking about '+ str(s) + ' seconds.')
print('All set, bye!')
# DONE!
