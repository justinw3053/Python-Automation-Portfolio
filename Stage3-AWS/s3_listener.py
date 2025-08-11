import boto3

try:
    # Create an S3 client object
    s3 = boto3.client('s3')

    # Call the list_buckets API
    response = s3.list_buckets()

    # Print the bucket names
    print("Your S3 Buckets:")
    if 'Buckets' in response:
        for bucket in response['Buckets']:
            print(f"- {bucket['Name']}")
    else:
        print("No buckets found.")

except Exception as e:
    print(f"An error occured: {e}")
