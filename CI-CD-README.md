# CI/CD Pipeline Documentation

This document describes the comprehensive CI/CD pipeline implemented using GitHub Actions for the sample-website project.

## 🚀 Pipeline Overview

The CI/CD pipeline consists of multiple stages that ensure code quality, security, and reliable deployment:

```
Code Push/PR → Lint & Validate → Security Scan → Build & Test → Integration Tests → Deploy → Performance Tests → Notify
```

## 📋 Pipeline Stages

### 1. **Lint and Validate** (`lint`)
- **HTML Validation**: Uses HTMLHint to validate HTML structure and best practices
- **CSS Validation**: Uses Stylelint to ensure CSS follows standards and conventions
- **JavaScript Validation**: Uses ESLint to check JavaScript code quality
- **Dockerfile Validation**: Uses Hadolint to validate Dockerfile best practices

### 2. **Security Scan** (`security`)
- **Trivy Vulnerability Scanner**: Scans for known vulnerabilities in dependencies and base images
- **Results Upload**: Automatically uploads security findings to GitHub Security tab
- **Continuous Monitoring**: Runs on every push and pull request

### 3. **Build and Test** (`build`)
- **Docker Build**: Builds the Docker image using Docker Buildx
- **Image Registry**: Pushes to Docker Hub (docker.io)
- **Smart Tagging**: Automatic versioning based on git events
- **Build Caching**: Optimized builds using GitHub Actions cache
- **Smoke Test**: Basic functionality test of the built image

### 4. **Integration Tests** (`integration`)
- **End-to-End Testing**: Tests the complete application stack
- **HTTP Response Validation**: Verifies correct HTTP status codes
- **Asset Accessibility**: Ensures CSS, JS, and HTML files are accessible
- **Docker Compose Testing**: Tests the full containerized environment

### 5. **Deployment** (`deploy-staging`, `deploy-production`)
- **Staging Deployment**: Automatic deployment on `develop` branch
- **Production Deployment**: Automatic deployment on `main` branch
- **Environment Protection**: Uses GitHub Environments for approval workflows
- **Rollback Capability**: Easy rollback to previous versions

### 6. **Performance Testing** (`performance`)
- **Lighthouse CI**: Automated performance, accessibility, and SEO testing
- **Core Web Vitals**: Monitors key performance metrics
- **Performance Budgets**: Enforces performance standards
- **Results Storage**: Stores performance reports for analysis

### 7. **Notifications** (`notify`)
- **Success Notifications**: Alerts team on successful deployments
- **Failure Notifications**: Immediate alerts on pipeline failures
- **Extensible**: Easy to integrate with Slack, email, or other notification systems

## 🔧 Configuration Files

### GitHub Actions Workflow
- **File**: `.github/workflows/ci-cd.yml`
- **Triggers**: Push to main/develop, Pull Requests, Manual dispatch
- **Environments**: Staging and Production with protection rules

### Linting Configuration
- **ESLint**: `.eslintrc.json` - JavaScript code quality rules
- **Stylelint**: `.stylelintrc.json` - CSS/SCSS code quality rules
- **HTMLHint**: `.htmlhintrc` - HTML validation rules

### Performance Testing
- **Lighthouse CI**: `.lighthouserc.json` - Performance testing configuration
- **Performance Budgets**: Enforces Core Web Vitals thresholds

### Package Management
- **package.json**: Defines scripts and dependencies for local development
- **Dev Dependencies**: Includes all necessary linting and testing tools

## 🚀 Getting Started

### Prerequisites
1. **GitHub Repository**: Ensure your code is in a GitHub repository
2. **GitHub Actions**: Enable GitHub Actions in your repository settings
3. **Container Registry**: Access to Docker Hub (docker.io)

### Initial Setup
1. **Push the Configuration Files**:
   ```bash
   git add .github/workflows/ci-cd.yml
   git add .eslintrc.json .stylelintrc.json .htmlhintrc
   git add .lighthouserc.json package.json
   git commit -m "Add CI/CD pipeline configuration"
   git push origin main
   ```

2. **Set Up Environments** (Optional):
   - Go to Repository Settings → Environments
   - Create `staging` and `production` environments
   - Add protection rules (required reviewers, wait timers)

3. **Configure Secrets** (if needed):
   - Go to Repository Settings → Secrets and variables → Actions
   - Add any required secrets for deployment

### Local Development
```bash
# Install dependencies
npm install

# Run linting
npm run lint

# Run tests
npm run test

# Start application
npm run start

# Stop application
npm run stop
```

## 📊 Pipeline Metrics

### Performance Thresholds
- **Performance Score**: ≥ 80% (Warning if below)
- **Accessibility Score**: ≥ 90% (Error if below)
- **Best Practices Score**: ≥ 80% (Warning if below)
- **SEO Score**: ≥ 80% (Warning if below)

### Core Web Vitals
- **First Contentful Paint**: ≤ 2000ms
- **Largest Contentful Paint**: ≤ 4000ms
- **Cumulative Layout Shift**: ≤ 0.1
- **Total Blocking Time**: ≤ 300ms

## 🔒 Security Features

### Vulnerability Scanning
- **Automated Scanning**: Every commit and PR
- **Dependency Analysis**: Checks for known vulnerabilities
- **Base Image Security**: Validates Docker base images
- **GitHub Security Tab**: Automatic integration with GitHub's security features

### Best Practices
- **Container Security**: Follows Docker security best practices
- **Code Quality**: Enforces coding standards and best practices
- **Access Control**: Environment-based deployment controls

## 🚀 Deployment Strategies

### Staging Environment
- **Branch**: `develop`
- **Purpose**: Pre-production testing and validation
- **Automation**: Automatic deployment on push
- **Testing**: Full integration and performance testing

### Production Environment
- **Branch**: `main`
- **Purpose**: Live production deployment
- **Automation**: Automatic deployment on merge
- **Protection**: Environment protection rules
- **Rollback**: Easy rollback to previous versions

## 📈 Monitoring and Observability

### Pipeline Metrics
- **Build Success Rate**: Track pipeline reliability
- **Deployment Frequency**: Monitor deployment velocity
- **Lead Time**: Measure time from commit to production
- **Mean Time to Recovery**: Track incident response time

### Application Metrics
- **Performance Scores**: Lighthouse CI results
- **Error Rates**: Application error monitoring
- **Response Times**: API and page load performance
- **Resource Usage**: Container resource utilization

## 🔧 Customization

### Adding New Stages
1. **Edit the Workflow**: Modify `.github/workflows/ci-cd.yml`
2. **Add Dependencies**: Update `package.json` if needed
3. **Configure Tools**: Add configuration files for new tools
4. **Test Locally**: Use `act` or GitHub Actions for local testing

### Modifying Linting Rules
- **ESLint**: Edit `.eslintrc.json` for JavaScript rules
- **Stylelint**: Edit `.stylelintrc.json` for CSS rules
- **HTMLHint**: Edit `.htmlhintrc` for HTML rules

### Performance Budgets
- **Edit**: `.lighthouserc.json` to modify performance thresholds
- **Metrics**: Adjust Core Web Vitals thresholds
- **Categories**: Modify category score requirements

## 🐛 Troubleshooting

### Common Issues

#### Pipeline Failures
1. **Check Logs**: Review GitHub Actions logs for detailed error messages
2. **Local Testing**: Run commands locally to reproduce issues
3. **Dependency Issues**: Verify all dependencies are properly installed
4. **Configuration Errors**: Check configuration file syntax

#### Linting Errors
1. **Auto-fix**: Many issues can be auto-fixed with `npm run lint`
2. **Rule Configuration**: Adjust rules in configuration files
3. **Ignore Rules**: Add ignore comments for specific cases

#### Performance Failures
1. **Threshold Adjustment**: Modify performance budgets in `.lighthouserc.json`
2. **Local Testing**: Run Lighthouse CI locally to debug issues
3. **Performance Analysis**: Review detailed Lighthouse reports

### Debug Commands
```bash
# Run specific linting
npm run lint:html
npm run lint:css
npm run lint:js

# Test performance locally
npx lhci autorun

# Debug Docker issues
docker-compose logs
docker system prune -f
```

## 📚 Additional Resources

### Documentation
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Lighthouse CI](https://github.com/GoogleChrome/lighthouse-ci)
- [Trivy Documentation](https://aquasecurity.github.io/trivy/)

### Tools
- **Local Testing**: [act](https://github.com/nektos/act) - Run GitHub Actions locally
- **Performance**: [Lighthouse](https://developers.google.com/web/tools/lighthouse)
- **Security**: [Trivy](https://aquasecurity.github.io/trivy/)
- **Linting**: ESLint, Stylelint, HTMLHint

## 🤝 Contributing

### Pipeline Improvements
1. **Performance**: Optimize build times and resource usage
2. **Security**: Add additional security scanning tools
3. **Testing**: Expand test coverage and automation
4. **Monitoring**: Enhance observability and alerting

### Best Practices
- **Keep Dependencies Updated**: Regular security and feature updates
- **Monitor Performance**: Track pipeline and application metrics
- **Document Changes**: Update this documentation for any modifications
- **Test Thoroughly**: Validate changes in staging before production

---

**Happy Deploying! 🚀**

For questions or issues, please refer to the troubleshooting section or create an issue in the repository.
