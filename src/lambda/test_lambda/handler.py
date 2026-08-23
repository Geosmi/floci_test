import boto3
import botocore

def lambda_handler(event, context):
    print(event)
    # client = boto3.client('dynamodb')
    return {
        "statusCode": 200,
        "body": event
    }