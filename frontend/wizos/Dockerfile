# WIZ OS BASE IMAGE - Minimal vulnerability base layer
FROM registry.os.wiz.io/node:20

WORKDIR /app

# Copy package files and install dependencies
COPY package.json .
RUN npm install --production

# Copy application code
COPY server.js .
COPY public ./public

# Set environment variable to track which base image type is used
ENV BASE_IMAGE_TYPE="wiz-os-fixed"

EXPOSE 3000

# WizOS base image has ENTRYPOINT ["/usr/bin/node"], so CMD should not include node
CMD ["server.js"]
