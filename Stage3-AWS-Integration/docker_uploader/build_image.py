import docker
import sys

# These are the variables used to easily manage the image name and tag
# Note: This is the name you'll use to push the image to a registry
DOCKER_USERNAME = "justinw3053"
IMAGE_NAME = "my-app"
IMAGE_TAG = "latest"

try:
    client = docker.from_env()

    print(f"Building Docker image '{DOCKER_USERNAME}/{IMAGE_NAME}:{IMAGE_TAG}'...")

    # This is the method for building the image
    # The 'path=' parameter tells Docker to use the Dockerfile in the currect directory
    # The 'tag' parameter sets the name and tag for the new image
    # The 'pull=True' parameter ensures Docker pulls the latest base image (python:3.9-slim)
    image, build_logs = client.images.build(
        path=".",
        tag=f"{DOCKER_USERNAME}/{IMAGE_NAME}:{IMAGE_TAG}",
        pull=True
    )

    print("\nImage built successfully!")
    print(f"Image ID: {image.id}")

# This is a new, specific error to catch. It happens if the Docker build process fails
except docker.errors.BuildError as e:
    print(f"Image build failed: {e}")

except Excpetion as e:
    print(f"An unexpected error has occurred: {e}")
