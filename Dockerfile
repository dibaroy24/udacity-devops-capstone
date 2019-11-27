FROM nginx:alpine

# Copy source code to working directory
COPY src/index.html /usr/share/nginx/html/index.html

# Expose port 80
EXPOSE 80
