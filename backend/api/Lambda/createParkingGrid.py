import pymysql
import sys
import config
import json

REGION = config.region
rds_host  = config.db_host
name = config.db_username
password = config.db_password
db_name = config.db_name

def createGrid(event):

    result = []
    conn = pymysql.connect(rds_host, user=name, passwd=password, db=db_name, connect_timeout=5)
    with conn.cursor() as cursor: 
        
        sql_Query = """SELECT idparkinglot from parkinglot where idparkinglot = %s"""
        insert_tuple = event['params']['path']['parkinglotID']
        cursor.execute(sql_Query,insert_tuple)
        columns = [col[0] for col in cursor.description]
        rows = [dict(zip(columns, row)) for row in cursor.fetchall()]
        
        if not rows:
            returnValue = json.dumps({'error':'parkinglot doesnt exist'})
            return(json.loads(returnValue))
        
        sql_Query = """SELECT idparkingarea from parkingarea where idparkingarea = %s"""
        insert_tuple = event['params']['path']['parkingareaID']
        cursor.execute(sql_Query,insert_tuple)
        columns = [col[0] for col in cursor.description]
        rows = [dict(zip(columns, row)) for row in cursor.fetchall()]
        
        if not rows:
            returnValue = json.dumps({'error':'parkingarea doesnt exist'})
            return(json.loads(returnValue))
        
        
        sql_Query = """SELECT * from grid where idparkingarea = %s"""
        insert_tuple = event['params']['path']['parkingareaID']
        cursor.execute(sql_Query,insert_tuple)
        columns = [col[0] for col in cursor.description]
        rows = [dict(zip(columns, row)) for row in cursor.fetchall()]
        
        
        if rows:
            returnValue = json.dumps({'error':'grid already exists'})
            return(json.loads(returnValue))
        else:
            inputString =''
            looper = 0
            lenght = len(event['body-json']['slots'])
            for items in event['body-json']['slots']:
                for x in range(1,items['slots']+1):
                    inputString = inputString + '('+ event['params']['path']['parkingareaID'] + ',null,'+str(items['row']) +',' + str(x) +',0),'
                
            inputString = inputString[:-1]
            sql_Query = """INSERT INTO grid(idparkingarea, idgrid, row, slot, occupied) VALUES %s"""%inputString
            cursor.execute(sql_Query)
            conn.commit()
            returnValue = json.dumps({'success':'success'})
            return(json.loads(returnValue)) 

def main(event, context):
    return createGrid(event)
        