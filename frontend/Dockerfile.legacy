# VULNERABLE BASE IMAGE - Contains known CVEs
FROM node:20-slim

WORKDIR /app

# Copy package files and install dependencies
COPY package.json .
RUN npm install --production

# Copy application code
COPY server.js .
COPY public ./public

# Set environment variable to track which base image type is used
ENV BASE_IMAGE_TYPE="vulnerable"

EXPOSE 3000

CMD ["npm", "start"]
