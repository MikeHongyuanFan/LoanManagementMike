#!/bin/bash

# Load environment variables
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi

# Set default values if not provided
DOCKER_USERNAME=${DOCKER_USERNAME:-frappe}
TAG=${TAG:-latest}

echo "Building Docker image: $DOCKER_USERNAME/frappe-lending:$TAG"

# Build the Docker image
docker build -t $DOCKER_USERNAME/frappe-lending:$TAG .

echo "Build complete!"
echo "You can now run: docker compose up -d"
