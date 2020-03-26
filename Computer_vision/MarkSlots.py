# -*- coding: utf-8 -*-
"""
Created on Tue Mar 24 12:53:10 2020

@author: Antti
"""

import cv2
import numpy as np
import json
import MakeJsonFile
from MakeJsonFile import Parkingslot

image = cv2.imread("./images/camera1_img1.jpg")
slots = []
slot = []

        

def draw_circle(event,x,y,flags,param):
    if event == cv2.EVENT_LBUTTONDBLCLK:
        cv2.circle(image,(x,y),5,(124,252,0),-1)
        slot = [x,y]
        slots.append(slot)
        print(" X= ", x, "Y= ", y)
        
def main():
    
    cv2.namedWindow("image")
    cv2.setMouseCallback("image", draw_circle)
       
    while True:
        cv2.imshow("image", image)
        # wait 5 seconds then wait for ESC key
        if cv2.waitKey(5) & 0xFF == 27:
            break
        
    slotID = 0           
    data = []
    
    for s in slots:
        slotID +=1
        details = Parkingslot(slotID,s[0],s[1],True)    
        data.append(json.loads(details.toJson()))
    
    MakeJsonFile.makeJsonFile("Camera1_parkingSlots", data)
    cv2.destroyAllWindows()

if __name__== "__main__":
    main()