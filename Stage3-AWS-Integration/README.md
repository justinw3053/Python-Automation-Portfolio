# Stage 3: AWS Integration

## Project Description
This stage focuses on integrating Python scripts with Amazon Web Services (AWS). It demonstrates how to interact with AWS services, specifically Amazon S3 (Simple Storage Service) and Amazon ECR (Elastic Container Registry). This is a crucial step in learning how to build applications that run on the cloud and interact with its managed services.

## Scripts
### `s3_listener.py`
A Python script that listens for new files uploaded to a specific S3 bucket. It shows how to use the `boto3` library, AWS's SDK for Python, to monitor cloud storage and trigger actions when changes occur.

### `docker_uploader` (directory)
This directory contains a set of scripts for building a Docker image and pushing it to an Amazon ECR repository.
* **`Dockerfile`**: Defines the environment for our sample web application.
* **`app.py`**: A simple Flask web application that will be containerized.
* **`build_image.py`**: A script that uses the Docker SDK to build a Docker image from the `Dockerfile`.
* **`push_image.py`**: A script that logs in to AWS ECR and pushes the built Docker image to the repository.

## Prerequisites
* An AWS account with the necessary permissions for S3 and ECR.
* AWS credentials configured on your local machine (using `aws configure`).
* The `boto3` and `docker` Python libraries installed.