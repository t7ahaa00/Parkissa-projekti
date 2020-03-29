import pymysql
import sys
import config
import json

REGION = config.region
rds_host  = config.db_host
name = config.db_username
password = config.db_password
db_name = config.db_name

def addParkinglot(event):

    conn = pymysql.connect(rds_host, user=name, passwd=password, db=db_name, connect_timeout=5)
    with conn.cursor() as cursor:    
        sql_Query = """INSERT INTO parkinglot VALUES(null,%s,%s,%s,%s);"""
        insert_tuple = event['params']['querystring']['lng'],event['params']['querystring']['lat'],event['params']['querystring']['name'],event['params']['querystring']['avaiblespace']
        
        try:
            cursor.execute(sql_Query,insert_tuple)
            conn.commit()
        except pymysql.IntegrityError:
            
            err = {
              "error": "error",
              "message": "name must be unique"
            }
            jsonOut = json.loads(json.dumps(err))
            return jsonOut
        finally:
            cursor.close()
        
        jsonOut = json.loads(json.dumps({"success":"success"}))
        return jsonOut

def main(event, context):
    return addParkinglot(event)
        