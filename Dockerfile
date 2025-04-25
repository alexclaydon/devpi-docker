FROM python:3.11-slim

# Install required system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libssl-dev \
    libffi-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Environment variables
ENV DEVPI_SERVERDIR=/data/devpi
ENV DEVPI_PORT=3141
ENV DEVPI_HOST=0.0.0.0
ENV DEVPI_OUTSIDE_URL=http://localhost:3141

# Create devpi user and data directory
RUN useradd -ms /bin/bash devpi
RUN mkdir -p ${DEVPI_SERVERDIR} && chown -R devpi:devpi ${DEVPI_SERVERDIR}

# Set working directory
WORKDIR /app

# Install devpi-server and devpi-web
RUN pip install --no-cache-dir devpi-server devpi-web

# Copy configuration files
COPY config/devpi-server.yml /app/config/
COPY config/init.sh /app/

# Set proper permissions
RUN chmod +x /app/init.sh
RUN chown -R devpi:devpi /app

# Switch to devpi user
USER devpi

# Initialize devpi-server
RUN devpi-init --serverdir=${DEVPI_SERVERDIR}

# Expose the port
EXPOSE ${DEVPI_PORT}

# Start devpi server
CMD ["/app/init.sh"]