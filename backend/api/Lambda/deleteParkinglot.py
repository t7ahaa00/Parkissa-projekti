import pymysql
import sys
import config
import json

REGION = config.region
rds_host  = config.db_host
name = config.db_username
password = config.db_password
db_name = config.db_name

def deleteParkinglot(event):
    conn = pymysql.connect(rds_host, user=name, passwd=password, db=db_name, connect_timeout=5)
    with conn.cursor() as cursor:    
        

        #API:keyn tarkistaminen
        sql_Query = """SELECT * FROM api_keys WHERE ip = %s AND api_key = %s;"""
        insert_tuple = event["params"]["header"]["X-Forwarded-For"],event["params"]["header"]['x-api-key']
        try:
            cursor.execute(sql_Query,insert_tuple)
            conn.commit()
            columns = [col[0] for col in cursor.description]
            data = [dict(zip(columns, row)) for row in cursor.fetchall()]
        except pymysql.Error:
                print('MySQL Error')
        
        if not data: 
                raise Exception({
                        "errorType" : "Exception",
                        "httpStatus": 403,
                        "message": "Incorrect api "
                    })
                    
        sql_Query = """CALL deleteParkinglot(%s)"""
        insert_tuple = event['params']['path']['parkinglotID']
        cursor.execute(sql_Query,insert_tuple)
        
        conn.commit()
        
        columns = [col[0] for col in cursor.description]
        rows = [dict(zip(columns, row)) for row in cursor.fetchall()]
        
        cursor.close()
        returnValue = json.dumps(rows,separators=(',', ':'))
        jsonOut = json.loads(returnValue)
        return(jsonOut)

def main(event, context):
    return deleteParkinglot(event)
        