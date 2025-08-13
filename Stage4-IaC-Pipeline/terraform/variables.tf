# This variable holds the URI for the docker image in ECR
# You will provide this value when running 'terraform plan' or 'terraform apply'
variable "ecr_image_uri" {
	description = "The URI of the Docker image in ECR to deploy."
	type		= string
}
