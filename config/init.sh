#!/bin/bash
set -e

echo "Starting devpi-server with devpi-web plugin..."

# Start devpi-server with devpi-web plugin
exec devpi-server \
    --host ${DEVPI_HOST} \
    --port ${DEVPI_PORT} \
    --serverdir ${DEVPI_SERVERDIR} \
    --outside-url ${DEVPI_OUTSIDE_URL} \
    --configfile /app/config/devpi-server.yml