import os
import json
from datetime import datetime
import boto3


def delete_file(bucket, key):
    s3 = boto3.client('s3')
    s3.delete_object(
        Bucket=bucket,
        Key=key
    )
    
    print('ELIMINANDO ARCHIVO ' + key + ' DESDE EL BUCKET ' + bucket)

def copy_file(source_bucket: str, source_key:str, destination_bucket:str, destination_key:str):
    s3_r = boto3.resource('s3')
    copy_source = {
        'Bucket': source_bucket,
        'Key': source_key
    }
    
    try:
        print("before copy")
        s3_r.meta.client.copy(copy_source, destination_bucket, destination_key)
        print("after copy")
    except Exception as e:
        print("error al copiar::", e)
        print("copy source::", copy_source)
        print("dest bucket::", destination_bucket)
        print("bestination key::", destination_key)
        raise
    print(f"MOVIENDO ARCHIVO {source_key} DESDE EL BUCKET {source_bucket} HACIA {destination_bucket}/{destination_key}")

def save_json(bucket, key_json, json_object):
    """
    Guarda [json_object] con nombre [key_json] en el [bucket] específicado
    
    Args: 
    bucket: bucket en el que se quiere guardar
    key_json: nombre con el que se va a guardar el archivo en el [bucket]
    json_object: objecto json (realmente esto es un diccionario python y se convertirá a json - @TODO arreglar luego)
    
    return:
    None
    """
    
    s3_r = boto3.resource('s3')
    print("buekt::", bucket)
    s3object= s3_r.Object(bucket, key_json)
    s3object.put(Body=(bytes(json.dumps(json_object).encode('UTF-8'))))
    print('GUARDANDO JSON ' + key_json + ' EN EL BUCKET ' + bucket)

def lambda_handler(event, context):
    begin_time = datetime.now()
    
    s3 = boto3.client('s3')
    bucket = event['Bucket']
    key = event['Key']
    json_file = s3.get_object(Bucket=bucket, Key=key)
    body = json_file['Body'].read().decode("utf-8")
    json_object = json.loads(body)
    print("json object::", json_object)

    #borra el json del bucket landing
    delete_file(bucket, key)

    database = json_object['database']
    db_type = json_object['db_type']
    schema = json_object['schema']
    table = json_object['table']
    partitioned = json_object['partitioned']
    destination_bucket = json_object['parameters']['destination_bucket']
    destination_bucket_metrics = json_object['parameters']['destination_bucket_metrics']
    gluejobname = json_object['parameters']['gluejobname']
    prefix = json_object['parameters']['prefix']
    iac_manager = json_object['parameters']['iac_manager']

    destination_folder = db_type + '/' + database + '/' + schema + '/' + table + '/'
    
    try:
        try:
            s3 = boto3.client('s3')
            list_files_to_delete = s3.list_objects(
                Bucket=destination_bucket,
                Delimiter=',',
                Prefix='ORC/' + destination_folder
            )

            list_files_to_delete = list_files_to_delete['Contents']
                
            for file in list_files_to_delete:
                delete_file(destination_bucket, file['Key'])
        except Exception as e:
            print(e)
            pass

        ## mueve orc destino
        for file in json_object['files']:
            name_file = file['name']
            root = os.path.dirname(key)
            copy_file(bucket, root + '/' + name_file, destination_bucket, 'ORC/' + destination_folder + name_file)
            delete_file(bucket, root + '/' + name_file)    
    except Exception as e:
        print("Error::", e)
        pass

    ## se modifica json con step nuevo
    process = {
        'step': 'move',
        'start_time': str(begin_time).split(".")[0],
        'end_time': str(datetime.now()).split(".")[0],
        'status': 'OK'
    }

    ## guarda json en bucket de metricas
    json_object['process'].append(process)
    name_json = os.path.basename(key)
    save_json(destination_bucket_metrics, destination_folder + name_json, json_object)

    response = {
        'JobName': gluejobname,
        'Arguments': {
            '--key': destination_folder + name_json,
            '--destination_bucket_metrics': destination_bucket_metrics,
            '--destination_bucket': destination_bucket,
            '--destination_folder': destination_folder,
            '--database': database, 
            '--table': table,
            '--schema': schema, 
            '--db_type': db_type,
            '--partitioned': partitioned,
            '--gluejobname': gluejobname,
            '--prefix': prefix, 
            '--iac_manager': iac_manager}
    }
    
    print("PROCESO FINALIZADO EXITOSAMENTE")
    return response