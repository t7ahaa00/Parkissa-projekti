import pymysql
import sys
import config
import json
from decimal import Decimal

REGION = config.region
rds_host  = config.db_host
name = config.db_username
password = config.db_password
db_name = config.db_name



def default(obj):
    if isinstance(obj, Decimal):
        return float(obj)
    raise TypeError("Object of type '%s' is not JSON serializable" % type(obj).__name__)
    
def getFreeGrids(event):
    conn = pymysql.connect(rds_host, user=name, passwd=password, db=db_name, connect_timeout=5)
    with conn.cursor() as cursor:    
        sql_Query = """CALL getFreeSlots(%s)"""
        insert_tuple = event['params']['path']['parkingareaID']
        cursor.execute(sql_Query,insert_tuple)
        columns = [col[0] for col in cursor.description]
        info = [dict(zip(columns, row)) for row in cursor.fetchall()]
        
        sql_Query = """SELECT idparkingarea,slot,occupied,lat,lng FROM grid WHERE occupied = 0 AND idparkingarea = %s """
        insert_tuple = event['params']['path']['parkingareaID']
        cursor.execute(sql_Query,insert_tuple)
        columns = [col[0] for col in cursor.description]
        freeGrids = [dict(zip(columns, row)) for row in cursor.fetchall()]
        
        cursor.close()
        
        data = { 'info':info, 'freeGrids':freeGrids }
        returnValue = json.dumps(data,separators=(',', ':'),default=default)
        jsonOut = json.loads(returnValue)
        return(jsonOut)

def main(event, context):
    return getFreeGrids(event)
        