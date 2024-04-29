# Python Starter App with Docker

This project utilizes Docker to set up a development environment for a Python application. It includes a project initialization script, a `docker-compose` configuration to orchestrate necessary services, and a Dockerfile to build the Docker image of the application.

## Prerequisites

- Docker and Docker Compose installed on your machine.
- Basic knowledge of Docker, Docker Compose, and Python.

## Configuration

### Environment Variables

Create a `.env` file at the root of your project with the following variables:

```env
PYTHON_HOST=0.0.0.0
PYTHON_PORT=8000
APP_NAME=python_starter_app
PYTHON_VERSION=3.12
NETWORK=python_network
```

Adjust these values as needed. They will be used by Docker Compose and the shell scripts.

### Dockerfile

The `Dockerfile` sets up the necessary environment to run the Python application, based on a Python Alpine image for minimal footprint.

### docker-compose.yml

The `docker-compose.yml` file defines the service for the Python application, using environment variables for configuration. It mounts the source code into the container and exposes the necessary port to access the application.

### Shell Scripts

- `init-project.sh`: Script to initialize the Python project if not already set up. Installs necessary dependencies.
- `docker.sh`: Script to manage the Docker environment (start, stop, restart, SSH access).

## Usage

1. **Project Initialization**: Ensure the `.env` file is set up. Run the `init-project.sh` script to initialize the Python project.

2. **Starting the Environment**: Use the `docker.sh` script with the `start` argument to start the Docker environment. For example:

```sh
./docker.sh start
```

3. **Accessing the Application**: Open your browser and navigate to `http://localhost:8000` (or another configured port) to see your Python application in action.

4. **Stopping the Environment**: Use the `docker.sh` script with the `stop` argument to stop all services.

```sh
./docker.sh stop
```

5. **Restarting the Environment**: To restart, use `restart`:

```sh
./docker.sh restart
```

6. **SSH into the Container**: To SSH into the container, use `ssh`:

```sh
./docker.sh ssh
```

## Contributing

Feel free to contribute to the project by submitting pull requests or reporting issues.
