import sys
from awsglue.utils import getResolvedOptions
import boto3
import ast
import json
from datetime import datetime
import os

args = getResolvedOptions(sys.argv,['key','destination_bucket_metrics','destination_bucket','destination_folder','database','table','schema','db_type','partitioned', 'gluejobname','prefix','iac_manager' ])

#VARIABLES                         
key=args['key']
destination_bucket_metrics=args['destination_bucket_metrics']
destination_bucket=args['destination_bucket']
destination_folder=args['destination_folder']
database=args['database']
table=args['table']
schema=args['schema']
db_type=args['db_type']
iac_manager=args['iac_manager']
prefix=args['prefix']

#INICIO EJECUCION
begin_time = datetime.now()

database_glue_catalog=(prefix+database).lower()
table_glue_catalog=(schema+'_'+table).lower()

#SERVICIOS 
lakeformation=boto3.client('lakeformation')
glue = boto3.client(service_name='glue', region_name='us-east-1')
s3 = boto3.client('s3')

##IMPORT SCHEMA
print('IMPORTANDO ESQUEMA')
json_file = s3.get_object(Bucket=destination_bucket_metrics, Key=key)
body=json_file['Body'].read().decode("utf-8")
json_object = json.loads(body)

print('IMPORTANDO LFTAGS')
lftags = json_object['parameters']['lftags']

try:
    #VALIDA SI BASE DE DATOS EXISTE
    glue_databases = glue.get_databases()
    flg_database=0
    for glue_database in glue_databases['DatabaseList']:
        if glue_database['Name']==database_glue_catalog:
            flg_database=1
            print('BASE DE DATOS '+glue_database['Name'] +' YA EXISTE')
            break
        
    #CREA BASE DE DATOS
    if flg_database==0:
        print('CREANDO BASE DE DATOS '+database_glue_catalog)
        glue.create_database(DatabaseInput={'Name': database_glue_catalog,'Description': 'LFTags Permissions PENDING','LocationUri': 's3://'+destination_bucket})
    
    database_info=glue.get_database(Name=database_glue_catalog)
       
    #ASIGNA PERMISOS
    if 'Description' in database_info['Database']:
        if 'Permissions' in database_info['Database']['Description']:
            print('ASIGNANDO PERMISOS')
            grant_permissions = lakeformation.grant_permissions(
                Principal={
                    'DataLakePrincipalIdentifier': iac_manager
                },
                Resource={
                    'Database': {
                        'Name': database_glue_catalog
                    },
                    'Table': {
                        'DatabaseName': database_glue_catalog,
                        'TableWildcard': {}
            
                    }
                },
                Permissions=['ALL','ALTER','DROP','DESCRIBE','CREATE_TABLE'],
                PermissionsWithGrantOption=['ALL','ALTER','DROP','DESCRIBE','CREATE_TABLE']
            )
            glue.update_database(Name=database_glue_catalog,DatabaseInput={'Name': database_glue_catalog,'Description': 'LFTags PENDING','LocationUri': 's3://'+destination_bucket})
    
    database_info=glue.get_database(Name=database_glue_catalog)
    
    #VALIDA SI TABLA EXISTE
    glue_tables=glue.get_tables(DatabaseName=database_glue_catalog)
    
    flg_table=0
    for glue_table in glue_tables['TableList']:
        if glue_table['Name']==table_glue_catalog:
            print('TABLA '+table_glue_catalog +' YA EXISTE')
            flg_table=1
            break
    
    #CREA TABLA SI NO EXISTE
    if flg_table==0:
        print('CREANDO TABLA '+table_glue_catalog)
        response = glue.create_table(
            DatabaseName=database_glue_catalog,
            TableInput={
            'Name': table_glue_catalog,
            'StorageDescriptor': {
                'Columns': ast.literal_eval(str(json_object['table_schema'])),
            'Location': 's3://'+destination_bucket +'/ORC/'+db_type+'/'+database+'/'+schema+'/'+table+'/', 
            'InputFormat': 'org.apache.hadoop.hive.ql.io.orc.OrcInputFormat',
            'OutputFormat': 'org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat',
            'Compressed': False,
            'SerdeInfo': {  'SerializationLibrary': 'org.apache.hadoop.hive.ql.io.orc.OrcSerde'},
            "Parameters": {
    "classification": "orc"
    }}}
    )
    #UPDATE TABLA SI EXISTE
    else:
        print('ACTUALIZANDO TABLA '+table_glue_catalog)
        response = glue.update_table(
            DatabaseName=database_glue_catalog,
            TableInput={
            'Name': table_glue_catalog,
            'StorageDescriptor': {
                'Columns': ast.literal_eval(str(json_object['table_schema'])),
            'Location': 's3://'+destination_bucket +'/ORC/'+db_type+'/'+database+'/'+schema+'/'+table+'/', 
            'InputFormat': 'org.apache.hadoop.hive.ql.io.orc.OrcInputFormat',
            'OutputFormat': 'org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat',
            'Compressed': False,
            'SerdeInfo': {  'SerializationLibrary': 'org.apache.hadoop.hive.ql.io.orc.OrcSerde'},
            "Parameters": {
    "classification": "orc"
    }}}
    )
except Exception as e:
            print(e)
            exit(1)

print("job glue finished")