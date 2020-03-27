# -*- coding: utf-8 -*-
"""
Created on Thu Mar 26 13:09:35 2020

@author: Antti
"""

import json

def checkFreeSlots(cars, slotsFileName):
    
    slots=[]
    free_slots=[]
    busy_slots=[]
    
    with open(slotsFileName + '.json', 'r') as data_file:
        
        data = json.load(data_file)
            
    for slot in data["parkingslots"]:
        slots.append(slot) 
               
    data_file.close()
          
    for i, slot in enumerate(slots):
        for car in cars:  
            if FindPoint(car, slot['x'], slot['y']):
                busy_slots.append(i)
                break
            

    for i,slot in enumerate(slots):
        if i not in busy_slots:
            free_slots.append(slot["sId"])
   
    return free_slots


def FindPoint(box, x, y) :   
    x1 , y1 , x2 , y2 = box
    
    if (x > x1 and x < x2 and 
        y > y1 and y < y2) : 
        return True
    else : 
        return False