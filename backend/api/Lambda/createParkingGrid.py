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
            slotCount = 0
            for items in event['body-json']['slots']:
                inputString = inputString + '('+ event['params']['path']['parkingareaID'] + ',null,' + str(items['slot']) +',1,' + str(items['lat']) +',' + str(items['lng']) +'),'
                slotCount = slotCount +1
                
            inputString = inputString[:-1]
            sql_Query = """INSERT INTO grid(idparkingarea, idgrid, slot, occupied, lat, lng) VALUES %s"""%inputString
            sql_Query2 = """UPDATE parkingarea SET avaiblespace = %s WHERE idparkingarea = %s"""
            insert_tuple2 = slotCount, event['params']['path']['parkingareaID']
            cursor.execute(sql_Query)
            conn.commit()
            cursor.execute(sql_Query2,insert_tuple2)
            conn.commit()
            returnValue = json.dumps({'success':'success',
                                    'added slots':slotCount })
            return(json.loads(returnValue)) 

def main(event, context):
    return createGrid(event)
        