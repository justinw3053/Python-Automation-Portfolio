# Stage 4 Web Application & Dockerization

## Project Description
This project contains a simple "Hello, World!" Flask web application. It is the first step in a larger project to build a full CI/CD pipeline that automatically deploys a containerized application to a cloud provider.

## Technologies Used
* **Python 3:** The programming language used for the web application.
* **Flask:** A lightweight web framework for Python.
* **Docker:** Used to containerize the application for easy deployment.

## Prerequisites
* [Docker](https://www.docker.com/) installed and running on your system.
* [Python 3](https://www.python.org/downloads/) installed.

## Local Setup and Usage

### 1. Build the Docker Image
To build the Docker image from the provided `Dockerfile`, run the following command from this directory:

```bash
docker build -t my-flask-app .
### 2. Run the Container

After building, you can run the application locally with this command:

Bash

```
docker run -d -p 5000:5000 my-flask-app
```

The `-d` flag runs the container in detached mode, and `-p 5000:5000` maps port 5000 on your local machine to port 5000 inside the container.

### 3. Access the Application

Open your web browser and navigate to `http://localhost:5000` to see the "Hello, World!" message.