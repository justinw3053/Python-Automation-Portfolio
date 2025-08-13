# Stage 4: Infrastructure as Code (IaC) Pipeline

## Project Description
This project demonstrates a complete automated workflow using Infrastructure as Code principles. It builds on the skills from the previous stages by integrating Docker and Terraform with GitHub Actions to create a Continuous Integration/Continuous Deployment (CI/CD) pipeline. The pipeline automatically provisions AWS resources, builds a containerized application, and deploys it to a container service.

## Components
### `flask_app` (directory)
This directory contains a simple Python Flask web application that serves as the target for our pipeline.
* **`app.py`**: A minimal Flask application.
* **`Dockerfile`**: Defines how to containerize the Flask application.
* **`requirements.txt`**: Lists the Python dependencies for the application.

### `terraform` (directory)
This directory holds the Terraform code that defines our AWS infrastructure.
* **`main.tf`**: The main Terraform configuration file that declares the AWS resources, including an ECR repository and an ECS cluster.
* **`variables.tf`**: Defines the input variables for our Terraform configuration, such as the ECR image URI.

### GitHub Actions Workflow
* **`.github/workflows/ci.yml`**: This is the core of the pipeline. It's a YAML file that defines the automated steps to be run whenever code is pushed to the repository. The workflow includes steps to:
    1.  Provision infrastructure with **Terraform**.
    2.  Build the Docker image.
    3.  Push the image to **AWS ECR**.
    4.  Update the running application with the new image.

## Prerequisites
* An AWS account with an IAM user and access keys.
* The AWS CLI configured locally.
* GitHub secrets configured for `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.