import json
import base64
import boto3
import sys

BUCKET_NAME = 'parkissaimages'
def main(event, context):
    for record in event['Records']:
        bucketName = str(record['s3']['bucket']['name'])
        key = record['s3']['object']['key']
        eventTime = record['eventTime']

    folder, parkinglotID, areaID, camera = key.split('/')
    cameraNumber,imageType=camera.split('.')

    s3 = boto3.resource('s3')
    bucket = s3.Bucket(BUCKET_NAME)
    path = '%s/%s/%s/%s.json'%(folder,parkinglotID,areaID,cameraNumber)
    data = str({"Bucket":bucketName,"Folder":folder,"parkinglotID":parkinglotID,"areaID":areaID,"cameraNumber":cameraNumber,"imageType":imageType})
    #bucket.put_object(
    #    ACL='public-read',
    #    ContentType='application/json',
    #    Key=path,
    #    Body=data,
    #    )
    
    
    #Hakee kuvan
    obj = bucket.Object(key)
    response = obj.get()
    img = response[u'Body'].read()  
    imgBase64 = [base64.b64encode(img)] 
    return_json = str(imgBase64[0])           # Assing to return_json variable to return.  
    return_json = return_json.replace("b'","")          # repplace this 'b'' is must to get absoulate image.
    encoded_image = return_json.replace("'","")
    
    sqs = boto3.client('sqs')

    queue_url = 'https://sqs.eu-west-1.amazonaws.com/997880591872/newImage' 

    response = sqs.send_message(
        QueueUrl=queue_url,
        DelaySeconds=10,
        MessageAttributes={
        'bucket': {
            'DataType': 'String',
            'StringValue': bucketName
        },
        'folder': {
            'DataType': 'String',
            'StringValue': folder
        },
        'parkinglotID': {
            'DataType': 'String',
            'StringValue': parkinglotID
        },
        'areaID': {
            'DataType': 'String',
            'StringValue': areaID
        },
        'cameraNumber': {
            'DataType': 'String',
            'StringValue': cameraNumber
        },
        'imageType': {
            'DataType': 'String',
            'StringValue': imageType
        },
        'image': {
            'DataType': 'String',
            'StringValue': encoded_image
        },
        'time': {
            'DataType': 'String',
            'StringValue': eventTime
        }
        },
        MessageBody=(
            'New image from camera ' + cameraNumber + " in parkinglot " + parkinglotID + " in area "+ areaID 
        )
    )

    print(response['MessageId'])