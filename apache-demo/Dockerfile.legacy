# LEGACY ALPINE BASE IMAGE - Vulnerable Apache installation
FROM alpine:3.14

# Install Apache (httpd) from old Alpine repository - contains known vulnerabilities
RUN apk add --no-cache apache2 apache2-utils

# Create directory for web content
RUN mkdir -p /var/www/localhost/htdocs

# Copy application files
COPY public/ /var/www/localhost/htdocs/

# Set environment variable to track which base image type is used
ENV BASE_IMAGE_TYPE="alpine-legacy"

# Apache configuration - run in foreground
RUN sed -i 's/#ServerName www.example.com:80/ServerName localhost:80/' /etc/apache2/httpd.conf
RUN sed -i 's/^Listen 80/Listen 8080/' /etc/apache2/httpd.conf

EXPOSE 8080

# Run Apache in foreground
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
