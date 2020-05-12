# -*- coding: utf-8 -*-
"""
Created on Thu Apr 23 11:44:14 2020

@author: Antti
"""


import json
from Freeslot import Freeslot
from io import BytesIO


def checkFreeSlots(cars, slotsFilePath, s3Session, bucket):
    
    slots=[]
    free_slots = []
    busy_slots=[]
    
    s3 = s3Session.resource("s3")
    bucket = s3.Bucket(bucket)
    object = bucket.Object(slotsFilePath)
    data_file = BytesIO(object.get()['Body'].read())
    
        
    data = json.load(data_file)
            
    for slot in data:
        slots.append(slot) 
               
    
          
    for i, slot in enumerate(slots):
        for car in cars:  
            if FindPoint(car, slot['x'], slot['y']):
                busy_slots.append(i)
                break
            

    for i,slot in enumerate(slots):
        if i not in busy_slots:
            free_slots.append(json.loads(Freeslot(slot["sId"]).toJson()))
            
    
    return {"slots":free_slots}, len(slots)


def FindPoint(box, x, y) :   
    x1 , y1 , x2 , y2 = box
    
    if (x > x1 and x < x2 and 
        y > y1 and y < y2) : 
        return True
    else : 
        return False