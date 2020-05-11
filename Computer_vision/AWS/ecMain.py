import boto3
import botoCredentials
import cv2
from io import BytesIO
import matplotlib.image as mpimg
import awsFindSlots as fs
from ProcessImage import processImage
import argparse
import json

session = boto3.Session(aws_access_key_id=botoCredentials.aws_access_key_id,
          aws_secret_access_key=botoCredentials.aws_secret_access_key,
          region_name = botoCredentials.region)

s3 = session.resource("s3")

def getImage(photo, bucket):
    bucket = s3.Bucket(bucket)
    object = bucket.Object(photo)
    img = mpimg.imread(BytesIO(object.get()['Body'].read()),'.jpg')
   
    return img
        
def main():
    try:
        ap = argparse.ArgumentParser()
        ap.add_argument("-p", "--photoPath", required=True,
        help="path to s3 photo file")
        ap.add_argument("-j", "--jsonPath", required=True,
        help="path to s3 json file")
        args = vars(ap.parse_args())
      
        bucket = 'parkissaimages'
        photo = args["photoPath"]
        jsonFile = args["jsonPath"]
    
        bbox, labels = processImage(getImage(photo, bucket))
        freeIDs, allSlots = fs.checkFreeSlots(bbox,jsonFile, session, bucket)
        #print("IDs for available parking spaces: ", freeIDs)
        #print("Area has ", allSlots, " parking spaces")

        s3.Object('parkissaimages', photo.replace('.jpg', '.json')).put(Body=(bytes(json.dumps(freeIDs).encode('UTF-8'))))
       
    except:
        print("JSON file doesn't exist")
if __name__ == "__main__":
    main()
