# 1. import the necessary library for communicating with Docker.
import docker

# 2. Define a function named 'list_containers'
#    The triple quotes are called 'docstring', and the describe what the function does
def list_containers():
    """
    List all running containers by name.
    """

    # 3. A try block is used to gracefully handle any potential errors
    try:
        # 4. Connect to the local Docker deamon using the SDK
        client = docker.from_env()

        # 5. Print a header for the list
        print("Listing all running containers:")

        # 6. Loop through the list of running container objects returned by the client.containers.list()
        for container in client.containers.list():

            # 7. For each container object, we print its 'name' attribute
            print(f"- {container.name}")

    # 8. An 'except' block catches any errors that may occur during the above process
    except Exception as e:

        # 9. If an error occurs, we print a helpful error message
        print(f"An error occurred: {e}")

# 10. This is a standard Python convention. It checks if the script is being run directly
#     If it is, it calls the 'list containers' function to start the script
if __name__ == "__main__":
    list_containers()
