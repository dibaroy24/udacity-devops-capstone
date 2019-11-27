#!/usr/bin/env bash
# This file tags and uploads an image to Docker Hub

# Assumes that an image is built via `run_docker.sh`

# Step 1:
# Create dockerpath
# dockerpath=<your docker ID/path>
dockerpath="dibaroy/udacity_devops_capstone_app"

# Step 2:  
# Authenticate & tag
echo "Docker ID and Image: $dockerpath"
docker login --username dibaroy
docker tag udacity_devops_capstone_app dibaroy/udacity_devops_capstone_app:latest

# Step 3:
# Push image to a docker repository
docker push dibaroy/udacity_devops_capstone_app:latest
