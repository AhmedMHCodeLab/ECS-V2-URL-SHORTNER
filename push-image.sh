#!/bin/bash

# Exit on any error
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
AWS_REGION="us-east-1"
AWS_ACCOUNT_ID="590183934190"
REPOSITORY_NAME="ecs-v2-url-shortener-repository"
IMAGE_TAG="${1:-latest}"  # Use first argument or default to "latest"

ECR_URL="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
FULL_IMAGE_NAME="${ECR_URL}/${REPOSITORY_NAME}:${IMAGE_TAG}"

echo -e "${YELLOW}=== ECS v2 URL Shortener - ECR Image Push ===${NC}"
echo ""
echo "Configuration:"
echo "  AWS Region:    ${AWS_REGION}"
echo "  AWS Account:   ${AWS_ACCOUNT_ID}"
echo "  Repository:    ${REPOSITORY_NAME}"
echo "  Image Tag:     ${IMAGE_TAG}"
echo "  Full Image:    ${FULL_IMAGE_NAME}"
echo ""

# Step 1: Check if Docker is running
echo -e "${YELLOW}[1/5] Checking Docker...${NC}"
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}ERROR: Docker is not running. Please start Docker and try again.${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Docker is running${NC}"
echo ""

# Step 2: Build Docker image
echo -e "${YELLOW}[2/5] Building Docker image...${NC}"
cd app
if docker build -t url-shortener:local .; then
    echo -e "${GREEN}✓ Image built successfully${NC}"
else
    echo -e "${RED}ERROR: Docker build failed${NC}"
    exit 1
fi
cd ..
echo ""

# Step 3: Authenticate with ECR
echo -e "${YELLOW}[3/5] Authenticating with ECR...${NC}"
if aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_URL}; then
    echo -e "${GREEN}✓ Authenticated with ECR${NC}"
else
    echo -e "${RED}ERROR: ECR authentication failed${NC}"
    echo "Make sure you have AWS credentials configured (aws configure)"
    exit 1
fi
echo ""

# Step 4: Tag image
echo -e "${YELLOW}[4/5] Tagging image...${NC}"
if docker tag url-shortener:local ${FULL_IMAGE_NAME}; then
    echo -e "${GREEN}✓ Image tagged: ${FULL_IMAGE_NAME}${NC}"
else
    echo -e "${RED}ERROR: Image tagging failed${NC}"
    exit 1
fi
echo ""

# Step 5: Push to ECR
echo -e "${YELLOW}[5/5] Pushing image to ECR...${NC}"
if docker push ${FULL_IMAGE_NAME}; then
    echo -e "${GREEN}✓ Image pushed successfully${NC}"
else
    echo -e "${RED}ERROR: Image push failed${NC}"
    exit 1
fi
echo ""

# Success summary
echo -e "${GREEN}=== Push Complete ===${NC}"
echo ""
echo "Image pushed to ECR:"
echo "  ${FULL_IMAGE_NAME}"
echo ""
echo "Image digest:"
docker inspect ${FULL_IMAGE_NAME} --format='{{index .RepoDigests 0}}' 2>/dev/null || echo "  (Digest available in ECR)"
echo ""
echo "To update ECS service with this image:"
echo "  1. Update task definition in Terraform"
echo "  2. Run: terraform apply"
echo ""
echo "Or force new deployment with existing task definition:"
echo "  aws ecs update-service --cluster ecs-v2-url-shortener-cluster \\"
echo "    --service ecs-v2-url-shortener-service --force-new-deployment"
echo ""