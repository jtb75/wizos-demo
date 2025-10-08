# WIZ OS BASE IMAGE - Minimal vulnerability base layer with hardened configuration
FROM registry.os.wiz.io/wizos-base:latest

# Install Apache (httpd) using Wiz's apk packages with authentication
# Wiz packages are minimal vulnerability and continuously updated
# WIZOS_CLIENT secrets are passed to this dockerfile by `docker build`
RUN --mount=type=secret,id=WIZOS_CLIENT_ID \
    --mount=type=secret,id=WIZOS_CLIENT_SECRET \
    export $(WIZOS_SECRET_PATH=/run/secrets apk-auth) && \
    apk add --no-cache apache2 apache2-utils

# Create directory for web content
RUN mkdir -p /var/www/localhost/htdocs

# Copy application files
COPY public/ /var/www/localhost/htdocs/

# Set environment variable to track which base image type is used
ENV BASE_IMAGE_TYPE="wiz-os-hardened"

# Apache configuration - run in foreground
RUN sed -i 's/#ServerName www.example.com:80/ServerName localhost:80/' /etc/apache2/httpd.conf
RUN sed -i 's/^Listen 80/Listen 8080/' /etc/apache2/httpd.conf

# Harden the image by removing shell and package manager
# Must be done AFTER setting env vars and installing packages
RUN apk del wizos-keys wizos-apk-auth apk-tools busybox

EXPOSE 8080

# Run Apache in foreground
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
