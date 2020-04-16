import json
import base64
import boto3

BUCKET_NAME = 'parkissaimages'
def lambda_handler(event, context):
    if event['context']['http-method'] == 'PUT':
        file_content = base64.b64decode(event['body-json']['base64Image'])
        file_path = '%s/%s/kamera%s.png'%(event['params']['path']['parkinglotID'],event['params']['path']['parkingareaID'],event['body-json']['cameraNumber'])
        s3 = boto3.client('s3')
        try:
            s3_response = s3.put_object(Bucket=BUCKET_NAME, Key=file_path, Body=file_content)
        except Exception as e:
            raise IOError(e)
        return {
            'statusCode': 200,
            'body': {
                'file_path': file_path
            }
        }  
        
    if event['context']['http-method'] == 'GET':
        return {
            'statusCode': 200,
            'body': {
                'error': 'GET not yet implemented'
            }
        }   