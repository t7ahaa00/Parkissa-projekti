import pymysql
import sys
import config
import json
import boto3

REGION = config.region
rds_host  = config.db_host
name = config.db_username
password = config.db_password
db_name = config.db_name

BUCKET_NAME = 'parkissaimages'

def getParkinglot(jsonDataFreeSlots,jsonDataCameraInfo,parkinglotID,areaID,firstSlot,lastSlot):
    #luodaan mysql yhteys
    conn = pymysql.connect(rds_host, user=name, passwd=password, db=db_name, connect_timeout=5)
    inputString =''
    with conn.cursor() as cursor:
        #luodaan input string vapaille paikoille
        for items in jsonDataFreeSlots:
            inputString = inputString +'slot=' + str(items['grid']) + ' AND idparkingarea = ' + areaID + ' OR ' 
        #poistetaan ylimääräinen OR lopusta
        inputString = inputString[:-4]

        
        #asetetaan kaikki paikat välillä suurin ja pienin paikka varatuiksi
        sql_Query = """UPDATE grid SET occupied = 1 WHERE idparkingarea = %s AND slot >=  %s AND slot <=  %s """
        args = areaID,firstSlot,lastSlot
        cursor.execute(sql_Query,args)
        conn.commit()
            
        #asetetaan kaikki json tidostossa olleet vapaat paikat vapaiksi
        sql_Query = """UPDATE grid SET occupied = 0 WHERE %s"""%inputString
        cursor.execute(sql_Query)
        conn.commit()
        
        return('ok')

def main(event, context):
    s3 = boto3.resource('s3')
    bucket = s3.Bucket(BUCKET_NAME)
    
    #ottaa eventistä json tiedoston polun
    
    
    for record in event['Records']:
        bucketName = str(record['s3']['bucket']['name'])
        key = record['s3']['object']['key']
        eventTime = record['eventTime']
    
    #key = 'images/4/1/Opticam_O5_00626EE9980F/snap/camera1_20200505-163429.jpg' 
    
    #tekee polun samaan tiedoston josta kamera katsoo pisteiden koordinaatit
    #tämän avulla saadaan suurimman ja pienimmän ruudun id
    folder, parkinglotID, areaID, model, snap, image = key.split('/')
    cameraNumber,timestampAndImageType=image.split('_')
    timestamp, imageType = timestampAndImageType.split('.')
    cameraInfoPath = 'json/%s/%s/%s.json'%(parkinglotID,areaID,cameraNumber)
    print ( "parkinglotID=" + parkinglotID + ",areaID=" + areaID + ",cameraNumber" + cameraNumber + ",cameraInfoPath=" + cameraInfoPath)
    #hakee datan ensimmäisestä json tiedostosta jossa on vapaat paikat
    obj = bucket.Object(key)
    response = obj.get()
    jsonDataFreeSlots = response['Body'].read()
    jsonDataFreeSlots = str(jsonDataFreeSlots)
    jsonDataFreeSlots = jsonDataFreeSlots.replace("b","")
    jsonDataFreeSlots = jsonDataFreeSlots.replace("'","")
    jsonDataFreeSlots.strip("\\r\\n")
 
    print(jsonDataFreeSlots)
    jsonDataFreeSlots = json.loads(jsonDataFreeSlots)
    
    #hakee datan toisesta json tiedostosta jossa on kameran mahdolliset paikat
    print('camera info path = ' + cameraInfoPath)
    obj = bucket.Object(cameraInfoPath)
    response = obj.get()
    jsonDataCameraInfo = response['Body'].read()
    jsonDataCameraInfo = str(jsonDataCameraInfo)
    jsonDataCameraInfo = jsonDataCameraInfo.replace("b","")
    jsonDataCameraInfo = jsonDataCameraInfo.replace("'","")
    jsonDataCameraInfo.strip("\\r\\n")
    print(jsonDataCameraInfo)
    jsonDataCameraInfo = json.loads(jsonDataCameraInfo)
    
    firstSlot = -1
    lastSlot = -1
    
    #haetaan ensimmäinen ja viimeinen ruutu
    lenght = len(jsonDataCameraInfo)
    firstSlot = jsonDataCameraInfo[0]['sId']
    lastSlot = jsonDataCameraInfo[lenght-1]['sId']

    print('jsonDataFreeSlots = ' + str(jsonDataFreeSlots))
    print('jsonDataCameraInfo = ' + str(jsonDataCameraInfo))
    print('first slot = ' + str(firstSlot))
    print('lastSlot = ' + str(lastSlot))
    
    #aiemmin määritelty funktion, joka tallentaa datan tietokantaan
    return getParkinglot(jsonDataFreeSlots['slots'],jsonDataCameraInfo,parkinglotID,areaID,firstSlot,lastSlot)
        