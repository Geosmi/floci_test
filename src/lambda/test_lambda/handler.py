import boto3
import botocore

def lambda_handler(event, context):
    client = boto3.client('dynamodb')
    client.batch_get_item
    return {
        "statusCode": 200,
        "body": event
    }