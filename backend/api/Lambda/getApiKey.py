import json

def lambda_handler(event, context):
    json_out = json.dumps({'x-api-key':'Huipusalainen salasana'})
    return(json.loads(json_out))
