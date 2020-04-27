import json
import base64
import boto3
import pymysql
import sys
import config


REGION = config.region
rds_host  = config.db_host
name = config.db_username
password = config.db_password
db_name = config.db_name


BUCKET_NAME = 'parkissaimages'
def main(event, context):
    
    conn = pymysql.connect(rds_host, user=name, passwd=password, db=db_name, connect_timeout=5)
    with conn.cursor() as cursor: 
        #Checking api key
        sql_Query = """SELECT * FROM api_keys WHERE ip = %s AND api_key = %s;"""
        insert_tuple = event["params"]["header"]["X-Forwarded-For"],event["params"]["header"]['x-api-key']
        try:
            cursor.execute(sql_Query,insert_tuple)
            conn.commit()
            columns = [col[0] for col in cursor.description]
            data = [dict(zip(columns, row)) for row in cursor.fetchall()]
        except pymysql.Error:
                print('MySQL Error')
        
        if not data: 
                raise Exception({
                        "errorType" : "Exception",
                        "httpStatus": 403,
                        "message": "Incorrect api key"
                    })
                    
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