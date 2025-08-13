import docker
import sys
import re
from docker_utils import list_containers

try:
    # Connect to the Docker daemon
    client = docker.from_env()

    # Call the function from the other file to list all containers
    list_containers()

    # Get user input for the container name
    container_name = input("\nEnter the name of the container to view logs for: ")

    # Get the container object
    container = client.containers.get(container_name)

    # Get the logs and decode them to a string (depreciated to allow streaming logs)
#    logs = container.logs().decode("utf-8")

    # Get the logs and stream them in real-time (depreciated to allow for log analysis instead of streaming)
#    print(f"\nStreaming logs for '{container_name}'. Press Ctrl+C to stop")
#    for line in container.logs(stream=True, tail=10):
#        print(line.decode('utf-8'), end='')

    # Get all logs from the container and prepare them for analysis
    logs_output = container.logs().decode("utf-8")
    log_lines = logs_output.splitlines()

    # Depreciated to allow for stricter key word searches
#    print(f"\nSearching logs for the keyword 'error' in container '{container_name}'...")

    # Define the keyword and the regular expression pattern
    keyword = "error"
    pattern = r'\b' + re.escape(keyword) + r'\b'
    print(f"\nSearching logs for the whole word '{keyword}' in container '{container_name}'...")

    found_errors = []

    # Iterate over each line and check for the keyword
    for line in log_lines:
        # Depreciated for stricter keyword searching
#        if "error" in line.lower():
        if re.search(pattern, line, re.IGNORECASE):
            found_errors.append(line)

    # Print the results
    if found_errors:
        print("\n--- Found Errors ---")
        for error in found_errors:
            print(error)
        print("--------------------")
    else:
        print("\nNo errors found in the logs.")
    

    # Print the logs (depreciated to allow streaming logs)
#    print(logs)

except docker.errors.NotFound:
    print(f"Error: container '{container_name}' not found.")
# Depreciated since Ctrl+C is not used in log analysis
#except KeyboardInterrupt:
#    print("\nLog streaming stopped by user.")
except Exception as e:
    print(f"An unexpected exception has occurred: {e} ")
