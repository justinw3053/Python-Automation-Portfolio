import docker
import sys

# Connect to the Docker daemon
try:
    client = docker.from_env()
except:
    print(f"Error connecting to Docker: {e}")
    sys.exit(1)

# Prompt the user for the container name
container_name = input("Enter the name of the container to restart: ")

try:
    # Get the container by name from user input
    container = client.containers.get(container_name)

    # Restart the container
    print(f"Restarting container: {container.name}")
    container.restart()

    # Confirmation message
    print(f"Container '{container.name}' has been restarted.")

except docker.errors.NotFound:
    print(f"Error: Container '{container_name}' not found.")
except Exception as e:
    print(f"An unexpected error ocurred: {e}")
