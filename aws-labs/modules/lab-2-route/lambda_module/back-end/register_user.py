import json
import boto3
import os

dynamodb = boto3.resource('dynamodb')
table_name = os.getenv("TABLE_NAME")  # PUT YOUR TABLE_NAME IN CONFIGURATION SECITON AS ENVRIONMENT VARIABLE
table = dynamodb.Table(table_name)

def lambda_handler(event, context):
    # Get request body
    print(event)
    if "body" in event:
        event = json.loads(event["body"])

    # Create new item in DynamoDB table
    response = table.put_item(
        Item={
            'email': event['email'],
            'name': event['name'],
            'phone': event['phone'],
            'password': event['password']
        }
    )

    # Return response
    return {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
            
        },
        'body': json.dumps({'message': 'Registration successful'})
    }