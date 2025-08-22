#!/bin/bash

# Sample Website Build Script
# This script helps you build and run the dockerized website

set -e

echo "🚀 Sample Website Build Script"
echo "================================"

# Function to check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        echo "❌ Docker is not running. Please start Docker and try again."
        exit 1
    fi
    echo "✅ Docker is running"
}

# Function to build the image
build_image() {
    echo "🔨 Building Docker image..."
    docker build -t sample-website .
    echo "✅ Image built successfully"
}

# Function to run with docker-compose
run_compose() {
    echo "🐳 Starting container with Docker Compose..."
    docker-compose up -d
    echo "✅ Container started successfully"
    echo "🌐 Website is now running at: http://localhost:8080"
}

# Function to run with docker directly
run_docker() {
    echo "🐳 Starting container with Docker..."
    docker run -d -p 8080:80 --name sample-website sample-website
    echo "✅ Container started successfully"
    echo "🌐 Website is now running at: http://localhost:8080"
}

# Function to stop container
stop_container() {
    echo "🛑 Stopping container..."
    if command -v docker-compose &> /dev/null; then
        docker-compose down
    else
        docker stop sample-website 2>/dev/null || true
        docker rm sample-website 2>/dev/null || true
    fi
    echo "✅ Container stopped"
}

# Function to show logs
show_logs() {
    echo "📋 Container logs:"
    if command -v docker-compose &> /dev/null; then
        docker-compose logs -f
    else
        docker logs -f sample-website
    fi
}

# Function to show status
show_status() {
    echo "📊 Container status:"
    docker ps -a | grep sample-website || echo "No sample-website container found"
}

# Function to clean up
cleanup() {
    echo "🧹 Cleaning up..."
    stop_container
    docker rmi sample-website 2>/dev/null || true
    echo "✅ Cleanup completed"
}

# Main script logic
case "${1:-help}" in
    "build")
        check_docker
        build_image
        ;;
    "run")
        check_docker
        if command -v docker-compose &> /dev/null; then
            run_compose
        else
            run_docker
        fi
        ;;
    "start")
        check_docker
        if command -v docker-compose &> /dev/null; then
            docker-compose up -d
        else
            docker start sample-website 2>/dev/null || run_docker
        fi
        echo "✅ Container started"
        echo "🌐 Website is now running at: http://localhost:8080"
        ;;
    "stop")
        stop_container
        ;;
    "restart")
        stop_container
        sleep 2
        if command -v docker-compose &> /dev/null; then
            run_compose
        else
            run_docker
        fi
        ;;
    "logs")
        show_logs
        ;;
    "status")
        show_status
        ;;
    "cleanup")
        cleanup
        ;;
    "full")
        check_docker
        build_image
        if command -v docker-compose &> /dev/null; then
            run_compose
        else
            run_docker
        fi
        ;;
    "help"|*)
        echo "Usage: $0 {build|run|start|stop|restart|logs|status|cleanup|full|help}"
        echo ""
        echo "Commands:"
        echo "  build    - Build the Docker image"
        echo "  run      - Build and run the container"
        echo "  start    - Start existing container or create new one"
        echo "  stop     - Stop the container"
        echo "  restart  - Restart the container"
        echo "  logs     - Show container logs"
        echo "  status   - Show container status"
        echo "  cleanup  - Stop and remove container and image"
        echo "  full     - Build and run (full setup)"
        echo "  help     - Show this help message"
        echo ""
        echo "Examples:"
        echo "  $0 build     # Build the image only"
        echo "  $0 run       # Build and run"
        echo "  $0 full      # Complete setup"
        echo "  $0 logs      # View logs"
        echo "  $0 cleanup   # Clean everything"
        ;;
esac
