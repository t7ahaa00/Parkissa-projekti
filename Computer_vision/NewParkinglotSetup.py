# -*- coding: utf-8 -*-
"""
Created on Thu Apr  9 11:52:55 2020

@author: Antti
"""
from pathlib import Path
import os
import json
from APIRequests import ApiRequests
from APIRequests import createParkingSpots
from APIRequests import getParkinglot
from APIRequests import deleteParkinglot

class Coords(object):
    
    def __init__(self, lat, lng):
        
        self.lat = lat   
        self.lng = lng
        
class SlotsInRow(object):
    def __init__(self, row, slots):
        
        self.row = row   
        self.slots = slots 
        
def toJson(self):
    return json.dumps(self, default=lambda o: o.__dict__, 
                      sort_keys=True, indent=4)


        
def askDetails():
    lat = []
    lng = []
    coords = []
    print("Give details for new parkinglot")
    parkinglotname = input("Parkinglot name: ")
       
    areaId = int(input("Area ID: "))
    availableSlots = int(input("Available slots: "))
    orientation = float(input("Orientation by degrees: "))
      
    print("Give coords for parkinlot corners")
    for i in range(4):
        try:
            lat.insert(i,float(input(f"lat{i+1}: ")))
        except ValueError:
            print(ValueError)
            
        try:
            lng.insert(i,float(input(f"lng{i+1}: ")))
        except ValueError:
           print(ValueError)
       
        coords.append(json.loads(toJson(Coords(lat[i], lng[i]))))
        print(type(coords[i]))
    
    return parkinglotname, areaId, availableSlots, orientation, coords

def createSlots(areaId):
    print(f"Area ID:{areaId}")
    rows = int(input(f"How many rows is in the parkinglot?: "))
    slots = []
    for i in range(rows):
        slots.append(json.loads(toJson(SlotsInRow(i+1,int(input(f"How many slots in row {i+1}:"))))))
        
    return {"slots":slots}
        
def makeDirs(parkinglotName, parkingAreaID):
    ROOT_DIR = Path("./Parkinglots")
    os.makedirs(f"{ROOT_DIR}/{parkinglotName}/{parkingAreaID}/camera1", 493) # 493 is permission mode to folder
    
    

def main():
    
    name, areaId, availableSlots, orientation, coords = askDetails()
    area = ApiRequests(name, areaId, availableSlots, orientation, coords)
    
    try:
        
        r = area.createParkinglot()
        rTojson = r.json()
        print(rTojson)
        
        for parkinglot in rTojson:
            print(parkinglot)
            makeDirs(name, parkinglot["idparkingarea"] )
            slots = createSlots(int(parkinglot["idparkingarea"]))
            createParkingSpots(int(parkinglot["idparkingarea"]),slots)
            
        
    except OSError as err:
        print("OS error: {0}".format(err))
        
if __name__ == "__main__":
    main()
    
    