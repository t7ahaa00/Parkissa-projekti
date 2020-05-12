import cv2
import numpy as np
import json
import MakeJsonFile
import boto3
import botoCredentials
from io import BytesIO
import matplotlib.image as mpimg
from MakeJsonFile import Parkingslot
import argparse

slots = []
slot = []

ap = argparse.ArgumentParser()
ap.add_argument("-p", "--parkingLotID", required=True,
help="path to s3 photo file")
ap.add_argument("-a", "--areaID", required=True,
help="path to s3 json file")
ap.add_argument("-c", "--cameraID", required=True,
help="path to camera file")
args = vars(ap.parse_args())

parkingLot = args["parkingLotID"]
areaID = args["areaID"]
cameraID = args["cameraID"]
        
slotID = 1
session = boto3.Session(aws_access_key_id = botoCredentials.aws_access_key_id, aws_secret_access_key = botoCredentials.aws_secret_access_key, region_name = botoCredentials.region)
s3 = session.resource('s3')

imgPath = f'images/{parkingLot}/{areaID}/Opticam_O5_00626EE9980F/snap/camera{cameraID}_'
       
def draw_circle(event,x,y,flags,param):
    global slotID
    
    if event == cv2.EVENT_LBUTTONDBLCLK:
        cv2.circle(image,(x,y),5,(124,252,0),-1)
        slot = [slotID,x,y]
        slots.append(slot)
        print("slotID = ", slotID, " X= ", x, "Y= ", y)
        slotID +=1
       
    if event == cv2.EVENT_RBUTTONDBLCLK:
        
        slotID = askID()              
        print("Starting from slotID: ", slotID)
        
def askID():
    
    while(True):
            try:
                slotID = int(input("Enter starting slot ID(int): "))
                return slotID 
            except:
                pass

def fetchImage(bucketName, path):
    
    bucket = s3.Bucket(bucketName)
    
    for keys in bucket.objects.filter(Prefix=path):  
        imageKey = keys.key
        
    myObject = bucket.Object(imageKey)
    return mpimg.imread(BytesIO(myObject.get()['Body'].read()), 'jpg')

image = fetchImage('parkissaimages', imgPath)
    
def main():
    
    cv2.namedWindow("image")
    cv2.setMouseCallback("image", draw_circle)
    slotID = askID()
       
    while True:
        cv2.imshow("image", image)
        # wait 5 seconds then wait for ESC key
        if cv2.waitKey(5) & 0xFF == 27:
            break
          
    data = []
    
    for s in slots:
        details = Parkingslot(s[0],s[1],s[2])    
        data.append(json.loads(details.toJson()))
         
    s3.Object('parkissaimages', f'json/{parkingLot}/{areaID}/camera{cameraID}.json').put(Body=(bytes(json.dumps(data).encode('UTF-8'))))
    cv2.destroyAllWindows()
 
if __name__== "__main__":
    main()