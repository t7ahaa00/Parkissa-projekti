# -*- coding: utf-8 -*-
"""
Created on Sat Mar 21 15:09:18 2020

@author: Antti
"""
from ProcessImage import processImage

import os
import FindSlots as fs
import FetchImage as fi

def countLabels(labels):
    
    count = 0
    label_string = ['car','bus','truck','motorcycle']
    
    for label in label_string:
        
        count += labels.count(label)


    return count


def main():
    #Japan osaka http://220.157.160.198:8080/-wvhttp-01-/GetOneShot?image_size=640x480&frame_count=1
    #Netherlands http://80.115.125.150/webcapture.jpg?command=snap&channel=1?
    #israel http://188.120.135.60:60001/cgi-bin/snapshot.cgi?chn=0&u=admin&p=&q=0&1585670180
    cameras = os.listdir("./images")
    fi.urlToImg("camera2","http://188.120.135.60:60001/cgi-bin/snapshot.cgi?chn=0&u=admin&p=&q=0&1585670180")
   
    
    for camera in cameras:
        
        path = "./images/" + camera
        images = os.listdir(path)
        
        for fileName in images:
            print(fileName)
            bbox, labels = processImage(camera,fileName)
            jsonFile = camera + '_parkingSlots'
            freeIDs, allSlots = fs.checkFreeSlots(bbox,jsonFile)
            print("IDs for available parking spaces: ", freeIDs)
            print("Area has ", allSlots, " parking spaces")
      
    

    
if __name__ == "__main__":
    main()