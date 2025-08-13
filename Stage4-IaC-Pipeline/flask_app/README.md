# Simple Flask Application

## Project Description
This is a minimal Python Flask web application designed to be containerized and deployed as part of the automated CI/CD pipeline. It serves as the core application for the **Stage 4: Infrastructure as Code (IaC) Pipeline** project.

## Files
* **`app.py`**: The main Python script for the Flask application. It defines a single route that returns a simple "Hello, World!" message.
* **`requirements.txt`**: This file lists all the Python dependencies required to run the Flask application (e.g., `Flask`). The `Dockerfile` uses this file to install the necessary packages.
* **`Dockerfile`**: A set of instructions for Docker to build a container image for this application. It specifies the base image, copies the application files, installs dependencies, and defines the command to run the app.

## How to Run Locally

### With Docker
1.  Navigate to the `flask_app` directory in your terminal.
2.  Build the Docker image:
    ```bash
    docker build -t my-flask-app .
    ```
3.  Run the container:
    ```bash
    docker run -p 5000:5000 my-flask-app
    ```
4.  Open your web browser and navigate to `http://localhost:5000` to see the application running.

### Without Docker
1.  Ensure you have Python and `pip` installed.
2.  Install the required dependencies:
    ```bash
    pip install -r requirements.txt
    ```
3.  Run the application:
    ```bash
    python3 app.py
    ```
4.  Open your web browser and navigate to `http://localhost:5000`.