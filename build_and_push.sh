#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Step 1: Build the Docker Compose services
echo "Building Docker Compose services..."
docker compose build

# Step 2: Push the frontend image
echo "Pushing frontend image..."
docker push ghcr.io/madbeamer/coducate-frontend:latest

# Step 3: Push the backend image
echo "Pushing backend image..."
docker push ghcr.io/madbeamer/coducate-backend:latest

echo "Build and push completed successfully!"
