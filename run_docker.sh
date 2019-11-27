#!/usr/bin/env bash

## Complete the following steps to get Docker running locally

# Step 1:
# Build image and add a descriptive tag
sudo docker build --tag=udacity_devops_capstone_app .

# Step 2: 
# List docker images
sudo docker image ls

# Step 3: 
# Run your own app
sudo docker run -p 8000:80 udacity_devops_capstone_app
