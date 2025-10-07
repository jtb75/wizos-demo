# WizOS Vulnerability Demonstration

This demonstration shows how containerized applications built on vulnerable base images can be secured using WizOS minimal vulnerability base layers with multiple hardening configurations.

## Architecture

- **Backend**: FastAPI (Python 3.9) - REST API with health checks
- **Frontend**: Node.js/Express (Node 20) - Interactive web dashboard
- **Apache**: Web server demonstrating WizOS apk package authentication
- **Nginx**: Reverse proxy serving as single LoadBalancer entry point

## Image Variants

Each service has 4 build variants demonstrating different security postures:

1. **legacy**: Vulnerable base images (Alpine 3.14, old Python/Node versions) containing known CVEs
2. **wizos**: WizOS minimal vulnerability base images with full package manager and shell
3. **wizos-nopm**: WizOS base with package manager removed, shell retained for debugging
4. **wizos-noshell**: Fully hardened WizOS base with no shell or package manager

### Total Image Matrix
- 4 services × 4 variants = **16 container configurations**

## Prerequisites

- Docker with BuildKit enabled
- kubectl configured for your Kubernetes cluster
- AWS ECR access configured
- WizCLI binary for vulnerability scanning
- WizOS client credentials (for Apache variants with apk authentication)

### Setup WizOS Credentials

Create a `.env` file in the project root:

```bash
WIZOS_CLIENT_ID=your_client_id
WIZOS_CLIENT_SECRET=your_client_secret
```

## Makefile Targets

### Building Images

```bash
# Build all legacy variants
make backend-legacy frontend-legacy apache-legacy nginx-legacy

# Build all wizos variants
make backend-wizos frontend-wizos apache-wizos nginx-wizos

# Build all wizos-nopm variants (no package manager, shell retained)
make backend-wizos-nopm frontend-wizos-nopm apache-wizos-nopm nginx-wizos-nopm

# Build all wizos-noshell variants (fully hardened)
make backend-wizos-noshell frontend-wizos-noshell apache-wizos-noshell nginx-wizos-noshell
```

### Scanning for Vulnerabilities

```bash
# Scan legacy images
make scan-backend-legacy scan-frontend-legacy scan-apache-legacy scan-nginx-legacy

# Scan wizos images
make scan-backend-wizos scan-frontend-wizos scan-apache-wizos scan-nginx-wizos

# Scan all variants of a service
make scan-backend-legacy scan-backend-wizos scan-backend-wizos-nopm scan-backend-wizos-noshell
```

### Pushing to Registry

```bash
# Push legacy variants
make push-backend-legacy push-frontend-legacy push-apache-legacy push-nginx-legacy

# Push wizos variants
make push-backend-wizos push-frontend-wizos push-apache-wizos push-nginx-wizos
```

### Kubernetes Deployment

```bash
# Deploy legacy variants to demo namespace
make rollout-legacy

# Deploy wizos variants
make rollout-wizos

# Deploy wizos-nopm variants
make rollout-wizos-nopm

# Deploy wizos-noshell variants
make rollout-wizos-noshell
```

### Cleanup

```bash
# Remove all local Docker images
make clean
```

## Key Differences

### Legacy Images
- Old Alpine 3.14, Python 3.9-slim, Node 20-slim, Nginx 1.18
- Contains numerous known CVEs in base packages
- No authentication required for package installation
- Full shell and package manager access

### WizOS Images
- Modern WizOS base images with continuously updated packages
- Minimal vulnerability packages from Wiz's authenticated repository
- Apache variants use WizOS apk authentication with client credentials
- Multiple hardening levels available (with/without package manager and shell)

### Hardening Levels
- **wizos**: Full features retained for development/debugging
- **wizos-nopm**: Package manager removed, shell retained for troubleshooting
- **wizos-noshell**: Production-ready, fully hardened (no shell, no package manager)

## Apache WizOS Authentication

Apache variants using WizOS base (`apache-wizos`, `apache-wizos-nopm`, `apache-wizos-noshell`) authenticate with Wiz's apk package repository using Docker build secrets:

```dockerfile
RUN --mount=type=secret,id=WIZOS_CLIENT_ID \
    --mount=type=secret,id=WIZOS_CLIENT_SECRET \
    export $(WIZOS_SECRET_PATH=/run/secrets apk-auth) && \
    apk add --no-cache apache2 apache2-utils
```

## Testing the Deployment

1. Get the Nginx LoadBalancer URL:
```bash
kubectl get svc -n demo nginx-service
```

2. Access the dashboard:
```bash
curl http://<EXTERNAL-IP>/
```

3. Check backend API:
```bash
curl http://<EXTERNAL-IP>/api/data
```

4. Check Apache service:
```bash
curl http://<EXTERNAL-IP>/apache/
```

5. Monitor pod status:
```bash
kubectl get pods -n demo
```

## Platform Notes

All images are built for `linux/amd64` platform to ensure compatibility with cloud deployments:

```bash
docker build --platform linux/amd64 ...
```

## Files Structure

```
.
├── backend/
│   ├── Dockerfile.legacy
│   ├── Dockerfile.wizos
│   ├── Dockerfile.wizos-nopm
│   ├── Dockerfile.wizos-noshell
│   ├── app.py
│   └── requirements.txt
├── frontend/
│   ├── Dockerfile.legacy
│   ├── Dockerfile.wizos
│   ├── Dockerfile.wizos-nopm
│   ├── Dockerfile.wizos-noshell
│   ├── server.js
│   ├── package.json
│   └── public/index.html
├── apache-demo/
│   ├── Dockerfile.legacy
│   ├── Dockerfile.wizos
│   ├── Dockerfile.wizos-nopm
│   ├── Dockerfile.wizos-noshell
│   └── public/index.html
├── nginx-demo/
│   ├── Dockerfile.legacy
│   ├── Dockerfile.wizos
│   ├── Dockerfile.wizos-nopm
│   ├── Dockerfile.wizos-noshell
│   ├── conf/default.conf
│   ├── conf/nginx.conf
│   └── html/index.html
├── k8s/
│   ├── namespace.yaml
│   ├── backend-deployment.yaml
│   ├── backend-service.yaml
│   ├── frontend-deployment.yaml
│   ├── frontend-service.yaml
│   ├── apache-deployment.yaml
│   └── nginx-deployment.yaml
├── Makefile
└── README.md
```

## Technical Details

### CMD vs ENTRYPOINT
WizOS images come with pre-configured `ENTRYPOINT`, so `CMD` should only contain arguments:

```dockerfile
# Correct for WizOS images
CMD ["-m", "uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]

# Incorrect (will fail)
CMD ["python3", "-m", "uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
```

### Nginx Routing
Nginx acts as the single entry point and routes to all services:
- `/` → Frontend dashboard
- `/api/` → Backend API (prefix preserved)
- `/apache/` → Apache web server

### Health Checks
- Backend: `/api/health`
- Frontend: `/health`
- Apache: `/`
- Nginx: `/`
