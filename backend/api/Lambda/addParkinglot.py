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
        inputString =''
        sql_Query = """INSERT INTO parkinglot VALUES(null,%s);"""
        insert_tuple = event['body-json']['name']
        try:
            cursor.execute(sql_Query,insert_tuple)
            conn.commit()
        except pymysql.IntegrityError:
            print('parkinglot with that name exists')
        
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
            
            sql_Query = """INSERT INTO parkingarea VALUES(%s,null,%s,%s,%s);"""
            insert_tuple = parkinglotID,event['body-json']['areaID'],event['body-json']['avaibleSlots'],event['body-json']['orientation']
            
            try:
                cursor.execute(sql_Query,insert_tuple)
                conn.commit()
                parkigAreaId=cursor.lastrowid
                for items in event['body-json']['path']:
                    inputString = inputString + '(' + str(parkigAreaId) + ',null,' + str(items['lat'])+',' + str(items['lng']) + '),';
                inputString = inputString[:-1]
                sql_Query = """INSERT INTO path(idparkingarea, idpath, lat, lng) VALUES %s;"""%inputString
                try:
                    cursor.execute(sql_Query)
                    conn.commit()
                except pymysql.Error as e:
                    err = {
                      "error": "couldn't create path",
                      "errormsg": str(e)
                    }
                    jsonOut = json.loads(json.dumps(err))
                    return jsonOut

                
            except pymysql.Error as e:
                err = {
                  "error": "couldn't create parkingarea",
                  "errormsg": str(e)
                }
                jsonOut = json.loads(json.dumps(err))
                return jsonOut
            
            sql_Query2 = """SELECT idparkinglot,idparkingarea FROM parkingarea WHERE idparkinglot = %s AND id = %s;"""
            insert_tuple2 = parkinglotID,event['body-json']['areaID']
            cursor.execute(sql_Query2,insert_tuple2)
            conn.commit()
            columns = [col[0] for col in cursor.description]
            data = [dict(zip(columns, row)) for row in cursor.fetchall()]
            
            returnValue = json.dumps(data)
            jsonOut = json.loads(returnValue)
            return(jsonOut)
        else:
            err = {
                 "error": "duplicate id"
                }
            jsonOut = json.loads(json.dumps(err))
            return jsonOut
def main(event, context):
    return addParkinglot(event)
        