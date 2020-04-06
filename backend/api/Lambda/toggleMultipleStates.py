import pymysql
import sys
import config
import json

REGION = config.region
rds_host  = config.db_host
name = config.db_username
password = config.db_password
db_name = config.db_name

def toggleMultipleGridStates(event):
    conn = pymysql.connect(rds_host, user=name, passwd=password, db=db_name, connect_timeout=5)
    with conn.cursor() as cursor:
        inputString =''
        looper = 0
        lenght = len(event['body-json']['slots'])
        
        sql_Query = """SELECT idparkingarea from parkingarea where idparkingarea = %s"""
        insert_tuple = event['params']['path']['parkingareaID']
        cursor.execute(sql_Query,insert_tuple)
        columns = [col[0] for col in cursor.description]
        rows = [dict(zip(columns, row)) for row in cursor.fetchall()]
        
        if not rows:
            returnValue = json.dumps({'error':'parkingarea doesnt exist'})
            return(json.loads(returnValue))
        
            
        for items in event['body-json']['slots']:
            inputString = inputString + 'row='+str(items['row']) +' AND slot=' + str(items['grid']) + ' AND idparkingarea = ' + str(event['params']['path']['parkingareaID']) + ' OR ' 
                
        inputString = inputString[:-4]
        sql_Query = """UPDATE grid SET occupied = !occupied WHERE %s"""%inputString
        cursor.execute(sql_Query)
        conn.commit()
        returnValue = json.dumps({'success':'success'})
        return(json.loads(returnValue)) 
    
    
def main(event, context):
    return toggleMultipleGridStates(event)
        