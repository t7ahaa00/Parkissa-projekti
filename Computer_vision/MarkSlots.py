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

imageFileName = "testImg.jpg"
image = cv2.imread(f"./test_image/{imageFileName}")
#image = cv2.imread("./test_image/camera3img.jpg")
slots = []
slot = []
row = 1
slotID = 1   


def draw_circle(event,x,y,flags,param):
    global row, slotID
    
    if event == cv2.EVENT_LBUTTONDBLCLK:
        cv2.circle(image,(x,y),5,(124,252,0),-1)
        slot = [slotID,x,y,row]
        slots.append(slot)
        print("slotID = ", slotID, "Row = ", row, " X= ", x, "Y= ", y)
        slotID +=1
       
        
    if event == cv2.EVENT_RBUTTONDBLCLK:
        row +=1
        slotID = 1
        print("row is now ", row)
        
def main():
    
    cv2.namedWindow("image")
    cv2.setMouseCallback("image", draw_circle)
       
    while True:
        cv2.imshow("image", image)
        # wait 5 seconds then wait for ESC key
        if cv2.waitKey(5) & 0xFF == 27:
            break
        
      
    data = []
    
    for s in slots:
        details = Parkingslot(s[0],s[1],s[2],s[3])    
        data.append(json.loads(details.toJson()))
    
    
    MakeJsonFile.makeJsonFile(f"testi_parkingSlots", data)
    cv2.destroyAllWindows()

if __name__== "__main__":
    main()