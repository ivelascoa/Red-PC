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
#keyJASL = 'AIzaSyDVWjCMy78Zuk244tB3duLXCK2vSn6NhTQ'
#keyISAAC = 'AIzaSyCRVZD_oqSEeHGn0T74_O_eedqgcoWW-hc'
#keyIVI = 'AIzaSyDdRsqVOSuf_rsTBcWGdw02qgs5uGQe9-Y'
#keyOros = 'AIzaSyBD60IkWt5RC24XuZPRQG3yHaZX20YNCP0'
#keyMAYTE = 'AIzaSyDiTs4L73aA2b3sIYfsSCLL8AcJm1n_g1w'
#keyJOAN = 'AIzaSyBAWQAnJV_L7vYlzyyKy4H-vmg4tBClCLQ'
#keyDeLINT = 'AIzaSyBNjDdSkn7YbOL-VtkU8IheoCQKNJk0DNg'
#keyANDRE = 'AIzaSyD7-JGjlCrNb7Ic0P44mmci3zUXJClkFEI'

keytouse = 'AIzaSyBAWQAnJV_L7vYlzyyKy4H-vmg4tBClCLQ'
gmaps = googlemaps.Client(key=keytouse)

stlat = 19.2414
stlon = -98.8471
flat = 20.3641
flon = -103.8236

try:
    directions_result = gmaps.directions((stlat,stlon),
                                         (flat,flon),
                                         region = "mx")    
    directions = directions_result[0]['legs'][0]
    distance = directions['distance']['value']/1000
    steps = directions['steps']

    print('We didn\'t have an error!!!')
    print('distance = '+str(distance)+' KM')

except googlemaps.exceptions.ApiError as ApiErr:
    print('We got an API error!')
    print(ApiErr)

except googlemaps.exceptions.Timeout as Timeout:
    print('We got a TIMEOUT!!')
    print(Timeout)

print('We\'re out of the TRY-CATCH')

