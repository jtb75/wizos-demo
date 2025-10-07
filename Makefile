# Wiz OS Base Layer Vulnerability Demo - Makefile

.PHONY: help backend-legacy backend-wizos backend-wizos-nopm backend-wizos-noshell frontend-legacy frontend-wizos frontend-wizos-nopm frontend-wizos-noshell \
        apache-legacy apache-wizos apache-wizos-nopm apache-wizos-noshell nginx-legacy nginx-wizos nginx-wizos-nopm nginx-wizos-noshell \
        scan-backend-legacy scan-backend-wizos scan-backend-wizos-nopm scan-backend-wizos-noshell scan-frontend-legacy scan-frontend-wizos scan-frontend-wizos-nopm scan-frontend-wizos-noshell \
        scan-apache-legacy scan-apache-wizos scan-apache-wizos-nopm scan-apache-wizos-noshell scan-nginx-legacy scan-nginx-wizos scan-nginx-wizos-nopm scan-nginx-wizos-noshell \
        push-backend-legacy push-backend-wizos push-backend-wizos-nopm push-backend-wizos-noshell push-frontend-legacy push-frontend-wizos push-frontend-wizos-nopm push-frontend-wizos-noshell \
        push-apache-legacy push-apache-wizos push-apache-wizos-nopm push-apache-wizos-noshell push-nginx-legacy push-nginx-wizos push-nginx-wizos-nopm push-nginx-wizos-noshell \
        rollout-legacy rollout-wizos rollout-wizos-nopm rollout-wizos-noshell deploy-all clean

# Default target
help:
	@echo "Wiz OS Demo - Available targets:"
	@echo ""
	@echo "Build targets:"
	@echo "  backend-legacy              - Build backend with vulnerable Python base"
	@echo "  backend-wizos               - Build backend with Wiz OS Python base"
	@echo "  backend-wizos-nopm          - Build backend (no package manager, shell retained)"
	@echo "  backend-wizos-noshell       - Build hardened backend (no shell/package manager)"
	@echo "  frontend-legacy             - Build frontend with vulnerable Node base"
	@echo "  frontend-wizos              - Build frontend with Wiz OS Node base"
	@echo "  frontend-wizos-nopm         - Build frontend (no package manager, shell retained)"
	@echo "  frontend-wizos-noshell      - Build hardened frontend (no shell/package manager)"
	@echo "  apache-legacy               - Build Apache with vulnerable Alpine 3.14 base"
	@echo "  apache-wizos                - Build Apache with Wiz OS base"
	@echo "  apache-wizos-nopm           - Build Apache (no package manager, shell retained)"
	@echo "  apache-wizos-noshell        - Build hardened Apache (no shell/package manager)"
	@echo "  nginx-legacy                - Build nginx with vulnerable nginx:1.18 base"
	@echo "  nginx-wizos                 - Build nginx with Wiz OS nginx:latest base"
	@echo "  nginx-wizos-nopm            - Build nginx (no package manager, shell retained)"
	@echo "  nginx-wizos-noshell         - Build hardened nginx (no shell/package manager)"
	@echo ""
	@echo "Scan targets:"
	@echo "  scan-backend-legacy         - Scan backend legacy image with wizcli"
	@echo "  scan-backend-wizos          - Scan backend Wiz OS image with wizcli"
	@echo "  scan-backend-wizos-nopm     - Scan backend no-pm image with wizcli"
	@echo "  scan-backend-wizos-noshell  - Scan backend hardened image with wizcli"
	@echo "  scan-frontend-legacy        - Scan frontend legacy image with wizcli"
	@echo "  scan-frontend-wizos         - Scan frontend Wiz OS image with wizcli"
	@echo "  scan-frontend-wizos-nopm    - Scan frontend no-pm image with wizcli"
	@echo "  scan-frontend-wizos-noshell - Scan frontend hardened image with wizcli"
	@echo "  scan-apache-legacy          - Scan Apache legacy image with wizcli"
	@echo "  scan-apache-wizos           - Scan Apache Wiz OS image with wizcli"
	@echo "  scan-apache-wizos-nopm      - Scan Apache no-pm image with wizcli"
	@echo "  scan-apache-wizos-noshell   - Scan Apache hardened image with wizcli"
	@echo "  scan-nginx-legacy           - Scan nginx legacy image with wizcli"
	@echo "  scan-nginx-wizos            - Scan nginx Wiz OS image with wizcli"
	@echo "  scan-nginx-wizos-nopm       - Scan nginx no-pm image with wizcli"
	@echo "  scan-nginx-wizos-noshell    - Scan nginx hardened image with wizcli"
	@echo ""
	@echo "Push targets:"
	@echo "  push-backend-legacy         - Tag and push backend legacy image to ECR"
	@echo "  push-backend-wizos          - Tag and push backend Wiz OS image to ECR"
	@echo "  push-backend-wizos-nopm     - Tag and push backend no-pm image to ECR"
	@echo "  push-backend-wizos-noshell  - Tag and push backend hardened image to ECR"
	@echo "  push-frontend-legacy        - Tag and push frontend legacy image to ECR"
	@echo "  push-frontend-wizos         - Tag and push frontend Wiz OS image to ECR"
	@echo "  push-frontend-wizos-nopm    - Tag and push frontend no-pm image to ECR"
	@echo "  push-frontend-wizos-noshell - Tag and push frontend hardened image to ECR"
	@echo "  push-apache-legacy          - Tag and push Apache legacy image to ECR"
	@echo "  push-apache-wizos           - Tag and push Apache Wiz OS image to ECR"
	@echo "  push-apache-wizos-nopm      - Tag and push Apache no-pm image to ECR"
	@echo "  push-apache-wizos-noshell   - Tag and push Apache hardened image to ECR"
	@echo "  push-nginx-legacy           - Tag and push nginx legacy image to ECR"
	@echo "  push-nginx-wizos            - Tag and push nginx Wiz OS image to ECR"
	@echo "  push-nginx-wizos-nopm       - Tag and push nginx no-pm image to ECR"
	@echo "  push-nginx-wizos-noshell    - Tag and push nginx hardened image to ECR"
	@echo ""
	@echo "Rollout targets:"
	@echo "  rollout-legacy              - Build, push, and deploy legacy images"
	@echo "  rollout-wizos               - Build, push, and deploy Wiz OS images"
	@echo "  rollout-wizos-nopm          - Build, push, and deploy Wiz OS no-pm images"
	@echo "  rollout-wizos-noshell       - Build, push, and deploy hardened Wiz OS images"
	@echo "  deploy-all                  - Deploy all Kubernetes manifests"
	@echo ""
	@echo "Cleanup:"
	@echo "  clean                  - Remove all built images"

# Backend build targets
backend-legacy:
	docker build --platform linux/amd64 -f backend/Dockerfile.legacy -t wizos-backend:legacy backend/

backend-wizos:
	docker build --platform linux/amd64 -f backend/Dockerfile.wizos -t wizos-backend:wizos backend/

backend-wizos-nopm:
	docker build --platform linux/amd64 -f backend/Dockerfile.wizos-nopm -t wizos-backend:wizos-nopm backend/

backend-wizos-noshell:
	docker build --platform linux/amd64 -f backend/Dockerfile.wizos-noshell -t wizos-backend:wizos-noshell backend/

# Frontend build targets
frontend-legacy:
	docker build --platform linux/amd64 -f frontend/Dockerfile.legacy -t wizos-frontend:legacy frontend/

frontend-wizos:
	docker build --platform linux/amd64 -f frontend/Dockerfile.wizos -t wizos-frontend:wizos frontend/

frontend-wizos-nopm:
	docker build --platform linux/amd64 -f frontend/Dockerfile.wizos-nopm -t wizos-frontend:wizos-nopm frontend/

frontend-wizos-noshell:
	docker build --platform linux/amd64 -f frontend/Dockerfile.wizos-noshell -t wizos-frontend:wizos-noshell frontend/

# Apache build targets
apache-legacy:
	docker build --platform linux/amd64 -f apache-demo/Dockerfile.legacy -t wizos-apache:legacy apache-demo/

apache-wizos:
	@if [ -f .env ]; then \
		export $$(cat .env | xargs) && \
		docker build --platform linux/amd64 \
			--secret id=WIZOS_CLIENT_ID,env=WIZOS_CLIENT_ID \
			--secret id=WIZOS_CLIENT_SECRET,env=WIZOS_CLIENT_SECRET \
			-f apache-demo/Dockerfile.wizos -t wizos-apache:wizos apache-demo/; \
	else \
		echo "Error: .env file not found"; exit 1; \
	fi

apache-wizos-nopm:
	@if [ -f .env ]; then \
		export $$(cat .env | xargs) && \
		docker build --platform linux/amd64 \
			--secret id=WIZOS_CLIENT_ID,env=WIZOS_CLIENT_ID \
			--secret id=WIZOS_CLIENT_SECRET,env=WIZOS_CLIENT_SECRET \
			-f apache-demo/Dockerfile.wizos-nopm -t wizos-apache:wizos-nopm apache-demo/; \
	else \
		echo "Error: .env file not found"; exit 1; \
	fi

apache-wizos-noshell:
	@if [ -f .env ]; then \
		export $$(cat .env | xargs) && \
		docker build --platform linux/amd64 \
			--secret id=WIZOS_CLIENT_ID,env=WIZOS_CLIENT_ID \
			--secret id=WIZOS_CLIENT_SECRET,env=WIZOS_CLIENT_SECRET \
			-f apache-demo/Dockerfile.wizos-noshell -t wizos-apache:wizos-noshell apache-demo/; \
	else \
		echo "Error: .env file not found"; exit 1; \
	fi

# Nginx build targets
nginx-legacy:
	docker build --platform linux/amd64 -f nginx-demo/Dockerfile.legacy -t wizos-nginx:legacy nginx-demo/

nginx-wizos:
	docker build --platform linux/amd64 -f nginx-demo/Dockerfile.wizos -t wizos-nginx:wizos nginx-demo/

nginx-wizos-nopm:
	docker build --platform linux/amd64 -f nginx-demo/Dockerfile.wizos-nopm -t wizos-nginx:wizos-nopm nginx-demo/

nginx-wizos-noshell:
	docker build --platform linux/amd64 -f nginx-demo/Dockerfile.wizos-noshell -t wizos-nginx:wizos-noshell nginx-demo/

# Backend scan targets
scan-backend-legacy:
	./wizcli docker scan --image wizos-backend:legacy --policy jtb75-vulns

scan-backend-wizos:
	./wizcli docker scan --image wizos-backend:wizos --policy jtb75-vulns

scan-backend-wizos-nopm:
	./wizcli docker scan --image wizos-backend:wizos-nopm --policy jtb75-vulns

scan-backend-wizos-noshell:
	./wizcli docker scan --image wizos-backend:wizos-noshell --policy jtb75-vulns

# Frontend scan targets
scan-frontend-legacy:
	./wizcli docker scan --image wizos-frontend:legacy --policy jtb75-vulns

scan-frontend-wizos:
	./wizcli docker scan --image wizos-frontend:wizos --policy jtb75-vulns

scan-frontend-wizos-nopm:
	./wizcli docker scan --image wizos-frontend:wizos-nopm --policy jtb75-vulns

scan-frontend-wizos-noshell:
	./wizcli docker scan --image wizos-frontend:wizos-noshell --policy jtb75-vulns

# Apache scan targets
scan-apache-legacy:
	./wizcli docker scan --image wizos-apache:legacy --policy jtb75-vulns

scan-apache-wizos:
	./wizcli docker scan --image wizos-apache:wizos --policy jtb75-vulns

scan-apache-wizos-nopm:
	./wizcli docker scan --image wizos-apache:wizos-nopm --policy jtb75-vulns

scan-apache-wizos-noshell:
	./wizcli docker scan --image wizos-apache:wizos-noshell --policy jtb75-vulns

# Nginx scan targets
scan-nginx-legacy:
	./wizcli docker scan --image wizos-nginx:legacy --policy jtb75-vulns

scan-nginx-wizos:
	./wizcli docker scan --image wizos-nginx:wizos --policy jtb75-vulns

scan-nginx-wizos-nopm:
	./wizcli docker scan --image wizos-nginx:wizos-nopm --policy jtb75-vulns

scan-nginx-wizos-noshell:
	./wizcli docker scan --image wizos-nginx:wizos-noshell --policy jtb75-vulns

# Push targets
push-backend-legacy:
	docker tag wizos-backend:legacy 070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/backend:legacy
	docker push 070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/backend:legacy

push-backend-wizos:
	docker tag wizos-backend:wizos 070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/backend:wizos
	docker push 070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/backend:wizos

push-backend-wizos-nopm:
	docker tag wizos-backend:wizos-nopm 070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/backend:wizos-nopm
	docker push 070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/backend:wizos-nopm

push-backend-wizos-noshell:
	docker tag wizos-backend:wizos-noshell 070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/backend:wizos-noshell
	docker push 070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/backend:wizos-noshell

push-frontend-legacy:
	docker tag wizos-frontend:legacy 070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/frontend:legacy
	docker push 070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/frontend:legacy

push-frontend-wizos:
	docker tag wizos-frontend:wizos 070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/frontend:wizos
	docker push 070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/frontend:wizos

push-frontend-wizos-nopm:
	docker tag wizos-frontend:wizos-nopm 070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/frontend:wizos-nopm
	docker push 070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/frontend:wizos-nopm

push-frontend-wizos-noshell:
	docker tag wizos-frontend:wizos-noshell 070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/frontend:wizos-noshell
	docker push 070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/frontend:wizos-noshell

# Apache push targets
push-apache-legacy:
	docker tag wizos-apache:legacy 070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/apache:legacy
	docker push 070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/apache:legacy

push-apache-wizos:
	docker tag wizos-apache:wizos 070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/apache:wizos
	docker push 070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/apache:wizos

push-apache-wizos-nopm:
	docker tag wizos-apache:wizos-nopm 070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/apache:wizos-nopm
	docker push 070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/apache:wizos-nopm

push-apache-wizos-noshell:
	docker tag wizos-apache:wizos-noshell 070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/apache:wizos-noshell
	docker push 070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/apache:wizos-noshell

# Nginx push targets
push-nginx-legacy:
	docker tag wizos-nginx:legacy 070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/nginx:legacy
	docker push 070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/nginx:legacy

push-nginx-wizos:
	docker tag wizos-nginx:wizos 070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/nginx:wizos
	docker push 070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/nginx:wizos

push-nginx-wizos-nopm:
	docker tag wizos-nginx:wizos-nopm 070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/nginx:wizos-nopm
	docker push 070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/nginx:wizos-nopm

push-nginx-wizos-noshell:
	docker tag wizos-nginx:wizos-noshell 070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/nginx:wizos-noshell
	docker push 070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/nginx:wizos-noshell

# Rollout targets
rollout-legacy: backend-legacy frontend-legacy apache-legacy nginx-legacy push-backend-legacy push-frontend-legacy push-apache-legacy push-nginx-legacy
	kubectl set image deployment/backend backend=070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/backend:legacy -n demo
	kubectl set image deployment/frontend frontend=070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/frontend:legacy -n demo
	kubectl set image deployment/apache apache=070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/apache:legacy -n demo
	kubectl set image deployment/nginx nginx=070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/nginx:legacy -n demo
	@echo "✓ Legacy images deployed"

rollout-wizos: backend-wizos frontend-wizos apache-wizos nginx-wizos push-backend-wizos push-frontend-wizos push-apache-wizos push-nginx-wizos
	kubectl set image deployment/backend backend=070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/backend:wizos -n demo
	kubectl set image deployment/frontend frontend=070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/frontend:wizos -n demo
	kubectl set image deployment/apache apache=070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/apache:wizos -n demo
	kubectl set image deployment/nginx nginx=070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/nginx:wizos -n demo
	@echo "✓ Wiz OS images deployed"

rollout-wizos-nopm: backend-wizos-nopm frontend-wizos-nopm apache-wizos-nopm nginx-wizos-nopm push-backend-wizos-nopm push-frontend-wizos-nopm push-apache-wizos-nopm push-nginx-wizos-nopm
	kubectl set image deployment/backend backend=070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/backend:wizos-nopm -n demo
	kubectl set image deployment/frontend frontend=070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/frontend:wizos-nopm -n demo
	kubectl set image deployment/apache apache=070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/apache:wizos-nopm -n demo
	kubectl set image deployment/nginx nginx=070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/nginx:wizos-nopm -n demo
	@echo "✓ Wiz OS no-pm images deployed"

rollout-wizos-noshell: backend-wizos-noshell frontend-wizos-noshell apache-wizos-noshell nginx-wizos-noshell push-backend-wizos-noshell push-frontend-wizos-noshell push-apache-wizos-noshell push-nginx-wizos-noshell
	kubectl set image deployment/backend backend=070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/backend:wizos-noshell -n demo
	kubectl set image deployment/frontend frontend=070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/frontend:wizos-noshell -n demo
	kubectl set image deployment/apache apache=070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/apache:wizos-noshell -n demo
	kubectl set image deployment/nginx nginx=070410863011.dkr.ecr.us-east-2.amazonaws.com/demo/nginx:wizos-noshell -n demo
	@echo "✓ Hardened Wiz OS images deployed"

# Deploy all K8s manifests
deploy-all:
	kubectl apply -f k8s/namespace.yaml
	kubectl apply -f k8s/backend-deployment.yaml
	kubectl apply -f k8s/backend-service.yaml
	kubectl apply -f k8s/frontend-deployment.yaml
	kubectl apply -f k8s/frontend-service.yaml
	kubectl apply -f k8s/apache-deployment.yaml
	kubectl apply -f k8s/nginx-deployment.yaml
	@echo "✓ All Kubernetes manifests deployed"

# Clean up
clean:
	docker rmi wizos-backend:legacy || true
	docker rmi wizos-backend:wizos || true
	docker rmi wizos-backend:wizos-nopm || true
	docker rmi wizos-backend:wizos-noshell || true
	docker rmi wizos-frontend:legacy || true
	docker rmi wizos-frontend:wizos || true
	docker rmi wizos-frontend:wizos-nopm || true
	docker rmi wizos-frontend:wizos-noshell || true
	docker rmi wizos-apache:legacy || true
	docker rmi wizos-apache:wizos || true
	docker rmi wizos-apache:wizos-nopm || true
	docker rmi wizos-apache:wizos-noshell || true
	docker rmi wizos-nginx:legacy || true
	docker rmi wizos-nginx:wizos || true
	docker rmi wizos-nginx:wizos-nopm || true
	docker rmi wizos-nginx:wizos-noshell || true
	@echo "✓ All images removed"
