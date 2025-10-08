# WIZ OS BASE IMAGE - Minimal vulnerability base layer with hardened configuration
FROM registry.os.wiz.io/python:3.9

WORKDIR /app

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY app.py .

# Set environment variable to track which base image type is used
ENV BASE_IMAGE_TYPE="wiz-os-hardened"

# Harden the image by removing shell and package manager
# Must be done AFTER setting env vars
RUN apk del wizos-keys wizos-apk-auth apk-tools busybox

EXPOSE 8000

# WizOS base image has ENTRYPOINT ["/usr/bin/python3"], so CMD should not include python3
CMD ["-m", "uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
