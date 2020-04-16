import pymysql
import sys
import config
import json

REGION = config.region
rds_host  = config.db_host
name = config.db_username
password = config.db_password
db_name = config.db_name

def deleteParkinglot(event):
    conn = pymysql.connect(rds_host, user=name, passwd=password, db=db_name, connect_timeout=5)
    with conn.cursor() as cursor:    
        sql_Query = """CALL deleteParkinglot(%s)"""
        insert_tuple = event['params']['path']['parkinglotID']
        cursor.execute(sql_Query,insert_tuple)
        
        conn.commit()
        
        columns = [col[0] for col in cursor.description]
        rows = [dict(zip(columns, row)) for row in cursor.fetchall()]
        
        cursor.close()
        returnValue = json.dumps(rows,separators=(',', ':'))
        jsonOut = json.loads(returnValue)
        return(jsonOut)

def main(event, context):
    return deleteParkinglot(event)
        