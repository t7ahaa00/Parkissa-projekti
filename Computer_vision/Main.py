# -*- coding: utf-8 -*-
"""
Created on Sat Mar 21 15:09:18 2020

@author: Antti
"""
from ProcessImage import processImage

import os

def main():

    images = os.listdir("./images")
    
    for fileName in images:
        print(fileName)
        print("Count of cars: " + str(len(processImage(fileName))))
        
if __name__ == "__main__":
    main()