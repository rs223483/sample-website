# Sample Website Makefile
# Provides easy commands for Docker operations

.PHONY: help build run start stop restart logs status clean full

# Default target
help:
	@echo "Sample Website - Available Commands:"
	@echo ""
	@echo "  make build     - Build the Docker image"
	@echo "  make run       - Build and run the container"
	@echo "  make start     - Start existing container"
	@echo "  make stop      - Stop the container"
	@echo "  make restart   - Restart the container"
	@echo "  make logs      - Show container logs"
	@echo "  make status    - Show container status"
	@echo "  make clean     - Stop and remove container and image"
	@echo "  make full      - Complete setup (build and run)"
	@echo "  make help      - Show this help message"
	@echo ""

# Build the Docker image
build:
	@echo "🔨 Building Docker image..."
	docker build -t sample-website .
	@echo "✅ Image built successfully"

# Run the container
run: build
	@echo "🐳 Starting container..."
	@if command -v docker-compose >/dev/null 2>&1; then \
		docker-compose up -d; \
	else \
		docker run -d -p 8080:80 --name sample-website sample-website; \
	fi
	@echo "✅ Container started successfully"
	@echo "🌐 Website is now running at: http://localhost:8080"

# Start existing container
start:
	@echo "🐳 Starting container..."
	@if command -v docker-compose >/dev/null 2>&1; then \
		docker-compose up -d; \
	else \
		docker start sample-website 2>/dev/null || docker run -d -p 8080:80 --name sample-website sample-website; \
	fi
	@echo "✅ Container started"
	@echo "🌐 Website is now running at: http://localhost:8080"

# Stop the container
stop:
	@echo "🛑 Stopping container..."
	@if command -v docker-compose >/dev/null 2>&1; then \
		docker-compose down; \
	else \
		docker stop sample-website 2>/dev/null || true; \
		docker rm sample-website 2>/dev/null || true; \
	fi
	@echo "✅ Container stopped"

# Restart the container
restart: stop
	@sleep 2
	@$(MAKE) start

# Show container logs
logs:
	@echo "📋 Container logs:"
	@if command -v docker-compose >/dev/null 2>&1; then \
		docker-compose logs -f; \
	else \
		docker logs -f sample-website; \
	fi

# Show container status
status:
	@echo "📊 Container status:"
	@docker ps -a | grep sample-website || echo "No sample-website container found"

# Clean up everything
clean: stop
	@echo "🧹 Cleaning up..."
	@docker rmi sample-website 2>/dev/null || true
	@echo "✅ Cleanup completed"

# Full setup
full: run

# Development commands
dev:
	@echo "🚀 Starting development server..."
	@python3 -m http.server 8000 || python -m SimpleHTTPServer 8000 || echo "Python not found. Open index.html directly in your browser."

# Check Docker
check:
	@echo "🔍 Checking Docker..."
	@if docker info >/dev/null 2>&1; then \
		echo "✅ Docker is running"; \
	else \
		echo "❌ Docker is not running. Please start Docker and try again."; \
		exit 1; \
	fi
