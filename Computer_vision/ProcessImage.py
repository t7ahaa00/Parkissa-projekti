# -*- coding: utf-8 -*-
"""
Created on Fri Mar 20 14:58:49 2020

@author: Antti
"""

import cv2
import matplotlib.pyplot as plt
import cvlib as cv
from cvlib.object_detection import draw_bbox
from pathlib import Path
import os

def processImage(camera, image): 
     
    ROOT_DIR = Path(".")
    # Directory of images to run detection on
    IMAGE_DIR = os.path.join(ROOT_DIR, "images")
    CAMERA_DIR = os.path.join(IMAGE_DIR, camera)
    
    IMAGE_SOURCE = os.path.join(CAMERA_DIR,image)
   
    im = cv2.imread(IMAGE_SOURCE)
    bbox, label, conf = cv.detect_common_objects(im)
    output_image = draw_bbox(im, bbox, label, conf)
        
    #plt.imshow(output_image)
    #plt.show()
    return bbox, label