# WIZ OS BASE IMAGE - Minimal vulnerability base layer
FROM registry.os.wiz.io/python:3.9

WORKDIR /app

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY app.py .

# Set environment variable to track which base image type is used
ENV BASE_IMAGE_TYPE="wiz-os-fixed"

EXPOSE 8000

# WizOS base image has ENTRYPOINT ["/usr/bin/python3"], so CMD should not include python3
CMD ["-m", "uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
