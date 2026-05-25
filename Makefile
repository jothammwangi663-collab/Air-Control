.PHONY: help build test deploy clean logs

help:
	@echo "ADSMS Makefile targets:"
	@echo "  make build          - Build all services"
	@echo "  make test           - Test all services"
	@echo "  make up             - Start all services locally"
	@echo "  make down           - Stop all services"
	@echo "  make logs           - View service logs"
	@echo "  make clean          - Clean up containers and volumes"
	@echo "  make deploy         - Deploy to Kubernetes"

# Build all services
build:
	@echo "Building all services..."
	bash scripts/build_all.sh

# Test all services
test:
	@echo "Testing all services..."
	bash scripts/test_all.sh

# Start all services locally
up:
	@echo "Starting ADSMS stack..."
	docker-compose up -d
	@echo "Stack is running. Check logs with 'make logs'"

# Stop all services
down:
	@echo "Stopping ADSMS stack..."
	docker-compose down

# View logs
logs:
	docker-compose logs -f

# Clean up
clean:
	@echo "Cleaning up containers and volumes..."
	docker-compose down -v
	rm -rf build/ dist/

# Deploy to Kubernetes
deploy:
	@echo "Deploying to Kubernetes..."
	bash scripts/deploy_all.sh

# View service status
status:
	kubectl get pods -n adsms

status-local:
	docker-compose ps
