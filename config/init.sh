#!/bin/bash
set -e

# Check if server directory is initialized
if [ ! -f "${DEVPISERVER_SERVERDIR}/.serverversion" ]; then
    echo "Initializing devpi-server..."
    devpi-init -c /app/config/devpi-server.yml

    # Wait for devpi-server to become ready
    echo "Waiting for devpi-server to start..."
    sleep 5  # Adjust this if needed

    # Configure devpi-client to use the local devpi-server
    devpi use "${DEVPI_OUTSIDE_URL}"

    # Set root password if provided
    if [ -n "${DEVPI_ROOT_PASSWORD}" ]; then
        echo "Setting root password..."
        devpi login root --password=''
        devpi user -m root password="${DEVPI_ROOT_PASSWORD}"
    else
        echo "No root password provided. Using default (blank password)."
    fi

    # Create new devpi user if credentials are provided
    if [ -n "${DEVPI_USER}" ] && [ -n "${DEVPI_USER_PASSWORD}" ]; then
        echo "Creating devpi user '${DEVPI_USER}'..."
        devpi login root --password="${DEVPI_ROOT_PASSWORD}"
        devpi user -c "${DEVPI_USER}" password="${DEVPI_USER_PASSWORD}"
        # Optionally, create an index for the user
        devpi login "${DEVPI_USER}" --password="${DEVPI_USER_PASSWORD}"
        devpi index -c "${DEVPI_USER}/dev"
        devpi use "${DEVPI_USER}/dev"
    else
        echo "No devpi user credentials provided. Skipping user creation."
    fi
fi

echo "Starting devpi-server..."
devpi-server -c /app/config/devpi-server.yml
