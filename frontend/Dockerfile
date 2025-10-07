# VULNERABLE BASE IMAGE - Contains known CVEs
FROM node:20-slim

# FIXED BASE IMAGE - Uncomment to use Wiz OS minimal vulnerability base
# FROM registry.os.wiz.io/node:20

WORKDIR /app

# Copy package files and install dependencies
COPY package.json .
RUN npm install --production

# Copy application code
COPY server.js .
COPY public ./public

# Set environment variable to track which base image type is used
ENV BASE_IMAGE_TYPE="vulnerable"
# ENV BASE_IMAGE_TYPE="wiz-os-fixed"

EXPOSE 3000

CMD ["npm", "start"]
