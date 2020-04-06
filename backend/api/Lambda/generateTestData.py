import pymysql
import sys
import config
import json

REGION = config.region
rds_host  = config.db_host
name = config.db_username
password = config.db_password
db_name = config.db_name

def generateTestData(event):
    conn = pymysql.connect(rds_host, user=name, passwd=password, db=db_name, connect_timeout=5)
    with conn.cursor() as cursor:  
        if event['context']['http-method'] == 'POST':
            sql_Query = """CALL generateDummyData()"""
            cursor.execute(sql_Query)
            conn.commit()
            columns = [col[0] for col in cursor.description]
            data = [dict(zip(columns, row)) for row in cursor.fetchall()]
            returnValue = json.dumps(data)
            jsonOut = json.loads(returnValue)
            return(jsonOut)

def main(event, context):
    return generateTestData(event)
        