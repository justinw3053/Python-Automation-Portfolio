````
# Stage 2: Docker Automation

## Project Description
This stage focuses on using Python to automate common Docker tasks. Automation is crucial for managing containerized applications efficiently, especially in development and testing environments. The scripts here demonstrate how to programmatically interact with the Docker daemon, list containers, and manage their state.

## Scripts
### `first_docker_script.py`
A basic script to get started with the `docker` Python library. It connects to the Docker daemon and lists all active containers, a fundamental task in container management.

### `docker_log_viewer.py`
This script uses the Docker SDK to stream and filter logs from a specified container. It showcases how to monitor application output, which is essential for debugging and logging.

### `docker_utils.py`
A collection of utility functions to handle various Docker tasks. It includes functions for listing containers, inspecting their status, and stopping or starting them, providing a reusable module for more complex automation.

### `container_restart_final.py`
A complete script that uses the utilities to identify a specific container and restart it if it's not running. This demonstrates a practical, real-world automation scenario for maintaining application uptime.

## How to Use
To run any of the scripts, ensure you have the `docker` Python library installed:
```bash
pip install docker
````

Then, navigate to the `Stage2-Docker-Automation` directory in your terminal and execute the desired script:

Bash

```
python3 <script_name>.py
```

For example:

Bash

```
python3 first_docker_script.py
```
