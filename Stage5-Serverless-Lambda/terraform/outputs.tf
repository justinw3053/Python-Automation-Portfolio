# Stage5-Serverless-Lambda/terraform/outputs.tf

# This output provides the Amazon Resource Name (ARN) of the deployed Lambda function.
# The ARN is a unique identifier for the resource within AWS.
output "lambda_function_arn" {
  description = "The ARN of the deployed Lambda function."
  value       = aws_lambda_function.my_hello_lambda.arn
}

# This output provides the full, directly invokable URL for your API Gateway endpoint.
# You can copy and paste this URL directly into your web browser or use with tools like curl.
output "api_gateway_invoke_url" {
  description = "The invoke URL for the API Gateway endpoint."
  # This constructs the standard HTTPS URL using the API Gateway's ID, the AWS region,
  # the deployed stage name, and the resource path.
  value       = "https://${aws_api_gateway_rest_api.my_api_gateway.id}.execute-api.${var.aws_region}.amazonaws.com/${aws_api_gateway_stage.my_api_stage.stage_name}/${aws_api_gateway_resource.my_api_resource.path_part}"
}
