````
# Terraform Infrastructure

## Project Description
This directory contains the Terraform configuration files for provisioning the AWS infrastructure required by the CI/CD pipeline. The infrastructure defined here includes an Amazon ECR repository to store our Docker images and the necessary ECS resources (cluster, task definition, and service) to deploy the containerized application.

## Files
* **`main.tf`**: This is the core configuration file. It contains the declarations for all the AWS resources, including the ECR repository, ECS cluster, task definition, and ECS service. It is designed to be version-controlled and acts as the single source of truth for our infrastructure.
* **`variables.tf`**: This file defines the input variables for the Terraform configuration. It allows for dynamic values, such as the ECR image URI, to be passed into the configuration without hard-coding them.

## Local Usage
To manage the infrastructure locally, use the following commands from within this directory:

### 1. Initialize the Directory
First, you need to initialize the Terraform working directory to download the required AWS provider plugin:
```bash
terraform init
````

### 2. Plan the Infrastructure

To see what changes Terraform will make to your AWS account without applying them, run the `plan` command. You will be prompted to provide the `ecr_image_uri` variable.

Bash

```
terraform plan -var="ecr_image_uri=<YOUR_ECR_IMAGE_URI>"
```

(Replace `<YOUR_ECR_IMAGE_URI>` with the full URI of your Docker image in ECR).

### 3. Apply the Infrastructure

To apply the changes and provision the AWS resources, run the `apply` command:

Bash

```
terraform apply -var="ecr_image_uri=<YOUR_ECR_IMAGE_URI>"
```