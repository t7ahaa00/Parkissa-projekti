# -*- coding: utf-8 -*-
"""
Created on Sat Mar 21 15:09:18 2020

@author: Antti
"""
from ProcessImage import processImage

import os
import FindSlots as fs
import FetchImage as fi
from APIRequests import toggleAvailability
import time



def main():
    
    try:
        
        while True:
            
            #israel #fi.urlToImg(parkinglot,area,"camera1","http://188.120.135.60:60001/cgi-bin/snapshot.cgi?chn=0&u=admin&p=&q=0&1585670180")
            parkinglots = os.listdir("./Parkinglots")
            testUrl = "http://192.168.43.61:8081"
            #fi.urlToImg(parkinglot,area,"camera1",testUrl)
                
            
            for parkinglot in parkinglots:
                
                path = f"./Parkinglots/{parkinglot}"
                areasInParkinglot = os.listdir(path)
                
                for area in areasInParkinglot:
                    
                    
                    path = f"./Parkinglots/{parkinglot}/{area}"
                    camerasInArea = os.listdir(path)
                    print(area)
                    
                    for camera in camerasInArea:
                        path = f"./Parkinglots/{parkinglot}/{area}/{camera}"
                        images = os.listdir(path)
                        #fi.urlToImg(parkinglot,area,camera,testUrl)
                        for fileName in images:
                            print(f"{parkinglot} {fileName}")
                            bbox, labels = processImage(path,fileName)
                            jsonFile =f"{parkinglot}{area}{camera}_parkingSlots"
                            freeIDs, allSlots = fs.checkFreeSlots(bbox,jsonFile)
                            print("IDs for available parking spaces: ", freeIDs)
                            print("Area has ", allSlots, " parking spaces")
                            r = toggleAvailability(area, freeIDs)
                            print(r.json())
            time.sleep(5)
            
    except KeyboardInterrupt:
        pass
    

    
if __name__ == "__main__":
    main()