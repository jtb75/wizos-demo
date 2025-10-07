# Wiz OS Base Layer Vulnerability Demo

This demonstration shows how containerized applications built on vulnerable base images can be secured by switching to Wiz's vulnerability-free base layers.

## Architecture

- **Backend**: FastAPI (Python 3.9) - Provides a simple REST API
- **Frontend**: Node.js/Express (Node 20) - Serves a web interface that calls the backend

## Demonstration

### Before: Vulnerable Base Images

The initial Dockerfiles use standard base images:
- `python:3.9-slim` - Contains known CVEs in base layer packages
- `node:20-slim` - Contains known CVEs in base layer packages

### After: Wiz OS Base Images

By simply swapping the base images to:
- `registry.os.wiz.io/python:3.9`
- `registry.os.wiz.io/node:20`

All base layer vulnerabilities are remediated without any application code changes.

## Usage

### Build and Run with Vulnerable Images

```bash
docker-compose up --build
```

Visit http://localhost:3000 to see the running application.

### Scan for Vulnerabilities

```bash
# Scan the vulnerable images
docker scout cve backend:vulnerable
docker scout cve frontend:vulnerable
```

### Switch to Wiz OS Base Images

Update the Dockerfiles by uncommenting the Wiz OS base image lines and commenting out the vulnerable base images.

### Rebuild and Rescan

```bash
docker-compose down
docker-compose up --build

# Scan the fixed images
docker scout cve backend:fixed
docker scout cve frontend:fixed
```

## Files

- `backend/` - FastAPI application
- `frontend/` - Node.js/Express application
- `docker-compose.yml` - Container orchestration
- `demo.sh` - Automated demonstration script
