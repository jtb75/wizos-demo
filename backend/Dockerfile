# VULNERABLE BASE IMAGE - Contains known CVEs
FROM python:3.9-slim

# FIXED BASE IMAGE - Uncomment to use Wiz OS minimal vulnerability base
# FROM registry.os.wiz.io/python:3.9

WORKDIR /app

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY app.py .

# Set environment variable to track which base image type is used
ENV BASE_IMAGE_TYPE="vulnerable"
# ENV BASE_IMAGE_TYPE="wiz-os-fixed"

EXPOSE 8000

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
