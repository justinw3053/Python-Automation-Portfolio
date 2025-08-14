# Configure the AWS provider, specifying the region where resources will be deployed.
    provider "aws" {
      region = "eu-central-1" # Ensure this matches your desired AWS region
    }

    # --- Terraform S3 Backend Configuration ---
    # This block is crucial for managing Terraform's state consistently across different
    # environments (like your local machine and GitHub Actions).
    # It tells Terraform to store the state file in an S3 bucket and use DynamoDB
    # for state locking, preventing concurrent modifications.
    terraform {
      backend "s3" {
        bucket         = "justinw3053-terraform-state-bucket" # <<< IMPORTANT: REPLACE with YOUR EXACT unique S3 bucket name
        key            = "my-lambda-app/terraform.tfstate"           # A unique path for this project's state within the bucket
        region         = "eu-central-1"                              # Must match the region of your S3 bucket
        dynamodb_table = "my-flask-app-terraform-locks"              # <<< IMPORTANT: REPLACE with YOUR EXACT DynamoDB table name (reusing the same one is fine)
        encrypt        = true                                        # Encrypts the state file at rest in S3
      }
    }

    # --- IAM Role for Lambda Execution ---
    # A dedicated IAM role is required for Lambda functions. This role defines
    # the permissions that your Lambda function will have when it executes.
    # The 'assume_role_policy' allows the Lambda service to assume this role.
    resource "aws_iam_role" "lambda_exec_role" {
      name = "my-lambda-exec-role"

      assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "lambda.amazonaws.com" # Allows the Lambda service to assume this role
          }
        }]
      })
    }

    # --- IAM Policy Attachment for Lambda Logging ---
    # This policy grants the Lambda function permission to write its logs
    # to AWS CloudWatch Logs, which is essential for debugging and monitoring.
    resource "aws_iam_role_policy_attachment" "lambda_logging_attachment" {
      role       = aws_iam_role.lambda_exec_role.name
      policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
    }

    # --- AWS Lambda Function Definition ---
    # This resource defines the actual serverless function.
    resource "aws_lambda_function" "my_hello_lambda" {
      function_name = var.lambda_function_name           # Name from variables.tf
      handler       = "lambda_function.lambda_handler"   # Specifies the file (lambda_function.py) and function (lambda_handler) to execute
      runtime       = "python3.9"                        # The Python runtime environment for the Lambda (can be updated to 3.10, 3.11, etc.)
      role          = aws_iam_role.lambda_exec_role.arn  # Attaches the IAM role created above
      timeout       = 30                                 # Maximum execution time in seconds (Lambda will terminate if it exceeds this)
      memory_size   = 128                                # Amount of memory allocated to the Lambda in MB

      # The 'source_code_hash' is vital: it tells Terraform to re-deploy the Lambda
      # only if the content of your zipped code (lambda_function.py) changes.
      source_code_hash = filebase64sha256(data.archive_file.lambda_zip.output_path)

      # 'filename' points to the local ZIP file created by the 'archive_file' data source.
      filename = data.archive_file.lambda_zip.output_path
    }

    # --- Data Source: Archive File for Lambda Deployment ---
    # Lambda functions require code to be deployed as a ZIP file. This 'data' resource
    # uses a local provisioner to zip your Python code file before deployment.
    data "archive_file" "lambda_zip" {
      type        = "zip"                                    # Specifies the archive type as ZIP
      source_file = "${path.module}/../lambda_function.py" # Path to your Python Lambda code file
      output_path = "${path.module}/lambda_function.zip"     # Where to save the generated ZIP file locally
    }

    # --- AWS API Gateway: REST API ---
    # API Gateway acts as the "front door" for your Lambda function,
    # providing an HTTP endpoint that can be accessed from the internet.
    resource "aws_api_gateway_rest_api" "my_api_gateway" {
      name        = "my-hello-api"                     # Name of your API Gateway
      description = "API Gateway for the Hello Lambda function"
    }

    # --- AWS API Gateway: Resource (e.g., /hello) ---
    # Resources define the paths within your API. Here, we're creating a '/hello' path.
    resource "aws_api_gateway_resource" "my_api_resource" {
      rest_api_id = aws_api_gateway_rest_api.my_api_gateway.id # Associates with our REST API
      parent_id   = aws_api_gateway_rest_api.my_api_gateway.root_resource_id # Attaches to the root of the API (i.e., '/')
      path_part   = "hello"                                      # Creates the '/hello' part of the URL
    }

    # --- AWS API Gateway: Method (e.g., GET /hello) ---
    # Methods define the HTTP verbs (GET, POST, etc.) that can be used on a resource.
    resource "aws_api_gateway_method" "my_api_method" {
      rest_api_id   = aws_api_gateway_rest_api.my_api_gateway.id   # Links to our REST API
      resource_id   = aws_api_gateway_resource.my_api_resource.id  # Links to the '/hello' resource
      http_method   = "GET"                                        # Allows GET requests to /hello
      authorization = "NONE"                                       # No authentication required for this simple example
    }

    # --- AWS API Gateway: Integration (connects Method to Lambda) ---
    # This is the critical link that tells API Gateway to invoke your Lambda function
    # when a request comes in for the defined method and resource.
    resource "aws_api_gateway_integration" "my_api_integration" {
      rest_api_id             = aws_api_gateway_rest_api.my_api_gateway.id   # Links to our REST API
      resource_id             = aws_api_gateway_resource.my_api_resource.id  # Links to the '/hello' resource
      http_method             = aws_api_gateway_method.my_api_method.http_method # GET method
      integration_http_method = "POST"                                     # API Gateway uses POST internally to invoke Lambda functions
      type                    = "AWS_PROXY"                                # Use AWS_PROXY for direct Lambda integration (simplifies request/response mapping)
      uri                     = aws_lambda_function.my_hello_lambda.invoke_arn # The ARN for invoking the Lambda
    }

    # --- AWS Lambda: Permission to be invoked by API Gateway ---
    # Lambda functions, by default, cannot be invoked by other AWS services.
    # This resource grants API Gateway explicit permission to call your Lambda.
    resource "aws_lambda_permission" "allow_api_gateway" {
      statement_id  = "AllowAPIGatewayInvokeLambda"                 # Unique identifier for the permission statement
      action        = "lambda:InvokeFunction"                       # The specific action being allowed
      function_name = aws_lambda_function.my_hello_lambda.function_name # The name of the Lambda function to invoke
      principal     = "apigateway.amazonaws.com"                    # The service that is allowed to invoke the Lambda
      # 'source_arn' restricts the permission to calls originating from our specific API Gateway
      source_arn    = "${aws_api_gateway_rest_api.my_api_gateway.execution_arn}/*/*"
    }

    # --- AWS API Gateway: Deployment ---
    # Changes to API Gateway resources (methods, resources, integrations) are not live
    # until a deployment is made. This resource creates a new deployment.
    resource "aws_api_gateway_deployment" "my_api_deployment" {
      rest_api_id = aws_api_gateway_rest_api.my_api_gateway.id

      # The 'triggers' block forces a new deployment whenever any of the listed
      # API Gateway components change, ensuring your API is always up-to-date.
      triggers = {
        redeployment = sha1(jsonencode([
          aws_api_gateway_resource.my_api_resource.id,
          aws_api_gateway_method.my_api_method.id,
          aws_api_gateway_integration.my_api_integration.id,
        ]))
      }

      # 'create_before_destroy' ensures a new deployment is created before the old one is deleted.
      # This is useful for zero-downtime updates and rollback capabilities.
      lifecycle {
        create_before_destroy = true
      }
    }

    # --- AWS API Gateway: Stage (e.g., /dev) ---
    # A stage represents a specific version or environment of your API Gateway (e.g., 'dev', 'prod').
    # It provides a stable URL for accessing your deployed API.
    resource "aws_api_gateway_stage" "my_api_stage" {
      deployment_id = aws_api_gateway_deployment.my_api_deployment.id # Links to the specific deployment
      rest_api_id   = aws_api_gateway_rest_api.my_api_gateway.id       # Links to our REST API
      stage_name    = "dev"                                          # The name of the stage (e.g., your-api-id.execute-api.eu-central-1.amazonaws.com/dev)
    }
