import pymysql
import sys
import config
import json

REGION = config.region
rds_host  = config.db_host
name = config.db_username
password = config.db_password
db_name = config.db_name

def getParkinglot(event):

    conn = pymysql.connect(rds_host, user=name, passwd=password, db=db_name, connect_timeout=5)
    with conn.cursor() as cursor:
        output ={}
        sql_Query = """SELECT * FROM parkinglot WHERE idparkinglot = %s"""
        insert_tuple2 = insert_tuple = event['params']['path']['parkinglotID']
        cursor.execute(sql_Query,insert_tuple)
        conn.commit()
        columns = [col[0] for col in cursor.description]
        parkinglots = [dict(zip(columns, row)) for row in cursor.fetchall()]     
        loopIndex = 0
        
        for item in parkinglots:
            insert_tuple2 = []
            sql_Query = """SELECT * FROM parkingarea WHERE idparkinglot = %s"""
            insert_tuple2 = item['idparkinglot']
            cursor.execute(sql_Query,insert_tuple2)
            columns = [col[0] for col in cursor.description]
            parkingareas = [dict(zip(columns, row)) for row in cursor.fetchall()]
            loopIndex2 = 0
            
            for item in parkingareas:
                insert_tuple3 = []
                sql_Query = """SELECT DISTINCT(row) AS rowNumber FROM grid WHERE idparkingarea = %s """
                insert_tuple3 = item['idparkingarea']
                cursor.execute(sql_Query,insert_tuple3)
                columns = [col[0] for col in cursor.description]
                rowCount = [dict(zip(columns, row)) for row in cursor.fetchall()]            
                loopIndex3 = 0
            
                for itemrow in rowCount:
                    insert_tuple4 = []
                    sql_Query = """SELECT idparkingarea,idgrid,slot,occupied FROM grid WHERE idparkingarea = %s AND row = %s """
                    insert_tuple4 = item['idparkingarea'],itemrow['rowNumber']
                    cursor.execute(sql_Query,insert_tuple4)
                    columns = [col[0] for col in cursor.description]
                    slots = [dict(zip(columns, row)) for row in cursor.fetchall()]
                    
                    rowCount[loopIndex3]["row"] = slots
                    loopIndex3+=1
                
                parkingareas[loopIndex2]["slots"] = rowCount
                loopIndex2+=1
            
            parkinglots[loopIndex]["parkingareas"] = parkingareas
            loopIndex+=1    
                 
        cursor.close()
        returnValue = json.dumps(parkinglots,separators=(',', ':'))
        jsonOut = json.loads(returnValue)
        return(jsonOut)

def main(event, context):
    return getParkinglot(event)
        