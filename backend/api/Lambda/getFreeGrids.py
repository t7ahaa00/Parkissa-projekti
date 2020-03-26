import pymysql
import sys
import config
import json

REGION = config.region
rds_host  = config.db_host
name = config.db_username
password = config.db_password
db_name = config.db_name

def getParkkialueet(event):
    conn = pymysql.connect(rds_host, user=name, passwd=password, db=db_name, connect_timeout=5)
    with conn.cursor() as cursor:    
        sql_Query = """CALL getFreeSlots( %s)"""
        insert_tuple = event['params']['path']['parkinglotID']
        cursor.execute(sql_Query,insert_tuple)
        columns = [col[0] for col in cursor.description]
        info = [dict(zip(columns, row)) for row in cursor.fetchall()]
        
        sql_Query = """SELECT * FROM grid WHERE occupied = 0 AND idparkinglot = %s"""
        insert_tuple = event['params']['path']['parkinglotID']
        cursor.execute(sql_Query,insert_tuple)
        columns = [col[0] for col in cursor.description]
        freeGrids = [dict(zip(columns, row)) for row in cursor.fetchall()]
        
        cursor.close()
        
        data = { 'info':info, 'freeGrids':freeGrids }
        returnValue = json.dumps(data)
        jsonOut = json.loads(returnValue)
        print ("Data from RDS...")
        print (data)
        return(jsonOut)

def main(event, context):
    return getParkkialueet(event)
        