# -*- coding: utf-8 -*-
"""
Created on Sun Mar 29 18:41:31 2020

@author: Antti
"""
from urllib.request import urlopen
from PIL import Image
import cv2
import numpy as np

def urlToImg(camera, url):
    
    img = np.array(Image.open(urlopen(url)))
    path ="./images/" + camera + "/" + camera + "Img.jpg"
    cv2.imwrite(path, img)
    
