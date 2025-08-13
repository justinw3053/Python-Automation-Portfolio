# This block configures Terraform to use AWS as the cloud provider
# The 'provider' keyword tells Terraform which service to interact with
# The 'region' is where allour resources will be created
provider "aws" {
	region = "eu-central-1" # Or your specified AWS region
}

# This is a resource block, the core of Terraform. It defines a single cloud resource
# The first string, "aws_ecr_repository", is the resource type
# The second string "my_flask_app_repo", is a local name we give the resource
resource "aws_ecr_repository" "my_flask_app_repo" {
	# This property sets the name of the ECR repository in AWS
	# The name should match the name we will use to tag the Docker image
	name = "my-flask-app"

	# The 'force_delete' property allows Terraform to delete the repository even if it
	# contains images. We set this to true for easy cleanup during developement
	force_delete = true
}
