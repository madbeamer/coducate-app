#!/bin/bash
set -e

ECR_REGISTRY="262578988534.dkr.ecr.eu-central-1.amazonaws.com"
TARGET_PLATFORM="linux/arm64"

echo "Building Coducate for AWS deployment"
echo "ECR Registry: ${ECR_REGISTRY}"
echo "Target Platform: ${TARGET_PLATFORM}"

echo ""
echo "Logging into ECR..."
aws ecr get-login-password --region "eu-central-1" | docker login --username AWS --password-stdin ${ECR_REGISTRY}

# Backend
echo ""
echo "Building and pushing backend..."
if ! git -C coducate-backend rev-parse HEAD > /dev/null 2>&1; then
    echo "ERROR: coducate-backend is not a git repository"
    exit 1
fi
BACKEND_VERSION=$(git -C coducate-backend rev-parse --short HEAD)
echo "Backend version: ${BACKEND_VERSION}"

docker buildx build \
    --platform ${TARGET_PLATFORM} \
    --tag ${ECR_REGISTRY}/coducate/coducate-backend:latest \
    --tag ${ECR_REGISTRY}/coducate/coducate-backend:${BACKEND_VERSION} \
    --push \
    ./coducate-backend

# Frontend
echo ""
echo "Building and pushing frontend..."
if ! git -C coducate-frontend rev-parse HEAD > /dev/null 2>&1; then
    echo "ERROR: coducate-frontend is not a git repository"
    exit 1
fi
FRONTEND_VERSION=$(git -C coducate-frontend rev-parse --short HEAD)
echo "Frontend version: ${FRONTEND_VERSION}"

docker buildx build \
    --platform ${TARGET_PLATFORM} \
    --tag ${ECR_REGISTRY}/coducate/coducate-frontend:latest \
    --tag ${ECR_REGISTRY}/coducate/coducate-frontend:${FRONTEND_VERSION} \
    --push \
    ./coducate-frontend

echo ""
echo "Build and push complete"
echo ""
echo "Backend images:"
echo "  - ${ECR_REGISTRY}/coducate/coducate-backend:latest"
echo "  - ${ECR_REGISTRY}/coducate/coducate-backend:${BACKEND_VERSION}"
echo ""
echo "Frontend images:"
echo "  - ${ECR_REGISTRY}/coducate/coducate-frontend:latest"
echo "  - ${ECR_REGISTRY}/coducate/coducate-frontend:${FRONTEND_VERSION}"
echo ""
