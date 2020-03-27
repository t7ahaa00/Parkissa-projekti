# -*- coding: utf-8 -*-
"""
Created on Sat Mar 21 15:09:18 2020

@author: Antti
"""
from ProcessImage import processImage

import os
import FindSlots as fs

def countLabels(labels):
    
    count = 0
    label_string = ['car','bus','truck','motorcycle']
    
    for label in label_string:
        
        count += labels.count(label)


    return count


def main():

    images = os.listdir("./images")
    
    for fileName in images:
        print(fileName)
        bbox, labels = processImage(fileName)
        
        print("Count of cars: " + str(countLabels(labels)))
        print("ID:s for available parking space: ", fs.checkFreeSlots(bbox, 'Camera1_parkingSlots'))
        
    

    
if __name__ == "__main__":
    main()