# -*- coding: utf-8 -*-
"""
Created on Tue Mar 31 15:26:38 2020

@author: Antti
"""

import cv2
import matplotlib.pyplot as plt
import cvlib as cv
from cvlib.object_detection import draw_bbox
from pathlib import Path
import os
from FetchImage import testImgFromUrl

def testImage(image): 
     
    ROOT_DIR = Path(".")
    # Directory of images to run detection on
    IMAGE_DIR = os.path.join(ROOT_DIR, "test_image")
   
    
    IMAGE_SOURCE = os.path.join(IMAGE_DIR,image)
   
    print(IMAGE_SOURCE)
    im = cv2.imread(IMAGE_SOURCE)
    bbox, label, conf = cv.detect_common_objects(im)
    output_image = draw_bbox(im, bbox, label, conf)
        
    plt.imshow(output_image)
    plt.show()


def main():
    
    
    try:
        testImgFromUrl("http://192.168.43.61:8081")
    except:
        print("no conneciton")
        
    images = os.listdir("./test_image")
    
    while True:
            
        for image in images:         
            testImage(image)
            if cv2.waitKey(5) & 0xFF == 27:
                break
            
        break
    
    cv2.destroyAllWindows()

if __name__=="__main__":
    
    main()