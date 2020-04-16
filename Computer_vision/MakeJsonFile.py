# -*- coding: utf-8 -*-
"""
Created on Thu Mar 26 11:21:30 2020

@author: Antti
"""
import json
import simplejson


class Parkingslot(object):
    
    def __init__(self, sID, x, y, row):
        
        self.sId = sID   
        self.x = x
        self.y = y
        self.row = row
        
    def toJson(self):
        return json.dumps(self, default=lambda o: o.__dict__, 
                          sort_keys=True, indent=4)       
    
def makeJsonFile(cameraFileName, details):
    
    cameraFileName = cameraFileName + ".json"
    f = open(cameraFileName, 'w')
    simplejson.dump({"parkingslots":details}, f)
    f.close()
    