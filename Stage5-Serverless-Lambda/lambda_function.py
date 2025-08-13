import json

# this is the main entry point for your AWS Lambda function
# When AWS Lambda invokes your function, it calls this specific 'lambda_handler' function
# The name 'lambda_handler' is a convention, and it's specified in your Terraform configuration
# (or in the AWS console) as the "handler" for this Lambda function
def lambda_handler(event, context):
    """
    This function processes incoming requests, typically from AWS API Gateway,
    and returns a structured HTTP response.

    Args:
        event (dict):
            Thsi dictionary contains all the data about the invocation.
            When triggered by API Gateway, it includes details about the
            incoming HTTP request, such as headers, query parameters,
            HTTP method, and the request body.
            Example for an API Gateway GET request:
            {
                "resource": "/hello",
                "path": "/hello",
                "httpMethod": "GET",
                "headers": { ... },
                "queryStringParameters": { "name": "ALice" }, # This is where 'name' comes from
                "requestContext": { ... },
                "body": null,
                "isBase64Encoded": false
            }

        context (object):
            This object provides runtime information about the invocation,
            function, and execution environment. It contains useful attributes
            like:
            - function_name: The name of the Lambda function.
            - function_version: The version of the function.
            - invoked_function_arm: The ARN used to invoke the function.
            - aws_request_id: The unique ID for the invocation request.
            - log_group_name, log_stream_name: CloudWatch log details.
            - memory_limit_in_mb, get_remaining_time_in_millis: Resource limits.

    Returns:
        dict:
            A dictionary that AWS Lambda especially when integrated with API Gateway)
            expects as an HTTP response. For API Gatewaay Proxy Integration (which we'll use),
            this dictionary *must* include:
            - 'statusCode': The HTTP status code (e.g., 200 for success, 400 for bad request).
            - 'headers': A dictionary of HTTP response headers (e.g., Content-Type, CORS headers).
            - 'body': A string representing the response body. This *must* be a string,
                      so we'll use `json.dumps()` if our body content is a Python dictionary.
    """

    # Print the entire incoming event to CloudWatch Logs for debugging.
    # This is very helpful to see exactly what data your Lambda recieves.
    print(f"Recieved event: {json.dumps(event, indent=2)}")

    # Initialize a default value for the 'name'.
    name = "World"

    # Check if the 'event' dictionary exists, if it contains 'queryStringParameters',
    # and if those query parameters are not empty.
    # 'queryStringParameters' is where URL parameters like '?name=Alice' are found
    # when API Gateway triggers the Lambda.
    if event and 'queryStringParameters' in event and event['queryStringParameters']:
        # If the 'name' parameter is present in the query string, update our 'name' variable.
        if 'name' in event['queryStringParameters']:
            name = event['queryStringParameters']['name']

    # Define the content of the response body as a Python dictionary.
    # We include a greeting message and echo back the full input event for demonstration.
    response_body_content = {
        "message": f"Hellow form Lambda, {name}!",
        "input_event_recieved": event # Showing what the Lambda recieved
    }

    # Construct the final HTTP response dictionary in the format expected bt API Gateway
    # The 'body' field must be a JSON string, so we use json.dumps() to convert our Python dict.
    return {
            'statusCode': 200, # HTTP 200 OK status code indicates success
            'headers': {
                'Content-Type': 'application/json', # Tells the client that the response body is JSON
                'Access-Control-Allow-Origin': '*' # CRITICAL for web browsers: This header enables
                                                   # Cross-Origin Resource Sharing (CORS)
                                                   # If a webpage loaded from one domain (e.g., your website)
                                                   # tries to call your API Gateway (on a different domain),
                                                   # CORS headers are required by the browser for security.
                                                   # '*' allows requests from ANY origin. For production,
                                                   # you'd replace '*' with specific domains
                                                   
            },
            'body': json.dumps(response_body_content) # convert the Python dict to a JSON string
    }
