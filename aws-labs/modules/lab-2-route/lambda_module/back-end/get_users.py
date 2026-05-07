import boto3
import json
import os

# Initialize the DynamoDB client
dynamodb = boto3.resource('dynamodb')

table_name = os.getenv("TABLE_NAME")  # PUT YOUR TABLE NAME AS ENV IN CONFIGURATION SECITON
table = dynamodb.Table(table_name)

def lambda_handler(event, context):
    """
    Lambda function to retrieve all user data from DynamoDB.
    """
        # Fetch all data from the DynamoDB table
    response = table.scan()

        # Extract items
    items = response.get('Items', [])

        # Return a success response with the data
    return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*' , # For CORS
            },
            'body': json.dumps(items)
    }
