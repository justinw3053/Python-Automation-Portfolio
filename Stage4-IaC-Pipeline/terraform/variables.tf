# This variable holds the URI for the docker image in ECR
# You will provide this value when running 'terraform plan' or 'terraform apply'
# You can get this URI from your ECR console. It looks like:
# "ACCOUNT_ID.dkr.ecr.REGION.amazonaws.com/REPOSITORY_NAME:TAG"
variable "ecr_image_uri" {
	description = "The URI of the Docker image in ECR to deploy."
	type		= string
}

# --- NEW: Variable for AWS Region ---
# This variable allows us to dynamically set the AWS region for resources
# that use it, such as constructing Availability Zone names
variable "aws_region" {
	description = "The AWS region where resources will be deployed."
	type        = string
	default     = "eu-central-1" # Set a default value, but it can be overridden
}
