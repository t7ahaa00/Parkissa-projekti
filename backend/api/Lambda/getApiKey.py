import pymysql
import sys
import config
import json
import random
import string

REGION = config.region
rds_host  = config.db_host
name = config.db_username
password = config.db_password
db_name = config.db_name


def getApiKey(event):
    conn = pymysql.connect(rds_host, user=name, passwd=password, db=db_name, connect_timeout=5)
    with conn.cursor() as cursor: 
        data = {}
        
        sql_Query = """SELECT * FROM api_keys WHERE ip = %s;"""
        insert_tuple = event["params"]["header"]["X-Forwarded-For"]
        try:
            cursor.execute(sql_Query,insert_tuple)
            conn.commit()
            columns = [col[0] for col in cursor.description]
            data = [dict(zip(columns, row)) for row in cursor.fetchall()]
        except pymysql.Error:
                print('MySQL Error')
        
        if not data:
            lettersAndDigits  = string.ascii_letters + string.digits
            success = False
            while not success:
                try:
                    APIKEY =  ''.join((random.choice(lettersAndDigits) for i in range(24)))
                    sql_Query = """INSERT INTO api_keys VALUES (null,%s,%s,%s,%s,0);"""
                    insert_tuple = APIKEY,event["params"]["header"]["X-Forwarded-For"],event["params"]["header"]["User-Agent"],event['context']['request-id']
                    cursor.execute(sql_Query,insert_tuple)
                    conn.commit()
                except pymysql.IntegrityError:
                    print('duplicate apikey')
                else:
                    success = True
                    returnValue = json.dumps({'x-api-key':APIKEY})
                    return(json.loads(returnValue))
        
        else:
            uses = data[0]['uses'] + 1
            sql_Query = """UPDATE api_keys SET uses = %s WHERE ip = %s AND api_key = %s;"""
            insert_tuple =  uses,event["params"]["header"]["X-Forwarded-For"],data[0]['api_key']
            cursor.execute(sql_Query,insert_tuple)
            conn.commit()
            
            response = {'x-api-key':data[0]['api_key'],
                        'uses' :data[0]['uses']}

            returnValue = json.dumps(response)
            return(json.loads(returnValue))


def main(event, context):
    return getApiKey(event)