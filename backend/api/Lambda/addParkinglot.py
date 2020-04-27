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
        
        
        #Parkinglot koodi
        createdNewParkinglot = False
        parkinglotID = -1
        sql_Query = """SELECT * FROM parkinglot WHERE name = %s AND city = %s;"""
        insert_tuple = event['body-json']['name'],event['body-json']['city']
        try:
            cursor.execute(sql_Query,insert_tuple)
            conn.commit()
            columns = [col[0] for col in cursor.description]
            data = [dict(zip(columns, row)) for row in cursor.fetchall()]
        except pymysql.Error:
                print('Error')
        
        if not data:
            sql_Query = """INSERT INTO parkinglot VALUES(null,%s,%s);"""
            insert_tuple = event['body-json']['name'],event['body-json']['city']
            try:
                cursor.execute(sql_Query,insert_tuple)
                conn.commit()
            except pymysql.IntegrityError:
                print('parkinglot with that name already exists')
            createdNewParkinglot = True
            parkinglotID = cursor.lastrowid
            
        else:
            
            try:
                event['params']['header']['confirmation']
            except KeyError:
                returnValue = json.dumps({'error':'parkinglot with that name existed, add header confirmation = 1 to confirm adding new area'})  
                return(json.loads(returnValue))
  
            if int(event['params']['header']['confirmation']) != 1:
                returnValue = json.dumps({'error':'parkinglot with that name existed, add header confirmation = 1 to confirm adding new area'})
                return(json.loads(returnValue))
            else:
                sql_Query = """SELECT idparkinglot FROM parkinglot WHERE name = %s AND city = %s;"""
                insert_tuple = event['body-json']['name'],event['body-json']['city']
                try:
                    cursor.execute(sql_Query,insert_tuple)
                    conn.commit()
                    columns = [col[0] for col in cursor.description]
                    data = [dict(zip(columns, row)) for row in cursor.fetchall()]
                except pymysql.Error:
                    print('Error')
                parkinglotID = int(data[0]['idparkinglot'])


            

        sql_Query = """SELECT id FROM parkingarea WHERE idparkinglot = %s ORDER BY idparkingarea DESC LIMIT 1 ;"""
        insert_tuple = parkinglotID
        cursor.execute(sql_Query,insert_tuple)
        conn.commit()
        columns = [col[0] for col in cursor.description]
        data = [dict(zip(columns, row)) for row in cursor.fetchall()]
        
        if not data:
            id=1
        else:
            id = int(data[0]['id']+1)
            
            
        
        sql_Query = """INSERT INTO parkingarea VALUES(%s,null,%s,%s);"""
        insert_tuple = parkinglotID,id,0  
        cursor.execute(sql_Query,insert_tuple)
        conn.commit()
        parkingareaID = cursor.lastrowid


        inputString =''
        looper = 0
        slotCount = 0
        try:
            for items in event['body-json']['slots']:
                inputString = inputString + '('+ str(parkingareaID) + ',null,' + str(items['slot']) +',1,' + str(items['center']['lat']) +',' + str(items['center']['lng']) +'),'
                slotCount = slotCount +1
        except TypeError:
            returnValue = json.dumps({'error':'there must be at least 2 parking grids'})
            return(json.loads(returnValue))  
        inputString = inputString[:-1]
        sql_Query = """INSERT INTO grid(idparkingarea, idgrid, slot, occupied, lat, lng) VALUES %s"""%inputString
        sql_Query2 = """UPDATE parkingarea SET avaiblespace = %s WHERE idparkingarea = %s"""
        insert_tuple2 = slotCount, parkingareaID
        cursor.execute(sql_Query)
        conn.commit()
        cursor.execute(sql_Query2,insert_tuple2)
        conn.commit()
        returnValue = json.dumps({'success':'success',
                                  'created new parkinglot':createdNewParkinglot,
                                  'parkinglotID':parkinglotID,
                                  'parkingareaID':parkingareaID,
                                  'parkingareaNumber':id,
                                  'added slots':slotCount
                                  
        })
        return(json.loads(returnValue))

def main(event, context):
    return addParkinglot(event)
        