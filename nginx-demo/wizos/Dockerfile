# WIZ OS NGINX BASE IMAGE - Minimal vulnerability nginx
FROM registry.os.wiz.io/nginx:latest

# Copy nginx configuration
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/default.conf /etc/nginx/conf.d/default.conf

# Copy custom HTML
COPY html/ /usr/share/nginx/html/

# Set environment variable to track which base image type is used
ENV BASE_IMAGE_TYPE="nginx-wizos"

EXPOSE 80

# nginx image already has correct CMD
