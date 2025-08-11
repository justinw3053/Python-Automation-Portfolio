import docker
import boto3
import sys
import base64

ECR_URI = "043309349280.dkr.ecr.eu-central-1.amazonaws.com/my-app"
LOCAL_IMAGE_TAG = "justinw3053/my-app:latest"
ECR_IMAGE_TAG = "latest"

try:
    # 1. Get the ECR authorization token
    ecr_client = boto3.client('ecr')
    token_response = ecr_client.get_authorization_token()
    auth_data = token_response ['authorizationData'][0]
#    username = 'AWS'
#    password = auth_data['proxyEndpoint']
#    registry = auth_data['proxyEndpoint']

    # The authorizationToken is a based64-encoded string "AWS:token"
    # We must decode it to get the username and password
    decoded_token = base64.b64decode(auth_data['authorizationToken']).decode()
    username, password = decoded_token.split(':')

    registry = auth_data['proxyEndpoint']

    # 2. Login to Docker using the token
    docker_client = docker.from_env()
    docker_client.login(username=username, password=password, registry=registry)
    print("Successfully loggeed into Amazon ECR.")

    # 3. Tag the local image with the ECR URI
    local_image = docker_client.images.get(LOCAL_IMAGE_TAG)
    local_image.tag(ECR_URI, tag=ECR_IMAGE_TAG)
    print(f"Tageed local image '{LOCAL_IMAGE_TAG}' as '{ECR_URI}:{ECR_IMAGE_TAG}'.")

    # 4. Push the image to ECR
    print(f"Pushing image to ECR at '{ECR_URI}'...")
    push_logs = docker_client.images.push(ECR_URI, tag=ECR_IMAGE_TAG, stream=True, decode=True)
    for line in push_logs:
        if 'status' in line:
            print(line['status'])
        elif 'error' in line:
            print(f"Error during push: {line['error']}")

    print("\nImage pushed seccessfully!")

except Exception as e:
        print(f"An error occurred: {e}")
