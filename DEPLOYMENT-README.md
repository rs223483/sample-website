# Deployment Guide - Sample Website

This guide explains how to deploy the Sample Website using the streamlined CI/CD pipeline and deployment scripts.

## Overview

The CI/CD pipeline has been simplified to focus on:
1. **Docker Build**: Build and push Docker images to GitHub Container Registry
2. **Automated Deployment**: Deploy to staging/production servers on branch pushes
3. **Manual Deployment**: Deploy to external servers using the deployment script
4. **Rollback Capability**: Rollback to previous versions if deployment fails

## Prerequisites

### On GitHub Repository
- GitHub Actions enabled
- Repository secrets configured (if using private registry)
- Branch protection rules set up (recommended)

### On Target Servers
- Docker and Docker Compose installed
- SSH access configured
- Proper permissions for deployment user
- Application directory created

## CI/CD Pipeline

### Automatic Deployments

#### Staging Deployment
- **Trigger**: Push to `develop` branch
- **Action**: Automatically deploys to staging server
- **Status**: Available in GitHub Actions → Environments → Staging

#### Production Deployment
- **Trigger**: Push to `main` branch
- **Action**: Automatically deploys to production server
- **Status**: Available in GitHub Actions → Environments → Production

### Manual Deployments

#### External Server Deployment
- **Trigger**: Manual workflow dispatch
- **Action**: Deploys to external server
- **Status**: Available in GitHub Actions → Environments → External

## Deployment Script

The `deploy.sh` script provides manual deployment capabilities with rollback support.

### Usage

```bash
# Deploy to staging server
./deploy.sh deploy staging

# Deploy to production server with specific tag
./deploy.sh deploy production -t v1.2.0

# Check deployment status
./deploy.sh status staging

# View application logs
./deploy.sh logs production

# Rollback deployment
./deploy.sh rollback staging

# Show help
./deploy.sh help
```

### Script Features

- ✅ **Automated Rollback**: Automatically rolls back on health check failure
- ✅ **Backup Management**: Creates timestamped backups before deployment
- ✅ **Health Checks**: Verifies deployment success
- ✅ **Cleanup**: Removes old Docker images
- ✅ **Colored Output**: Easy-to-read status messages
- ✅ **Error Handling**: Comprehensive error handling and reporting

## Server Configuration

### Configuration Files

Server configurations are stored in the `servers/` directory:

```
servers/
├── staging.conf      # Staging server configuration
├── production.conf   # Production server configuration
└── external.conf     # External server configuration
```

### Configuration Format

Each configuration file contains:

```bash
# Server Configuration
SERVER_HOST="server.example.com"
SSH_USER="deploy"
APP_DIRECTORY="/opt/sample-website"
IMAGE_NAME="ghcr.io/rs223483/sample-website"
```

### Required Variables

- `SERVER_HOST`: IP address or hostname of the target server
- `SSH_USER`: SSH username for deployment
- `APP_DIRECTORY`: Path to application directory on server
- `IMAGE_NAME`: Full Docker image name (including registry)

## Server Setup

### 1. Install Docker and Docker Compose

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install docker.io docker-compose

# CentOS/RHEL
sudo yum install docker docker-compose

# Enable and start Docker
sudo systemctl enable docker
sudo systemctl start docker
```

### 2. Create Application Directory

```bash
sudo mkdir -p /opt/sample-website
sudo chown $USER:$USER /opt/sample-website
cd /opt/sample-website
```

### 3. Create docker-compose.yml

```yaml
version: '3.8'

services:
  sample-website:
    image: ghcr.io/rs223483/sample-website:latest
    container_name: sample-website
    restart: unless-stopped
    ports:
      - "8080:80"
    volumes:
      - ./logs:/var/log/nginx
    networks:
      - app-network

networks:
  app-network:
    driver: bridge

volumes:
  logs:
```

### 4. Configure SSH Access

```bash
# Generate SSH key pair (if not exists)
ssh-keygen -t rsa -b 4096 -C "deploy@example.com"

# Copy public key to server
ssh-copy-id deploy@server.example.com

# Test SSH connection
ssh deploy@server.example.com "echo 'SSH connection successful'"
```

## Deployment Process

### 1. Automatic Deployment (GitHub Actions)

1. **Push Code**: Push to `main` or `develop` branch
2. **Build Image**: GitHub Actions builds and pushes Docker image
3. **Deploy**: Automatic deployment to respective server
4. **Health Check**: Verification of deployment success

### 2. Manual Deployment (Script)

1. **Prepare**: Ensure server configuration is correct
2. **Deploy**: Run `./deploy.sh deploy SERVER_NAME`
3. **Monitor**: Watch deployment progress
4. **Verify**: Check deployment status and logs

### 3. Rollback Process

1. **Trigger**: Automatic on health check failure or manual command
2. **Stop**: Stop current containers
3. **Restore**: Restore previous docker-compose.yml
4. **Restart**: Start containers with previous version
5. **Verify**: Health check verification

## Monitoring and Troubleshooting

### Health Checks

The deployment script performs health checks by:
- Waiting for containers to start
- Testing HTTP endpoint accessibility
- Verifying response status

### Logs

Access logs in multiple ways:

```bash
# Using deployment script
./deploy.sh logs SERVER_NAME

# Direct SSH access
ssh user@server "cd /opt/sample-website && docker-compose logs -f"

# Container logs
docker logs sample-website
```

### Common Issues

#### SSH Connection Failed
- Verify SSH key is properly configured
- Check server firewall settings
- Ensure SSH service is running

#### Docker Pull Failed
- Verify image exists in registry
- Check authentication credentials
- Ensure network connectivity

#### Health Check Failed
- Check container logs for errors
- Verify port configuration
- Check application startup process

#### Permission Denied
- Ensure deployment user has proper permissions
- Check directory ownership
- Verify Docker group membership

## Security Considerations

### SSH Security
- Use SSH keys instead of passwords
- Restrict SSH access to deployment IPs
- Use non-root deployment user

### Docker Security
- Run containers as non-root user
- Use specific image tags (not `latest`)
- Regularly update base images
- Scan images for vulnerabilities

### Network Security
- Use internal networks when possible
- Restrict port exposure
- Implement proper firewall rules

## Best Practices

### Deployment
- Always test on staging first
- Use semantic versioning for tags
- Implement blue-green deployments for zero-downtime
- Monitor deployment metrics

### Configuration Management
- Use environment-specific configurations
- Store sensitive data in secrets
- Version control configuration files
- Document configuration changes

### Monitoring
- Set up application monitoring
- Configure alerting for failures
- Track deployment success rates
- Monitor resource usage

## Troubleshooting Commands

### Check Container Status
```bash
docker-compose ps
docker-compose logs
```

### Check System Resources
```bash
docker system df
docker stats
```

### Clean Up Resources
```bash
docker system prune -f
docker image prune -f
```

### Debug Deployment
```bash
# Check deployment script logs
./deploy.sh status SERVER_NAME

# SSH to server for direct debugging
ssh deploy@SERVER_HOST
cd /opt/sample-website
docker-compose logs -f
```

## Support

For deployment issues:
1. Check GitHub Actions logs
2. Review server logs
3. Verify configuration files
4. Test SSH connectivity
5. Check Docker service status

---

**Happy Deploying! 🚀**
