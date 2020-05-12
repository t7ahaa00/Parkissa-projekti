import boto3
from datetime import datetime

def lambda_handler(event, context):
    images = []
    MD5s = []
    delete_batch = []
    
    sqs_client = boto3.client('sqs')
    
    #tämä koko palikka ikilooppiin
    #hae 10 uusinta viestiä
    resp = sqs_client.receive_message(
        QueueUrl='https://sqs.eu-west-1.amazonaws.com/997880591872/newImage',
        MessageAttributeNames=['All'],
        AttributeNames=['All'],
        MaxNumberOfMessages=10
    )  
    
    try:
        #lisää images arrayseen vain viestit joissa mukana MessageAttributes
        print('haettiin ' + str(len(resp['Messages']))+  ' viestiä')
        
        for message in resp['Messages']:
            delete_batch.append({'Id': message['MessageId'],'ReceiptHandle': message['ReceiptHandle']})
            #postaa duplikaatit (vertailee MD5 hashejä)
            if any(d['MD5'] == message['MD5OfMessageAttributes'] for d in MD5s):    
                print('duplicate')
            else:
                #jos ei duplikaatti lisätään images listaan uusi kuva ja MD5 listaan sen MD5 hash    
                images.append(message['MessageAttributes'])
                MD5s.append({"MD5":message['MD5OfMessageAttributes'],"timestamp":datetime.now()})
                #lähetä uusi message['MessageAttributes'] objekti kuvan analysointiin asynccina -> decoodaa base 64 kuva ja ota Attribuuteista kaikki tarpeellinen tieto
                #selvitellään sitten myöhemmässä vaiheessa miten saadaan se json data pihalle :D
           
            #poistaa juuri käsitellyt viestit queuesta
            if delete_batch:
                sqs_client.delete_message_batch(QueueUrl='https://sqs.eu-west-1.amazonaws.com/997880591872/newImage', Entries=delete_batch)
                print('postettiin ' + str(len(delete_batch))+  ' viestiä')
                delete_batch = []
    except KeyError:
        print('No messages on the queue!')
    
    #tänne vanhentuneiden MD5 hashien poisto ja takaisin alkuun
    
    #tähän loppuisi looppi
   
    #lambda debuggailua varten   
    print(MD5s)
    return images
