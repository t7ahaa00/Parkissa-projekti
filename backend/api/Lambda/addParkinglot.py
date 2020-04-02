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
        parkinglotID = -1
        sql_Query = """INSERT INTO parkinglot VALUES(null,%s);"""
        insert_tuple = event['body-json']['name']
        try:
            cursor.execute(sql_Query,insert_tuple)
            conn.commit()
        except pymysql.IntegrityError:
            print('duplikaatti nimi')
        
        sql_Query = """SELECT idparkinglot FROM parkinglot WHERE name = %s;"""
        cursor.execute(sql_Query,insert_tuple)
        conn.commit()
        columns = [col[0] for col in cursor.description]
        data = [dict(zip(columns, row)) for row in cursor.fetchall()]
        parkinglotID = int(data[0]['idparkinglot'])
        
        sql_Query ="""SELECT idparkinglot,id FROM parkingarea WHERE idparkinglot = %s AND id = %s;"""
        insert_tuple2 = parkinglotID,event['body-json']['areaID']
        cursor.execute(sql_Query,insert_tuple2)
        conn.commit()
        columns = [col[0] for col in cursor.description]
        data = [dict(zip(columns, row)) for row in cursor.fetchall()]
        if len(data) == 0:
            sql_Query = """INSERT INTO parkingarea VALUES(%s,null,%s,%s,%s,%s,%s,%s);"""
            insert_tuple = parkinglotID,event['body-json']['areaID'],event['body-json']['lat1'],event['body-json']['lng1'],event['body-json']['lat2'], event['body-json']['lng2'],event['body-json']['avaibleSlots']
            
            try:
                cursor.execute(sql_Query,insert_tuple)
                conn.commit()
            except pymysql.Error as e:
                err = {
                  "error": "error",
                  "message": "couldn't create parkingarea coordinates must be unique",
                  "errormsg": str(e)
                }
                jsonOut = json.loads(json.dumps(err))
                return jsonOut
            
            
            sql_Query2 = """SELECT idparkingarea FROM parkingarea WHERE idparkinglot = %s AND id = %s;"""
            insert_tuple2 = parkinglotID,event['body-json']['areaID']
            cursor.execute(sql_Query2,insert_tuple2)
            conn.commit()
            columns = [col[0] for col in cursor.description]
            data = [dict(zip(columns, row)) for row in cursor.fetchall()]
            
            returnValue = json.dumps(data)
            jsonOut = json.loads(returnValue)
            return(jsonOut)
        else:
            sql_Query = """UPDATE parkingarea SET lat1=%s,lng1=%s,lat2=%s,lnf2=%s,avaiblespace= %s WHERE WHERE idparkinglot = %s AND id = %s;"""
            insert_tuple = event['body-json']['lat1'],event['body-json']['lng1'],event['body-json']['lat2'], event['body-json']['lng2'],event['body-json']['avaibleSlots'],parkinglotID,event['body-json']['areaID']
        
            err = {
                 "error": "error",
                 "message": "duplicate id updated old one instead",
                }
            jsonOut = json.loads(json.dumps(err))
            return jsonOut
def main(event, context):
    return addParkinglot(event)
        