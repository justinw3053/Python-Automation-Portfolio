# THis variable defines the name for your AWS Lambda function
# Providing a default value makes the variable optional unless overridden
variable "lambda_function_name" {
    description = "The name for hte AWS Lambda function."
    type        = string
    default     = "my-hello-lambda-function"
}

# This variable defines the AWS region where all resources for this project
# will be deployed. It is a good practice to centralize the region definition.
variable "aws_region" {
    description = "The AWS region where resources will be deployed."
    type        = string
    default     = "eu-central-1" # Ensure this matches your provider region
}