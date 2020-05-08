import json
import os
import boto3

def getJSONPath(imagePath):
    ID = 1   #If the parking lot needs more than 9 cameras, the ID number will have to be given in a filename uploaded by camera
    tmp = imagePath.replace('images', 'json', 1).split('/')
    del tmp[3:]
    initialPath = '/'.join(tmp) + '/'    
    followingPath = imagePath[str.find(imagePath, 'camera'):(str.find(imagePath, 'camera') + len("camera") + ID)] + ".json"
    return initialPath + followingPath

def lambda_handler(event, context):
    
    for record in event['Records']:
        
        key = record['s3']['object']['key']
        
    photoPath = key
    
    jsonPath = getJSONPath(photoPath)
    
    commands = ['. /tmp/parkissa_env/bin/activate', 'cd tmp/parkissa_env/parkeissa/', f'python ecMain.py -p {photoPath} -j {jsonPath}']
    
    ec2 = boto3.client('ec2')
    instance_id = []
    response = ec2.describe_instances()
    
    for reservation in response["Reservations"]:
        
        for instance in reservation["Instances"]:
            
            instance_id.append(instance["InstanceId"])
            
    ssm = boto3.client('ssm')
    ssm.send_command(InstanceIds=instance_id, DocumentName='AWS-RunShellScript', Parameters= { 'commands':commands } )

    return { 'statusCode': 200, 'body': json.dumps(event['Records']) }