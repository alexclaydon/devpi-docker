FROM python:3.11-slim

# Install required system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libssl-dev \
    libffi-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Environment variables
ENV DEVPISERVER_SERVERDIR=/data/devpi
ENV DEVPISERVER_PORT=3141
ENV DEVPISERVER_HOST=0.0.0.0
ENV DEVPI_OUTSIDE_URL=http://localhost:3141

# Create devpi user and data directory
RUN useradd -ms /bin/bash devpi
RUN mkdir -p ${DEVPISERVER_SERVERDIR} && chown -R devpi:devpi ${DEVPISERVER_SERVERDIR}

# Set working directory
WORKDIR /app

# Install devpi-server and devpi-web
RUN pip install --no-cache-dir devpi-server devpi-web devpi-client

# Copy configuration files
COPY secret /app/config/secret
COPY config/devpi-server.yml /app/config/
COPY config/init.sh /app/

# Set proper permissions
RUN chmod 0600 /app/config/secret
RUN chmod +x /app/init.sh
RUN chown -R devpi:devpi /app

# Switch to devpi user
USER devpi

# Expose the port
EXPOSE ${DEVPISERVER_PORT}

# Start devpi server
CMD ["/app/init.sh"]
