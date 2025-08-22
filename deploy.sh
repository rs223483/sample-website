#!/bin/bash

# Deployment Script for Sample Website
# This script deploys the application to external servers using docker-compose

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DEFAULT_IMAGE_TAG="latest"
DOCKER_COMPOSE_FILE="docker-compose.yml"
HEALTH_CHECK_URL="http://localhost:8080"
HEALTH_CHECK_TIMEOUT=30

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [OPTIONS] COMMAND"
    echo ""
    echo "Commands:"
    echo "  deploy SERVER_NAME    Deploy to specified server"
    echo "  rollback SERVER_NAME  Rollback to previous version"
    echo "  status SERVER_NAME    Check deployment status"
    echo "  logs SERVER_NAME      Show application logs"
    echo ""
    echo "Options:"
    echo "  -t, --tag TAG        Docker image tag (default: latest)"
    echo "  -f, --file FILE      Docker Compose file (default: docker-compose.yml)"
    echo "  -h, --help           Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 deploy staging-server"
    echo "  $0 deploy production-server -t v1.2.0"
    echo "  $0 status staging-server"
}

# Function to deploy to server
deploy_to_server() {
    local server_name=$1
    local image_tag=${2:-$DEFAULT_IMAGE_TAG}
    
    print_status "Deploying to $server_name with image tag: $image_tag"
    
    # Check if server configuration exists
    if [ ! -f "servers/$server_name.conf" ]; then
        print_error "Server configuration not found: servers/$server_name.conf"
        exit 1
    fi
    
    # Source server configuration
    source "servers/$server_name.conf"
    
    print_status "Connecting to $SERVER_HOST..."
    
    # Deploy using SSH
    ssh -o StrictHostKeyChecking=no $SSH_USER@$SERVER_HOST << EOF
        set -e
        
        echo "🚀 Starting deployment on $SERVER_HOST..."
        
        # Navigate to application directory
        cd $APP_DIRECTORY
        
        # Create backup of current deployment
        if [ -f docker-compose.yml ]; then
            echo "📦 Creating backup of current deployment..."
            cp docker-compose.yml docker-compose.yml.backup.\$(date +%Y%m%d_%H%M%S)
        fi
        
        # Update docker-compose.yml with new image tag
        echo "🔄 Updating docker-compose.yml with image tag: $image_tag"
        sed -i "s|image:.*:|image: $IMAGE_NAME:$image_tag|g" docker-compose.yml
        
        # Pull latest image
        echo "⬇️  Pulling latest Docker image..."
        docker-compose pull
        
        # Stop current containers
        echo "⏹️  Stopping current containers..."
        docker-compose down
        
        # Start new containers
        echo "▶️  Starting new containers..."
        docker-compose up -d
        
        # Wait for containers to be ready
        echo "⏳ Waiting for containers to be ready..."
        sleep 10
        
        # Health check
        echo "🏥 Performing health check..."
        if curl -f $HEALTH_CHECK_URL > /dev/null 2>&1; then
            echo "✅ Health check passed!"
        else
            echo "❌ Health check failed!"
            echo "🔄 Rolling back to previous version..."
            docker-compose down
            if [ -f docker-compose.yml.backup.* ]; then
                cp docker-compose.yml.backup.\$(ls -t docker-compose.yml.backup.* | head -1) docker-compose.yml
                docker-compose up -d
            fi
            exit 1
        fi
        
        # Clean up old images
        echo "🧹 Cleaning up old Docker images..."
        docker image prune -f
        
        echo "🎉 Deployment completed successfully!"
EOF
    
    if [ $? -eq 0 ]; then
        print_success "Deployment to $server_name completed successfully!"
    else
        print_error "Deployment to $server_name failed!"
        exit 1
    fi
}

# Function to rollback deployment
rollback_deployment() {
    local server_name=$1
    
    print_status "Rolling back deployment on $server_name"
    
    # Check if server configuration exists
    if [ ! -f "servers/$server_name.conf" ]; then
        print_error "Server configuration not found: servers/$server_name.conf"
        exit 1
    fi
    
    # Source server configuration
    source "servers/$server_name.conf"
    
    print_status "Connecting to $SERVER_HOST..."
    
    # Rollback using SSH
    ssh -o StrictHostKeyChecking=no $SSH_USER@$SERVER_HOST << EOF
        set -e
        
        echo "🔄 Starting rollback on $SERVER_HOST..."
        
        # Navigate to application directory
        cd $APP_DIRECTORY
        
        # Check if backup exists
        if [ ! -f docker-compose.yml.backup.* ]; then
            echo "❌ No backup found for rollback"
            exit 1
        fi
        
        # Stop current containers
        echo "⏹️  Stopping current containers..."
        docker-compose down
        
        # Restore backup
        echo "📦 Restoring previous version..."
        cp docker-compose.yml.backup.\$(ls -t docker-compose.yml.backup.* | head -1) docker-compose.yml
        
        # Start containers
        echo "▶️  Starting containers with previous version..."
        docker-compose up -d
        
        # Wait for containers to be ready
        echo "⏳ Waiting for containers to be ready..."
        sleep 10
        
        # Health check
        echo "🏥 Performing health check..."
        if curl -f $HEALTH_CHECK_URL > /dev/null 2>&1; then
            echo "✅ Rollback completed successfully!"
        else
            echo "❌ Rollback failed - health check failed!"
            exit 1
        fi
        
        echo "🎉 Rollback completed successfully!"
EOF
    
    if [ $? -eq 0 ]; then
        print_success "Rollback on $server_name completed successfully!"
    else
        print_error "Rollback on $server_name failed!"
        exit 1
    fi
}

# Function to check deployment status
check_status() {
    local server_name=$1
    
    print_status "Checking deployment status on $server_name"
    
    # Check if server configuration exists
    if [ ! -f "servers/$server_name.conf" ]; then
        print_error "Server configuration not found: servers/$server_name.conf"
        exit 1
    fi
    
    # Source server configuration
    source "servers/$server_name.conf"
    
    print_status "Connecting to $SERVER_HOST..."
    
    # Check status using SSH
    ssh -o StrictHostKeyChecking=no $SSH_USER@$SERVER_HOST << EOF
        echo "📊 Deployment Status on $SERVER_HOST:"
        echo "=================================="
        
        # Navigate to application directory
        cd $APP_DIRECTORY
        
        # Check if docker-compose.yml exists
        if [ ! -f docker-compose.yml ]; then
            echo "❌ No docker-compose.yml found"
            exit 1
        fi
        
        # Show container status
        echo "🐳 Container Status:"
        docker-compose ps
        
        echo ""
        
        # Show image information
        echo "🖼️  Image Information:"
        docker-compose images
        
        echo ""
        
        # Show recent logs
        echo "📝 Recent Logs:"
        docker-compose logs --tail=10
EOF
}

# Function to show logs
show_logs() {
    local server_name=$1
    
    print_status "Showing logs from $server_name"
    
    # Check if server configuration exists
    if [ ! -f "servers/$server_name.conf" ]; then
        print_error "Server configuration not found: servers/$server_name.conf"
        exit 1
    fi
    
    # Source server configuration
    source "servers/$server_name.conf"
    
    print_status "Connecting to $SERVER_HOST..."
    
    # Show logs using SSH
    ssh -o StrictHostKeyChecking=no $SSH_USER@$SERVER_HOST << EOF
        echo "📝 Application Logs from $SERVER_HOST:"
        echo "====================================="
        
        # Navigate to application directory
        cd $APP_DIRECTORY
        
        # Check if docker-compose.yml exists
        if [ ! -f docker-compose.yml ]; then
            echo "❌ No docker-compose.yml found"
            exit 1
        fi
        
        # Show logs
        docker-compose logs -f
EOF
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -t|--tag)
            IMAGE_TAG="$2"
            shift 2
            ;;
        -f|--file)
            DOCKER_COMPOSE_FILE="$2"
            shift 2
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        *)
            break
            ;;
    esac
done

# Check if command is provided
if [ $# -eq 0 ]; then
    print_error "No command specified"
    show_usage
    exit 1
fi

COMMAND=$1
SERVER_NAME=$2

# Check if server name is provided for commands that need it
if [ "$COMMAND" != "help" ] && [ -z "$SERVER_NAME" ]; then
    print_error "Server name is required for command: $COMMAND"
    show_usage
    exit 1
fi

# Execute command
case $COMMAND in
    deploy)
        deploy_to_server "$SERVER_NAME" "$IMAGE_TAG"
        ;;
    rollback)
        rollback_deployment "$SERVER_NAME"
        ;;
    status)
        check_status "$SERVER_NAME"
        ;;
    logs)
        show_logs "$SERVER_NAME"
        ;;
    help)
        show_usage
        ;;
    *)
        print_error "Unknown command: $COMMAND"
        show_usage
        exit 1
        ;;
esac
