# Stage 5: Serverless Lambda Functions

## Project Description
This stage introduces serverless computing using AWS Lambda. The focus is on deploying a simple Python function to Lambda, triggered via AWS API Gateway. This demonstrates how to build and deploy lightweight, scalable, and cost-effective applications without managing servers. The project will leverage Infrastructure as Code (IaC) with Terraform for provisioning the serverless components.

## Files
### `lambda_function.py`
This Python script contains the core logic for our AWS Lambda function. It's a simple "Hello, World!" example that will be packaged and deployed.

### `terraform/` (directory)
This directory will contain the Terraform configuration files to define and provision the AWS infrastructure for our serverless application.
* **`main.tf`**: Defines the AWS Lambda function, API Gateway, and necessary IAM roles.
* **`variables.tf`**: Declares input variables for the Terraform configuration, such as the Lambda function name or region.
* **`outputs.tf`**: Defines output values from the Terraform deployment, such as the Lambda function ARN or the API Gateway URL, which will be useful for accessing the deployed function.

## How to Use
This project will be deployed using Terraform. Ensure you have AWS credentials configured and Terraform installed.
Future steps will cover how to initialize and apply the Terraform configuration to deploy the Lambda function and API Gateway.