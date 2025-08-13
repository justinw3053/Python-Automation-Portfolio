# Stage 4: Infrastructure as Code with Terraform

## Project Description
This project defines the necessary AWS infrastructure for our web application using Terraform. The primary goal is to provision a private Amazon ECR (Elastic Container Registry) repository to store our Docker images.

## Technologies Used
* **Terraform:** An open-source tool for provisioning and managing cloud infrastructure using a declarative configuration language.
* **AWS:** The cloud provider where our infrastructure will be deployed.

## Prerequisites
* **Terraform CLI:** Must be installed on your local machine.
* **AWS CLI:** Must be installed and configured with the necessary credentials and default region. This is the same setup we used for our GitHub Actions secrets.

## Local Setup and Usage

### 1. Initialize the Directory
From this directory, run `terraform init`. This command downloads the AWS provider plugin and initializes the working directory.

### 2. Plan the Infrastructure
To see what changes Terraform will make without actually applying them, run `terraform plan`. This will show you the resources it plans to create.

### 3. Apply the Infrastructure
To create the ECR repository in your AWS account, run `terraform apply`. You will be prompted to confirm the changes before they are applied.