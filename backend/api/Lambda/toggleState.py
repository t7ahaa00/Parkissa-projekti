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

def toggleGridState(event):
    conn = pymysql.connect(rds_host, user=name, passwd=password, db=db_name, connect_timeout=5)
    with conn.cursor() as cursor:  
        
        #API:keyn tarkistaminen
        sql_Query = """SELECT api_key FROM api_keys WHERE ip = %s;"""
        insert_tuple = event["params"]["header"]["X-Forwarded-For"]
        try:
            cursor.execute(sql_Query,insert_tuple)
            conn.commit()
            columns = [col[0] for col in cursor.description]
            data = [dict(zip(columns, row)) for row in cursor.fetchall()]
            print(data)
            print("ip=" + event["params"]["header"]["X-Forwarded-For"])
            print("api_key =" + event["params"]["header"]['x-api-key'])
        except pymysql.Error:
                print('MySQL Error')
                
        if not data:
            raise Exception({
                    "errorType" : "Exception",
                    "httpStatus": 403,
                    "message": "No api_key for that ip "
                })      

        if str(event["params"]["header"]['x-api-key']) != str(data[0]["api_key"]): 
            raise Exception({
                    "errorType" : "Exception",
                    "httpStatus": 403,
                    "message": "Incorrect api key"
                })
        
        if event['context']['http-method'] == 'PATCH':
            sql_Query = """SELECT * FROM parkingarea WHERE idparkingarea = %s"""
            insert_tuple = event['params']['path']['parkingareaID']
            cursor.execute(sql_Query,insert_tuple)
            columns = [col[0] for col in cursor.description]
            data = [dict(zip(columns, row)) for row in cursor.fetchall()]
            if not data:
                returnValue = json.dumps({
                    'error':'no parkingarea with that ID'
                })
                return(json.loads(returnValue))
            
            sql_Query = """CALL toggleState(%s,%s)"""
            insert_tuple = event['params']['path']['parkingareaID'],event['params']['path']['slot']
            cursor.execute(sql_Query,insert_tuple)
            conn.commit()
            columns = [col[0] for col in cursor.description]
            data = [dict(zip(columns, row)) for row in cursor.fetchall()]
            returnValue = json.dumps(data,default=default)
            jsonOut = json.loads(returnValue)
            return(jsonOut)
        
        elif event['context']['http-method'] == 'GET':
            
            sql_Query = """SELECT idparkingarea, slot, occupied, lat, lng FROM grid WHERE idparkingarea = %s AND slot = %s"""
            insert_tuple = event['params']['path']['parkingareaID'],event['params']['path']['slot']
            cursor.execute(sql_Query,insert_tuple)
            columns = [col[0] for col in cursor.description]
            data = [dict(zip(columns, row)) for row in cursor.fetchall()]
            returnValue = json.dumps(data,default=default)
            jsonOut = json.loads(returnValue)
            if not data:
                returnValue = json.dumps({
                    'error':'no grid with those params'
                })
                return(json.loads(returnValue))
            return(jsonOut)
            
def main(event, context):
    return toggleGridState(event)
        