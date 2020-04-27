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

def getParkinglot(event):
    conn = pymysql.connect(rds_host, user=name, passwd=password, db=db_name, connect_timeout=5)
    with conn.cursor() as cursor:
        sql_Query = """SELECT * FROM parkinglot """
        cursor.execute(sql_Query)
        conn.commit()
        columns = [col[0] for col in cursor.description]
        parkinglots = [dict(zip(columns, row)) for row in cursor.fetchall()]
        
        loopIndex = 0
        
        for item in parkinglots:
            sql_Query = """SELECT idparkingarea,id,avaiblespace,orientation FROM parkingarea WHERE idparkinglot = %s"""
            insert_tuple2 = item['idparkinglot']
            cursor.execute(sql_Query,insert_tuple2)
            columns = [col[0] for col in cursor.description]
            parkingareas = [dict(zip(columns, row)) for row in cursor.fetchall()]
            
            loopIndex2 = 0

            for item in parkingareas:
                
                sql_Query = """SELECT lat,lng FROM path WHERE idparkingarea = %s"""
                insert_tuple3 = item['idparkingarea']
                cursor.execute(sql_Query,insert_tuple3)
                columns = [col[0] for col in cursor.description]
                path = [dict(zip(columns, row)) for row in cursor.fetchall()]
                
                parkingareas[loopIndex2]["path"] = path

                sql_Query = """SELECT slot, occupied FROM grid WHERE idparkingarea = %s"""
                insert_tuple3 = item['idparkingarea']
                cursor.execute(sql_Query,insert_tuple3)
                columns = [col[0] for col in cursor.description]
                slots = [dict(zip(columns, row)) for row in cursor.fetchall()]
               
                sql_Query = """SELECT lat, lng FROM grid WHERE idparkingarea = %s"""
                insert_tuple3 = item['idparkingarea']
                cursor.execute(sql_Query,insert_tuple3)
                columns = [col[0] for col in cursor.description]
                slotCenters = [dict(zip(columns, row)) for row in cursor.fetchall()]      
                
                loopIndex3 = 0
                for slot in slots:
                    slot['center'] = slotCenters[loopIndex3]
                    loopIndex3+=1 
                
                
                parkingareas[loopIndex2]["slots"] = slots
                loopIndex2+=1
                
            parkinglots[loopIndex]["parkingareas"] = parkingareas
            loopIndex+=1    
           
        cursor.close()
        response = {}
        response = parkinglots
        returnValue = json.dumps(response,separators=(',', ':'),default=default)
        jsonOut = json.loads(returnValue)
        return(jsonOut)

def main(event, context):
    return getParkinglot(event)
        
        