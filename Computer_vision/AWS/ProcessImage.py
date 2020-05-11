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

def processImage(image): 
  
    bbox, label, conf = cv.detect_common_objects(image)
   
    return bbox, label
