import pymysql
import sys
import config
import json

REGION = config.region
rds_host  = config.db_host
name = config.db_username
password = config.db_password
db_name = config.db_name

def getTestParkinglots(event):

    conn = pymysql.connect(rds_host, user=name, passwd=password, db=db_name, connect_timeout=5)
    with conn.cursor() as cursor:
        output ={}
        sql_Query = """SELECT * FROM parkinglot WHERE name LIKE 'test%'"""
        cursor.execute(sql_Query)
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
                sql_Query = """SELECT * FROM grid WHERE idparkingarea = %s """
                insert_tuple3 = item['idparkingarea']
                cursor.execute(sql_Query,insert_tuple3)
                columns = [col[0] for col in cursor.description]
                slots = [dict(zip(columns, row)) for row in cursor.fetchall()]
                
                parkingareas[loopIndex2]["slots"] = slots
                loopIndex2+=1
            
            parkinglots[loopIndex]["parkingareas"] = parkingareas
            loopIndex+=1    
           
        
        cursor.close()
        returnValue = json.dumps(parkinglots,separators=(',', ':'))
        jsonOut = json.loads(returnValue)
        return(jsonOut)

def main(event, context):
    return getTestParkinglots(event)
        