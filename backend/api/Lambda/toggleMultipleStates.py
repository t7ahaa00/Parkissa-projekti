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
        inputString2 =''
        looper = 0
        lenght = len(event['body-json']['slots'])
        
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
        sql_Query = """SELECT idparkingarea FROM parkingarea WHERE idparkingarea = %s"""
        insert_tuple = event['params']['path']['parkingareaID']
        cursor.execute(sql_Query,insert_tuple)
        columns = [col[0] for col in cursor.description]
        rows = [dict(zip(columns, row)) for row in cursor.fetchall()]
        
        if not rows:
            returnValue = json.dumps({
                'error':'parkingarea with that id doesnt exist'
            })
            return(json.loads(returnValue))
        
            
        for items in event['body-json']['slots']:
            inputString = inputString +'slot=' + str(items['slot']) + ' AND idparkingarea = ' + str(event['params']['path']['parkingareaID']) + ' OR ' 

        inputString = inputString[:-4]
        
        sql_Query = """UPDATE grid SET occupied = 1 WHERE idparkingarea = %s"""
        args = event['params']['path']['parkingareaID']
        cursor.execute(sql_Query,args)
        conn.commit()
        sql_Query = """UPDATE grid SET occupied = 0 WHERE %s"""%inputString
        cursor.execute(sql_Query)
        conn.commit()
        returnValue = json.dumps({'success':'success'})
        return(json.loads(returnValue)) 
    
    
def main(event, context):
    return toggleMultipleGridStates(event)
        