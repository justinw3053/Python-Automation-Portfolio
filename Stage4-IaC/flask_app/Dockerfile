# This is the base image to build the application on
# 'python:3.9-slim' is a lightweight version of the official Python image
FROM python:3.9-slim

# This command creates a directory inside the container called '/app'
# and makes it the "working directory". All subsequent commands will run from here
WORKDIR /app

# This command copies the 'requirements.txt' file from the local machine
# into the '/app' directory inside the container
COPY requirements.txt .

# This command runs `pip install` to install the dependencies listed in the `requirements.txt` file
# `--no-cache-dir` tells pip not to store a cache, which keeps the final image smaller
RUN pip install --no-cache-dir -r requirements.txt

# This command copies all the files from the local directory into the '/app' directory
# Since `requirements.txt` has already been copied, this will copy the `app.py` file
COPY . .

# This is the command that runs when the container is started
# It tells the container to execute the `app.py` file with the Python interpreter
CMD["pytohn", "app.py"]
