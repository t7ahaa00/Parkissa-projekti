# -*- coding: utf-8 -*-
"""
Created on Sun Mar 29 18:41:31 2020

@author: Antti
"""
from urllib.request import urlopen
from PIL import Image
import cv2
import numpy as np
import os

def urlToImg(lotname, area, camera, url):
    
    if not any(camera for dirName in os.listdir(f'./Parkinglots/{lotname}/{area}')):
        os.makedirs(f"./Parkinglots/{lotname}/{area}/{camera}", 493) # 493 is permission mode to folder
    cap = cv2.VideoCapture(url)
    ret, img = cap.read()
    path =f"./Parkinglots/{lotname}/{area}/{camera}/{camera}.Img.jpg"
    cv2.imwrite(path, img)
    
def testImgFromUrl(url):
    
    
    cap = cv2.VideoCapture(url)
    ret, img = cap.read()
    path =f"./test_image/testImg.jpg"
    cv2.imwrite(path, img)