# Dockerized devpi-server with devpi-web

This Docker setup provides a complete devpi environment, including both the devpi-server and the devpi-web client interface.

## Directory Structure

```
.
├── Dockerfile
├── config/
│   ├── devpi-server.yml
│   └── init.sh
├── docker-compose.yml
└── README.md
```

## Quick Start

1. Create the directory structure and files as shown above:

```bash
mkdir -p config
# Create all the files in their respective locations
```

2. Start the service:

```bash
docker-compose up -d
```

3. Access devpi-web at: http://localhost:3141

## Environment Variables

You can customize the following environment variables in the docker-compose.yml file:

- `DEVPI_HOST`: Host to bind to (default: 0.0.0.0)
- `DEVPI_PORT`: Port to listen on (default: 3141)
- `DEVPISERVER_SERVERDIR`: Directory where devpi stores its data (default: /data/devpi)
- `DEVPI_OUTSIDE_URL`: External URL for accessing devpi (default: http://localhost:3141)

## Using devpi as a PyPI Mirror

To use your devpi server as a PyPI mirror:

```bash
# Configure pip to use devpi
pip config set global.index-url http://localhost:3141/root/pypi/+simple/

# Or for a specific project
pip install -i http://localhost:3141/root/pypi/+simple/ package_name
```

## Using devpi with a requirements.txt file

```bash
pip install -i http://localhost:3141/root/pypi/+simple/ -r requirements.txt
```

## Persistence

The setup uses a Docker volume to ensure data persists between container restarts.
