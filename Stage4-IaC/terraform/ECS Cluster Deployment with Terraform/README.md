# ECS Cluster Deployment with Terraform

## Project Description

This Terraform configuration provisions the necessary AWS infrastructure to deploy our Flask application as a containerized service. It defines an Amazon ECS (Elastic Container Service) cluster, a task definition, and an ECS service to run the application.

## Technologies Used

- **Terraform:** For defining and provisioning our infrastructure as code.
    
- **AWS ECS:** A container orchestration service to run our Docker container.
    
- **AWS ECR:** The container registry where our Docker image is stored.
    

## Prerequisites

- Terraform CLI is installed.
    
- AWS CLI is configured with the necessary credentials.
    
- The Docker image `my-flask-app:latest` is pushed to your ECR repository.
    

## Variables

This project uses one variable, `ecr_image_uri`, which specifies the full URI of the Docker image to be deployed.

You can find the correct URI in your AWS ECR console by navigating to your `my-flask-app` repository and clicking on the `latest` image tag. The URI format is:

`{AWS_ACCOUNT_ID}.dkr.ecr.{AWS_REGION}.amazonaws.com/{REPOSITORY_NAME}:latest`

## Local Setup and Usage

### 1. Initialize the Directory

From your `terraform` directory, run `terraform init`. This will download the necessary AWS provider plugin.

### 2. Plan the Infrastructure

To see what changes Terraform will make, run `terraform plan`. This will show you the resources it plans to create. You will be prompted to enter a value for the `ecr_image_uri` variable.

### 3. Apply the Infrastructure

To create the ECS cluster and deploy the application, run `terraform apply`. You will be prompted for the `ecr_image_uri` and asked to confirm the changes before they are applied.