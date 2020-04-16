# -*- coding: utf-8 -*-
"""
Created on Mon Apr  6 15:20:38 2020

@author: Antti
"""
import json

class Freeslot(object):
    
    def __init__(self, grid, row):
        
        
        self.row = row
        self.grid = grid  
        
    def toJson(self):
        return json.dumps(self, default=lambda o: o.__dict__, 
                          sort_keys=True, indent=4)       