#!/bin/bash

# CI/CD Pipeline Setup Script for Sample Website
# This script helps set up the CI/CD pipeline configuration

set -e

echo "🚀 Setting up CI/CD Pipeline for Sample Website"
echo "================================================"

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Error: Not in a git repository"
    echo "Please run 'git init' first or navigate to a git repository"
    exit 1
fi

# Check if GitHub Actions directory exists
if [ ! -d ".github/workflows" ]; then
    echo "📁 Creating GitHub Actions directory..."
    mkdir -p .github/workflows
fi

# Check if configuration files exist
echo "🔍 Checking configuration files..."

# Check for main workflow file
if [ ! -f ".github/workflows/ci-cd.yml" ]; then
    echo "❌ Missing: .github/workflows/ci-cd.yml"
    echo "Please ensure the CI/CD workflow file is present"
    exit 1
fi

# Check for linting configuration files
if [ ! -f ".eslintrc.json" ]; then
    echo "❌ Missing: .eslintrc.json"
    exit 1
fi

if [ ! -f ".stylelintrc.json" ]; then
    echo "❌ Missing: .stylelintrc.json"
    exit 1
fi

if [ ! -f ".htmlhintrc" ]; then
    echo "❌ Missing: .htmlhintrc"
    exit 1
fi

# Check for performance testing configuration
if [ ! -f ".lighthouserc.json" ]; then
    echo "❌ Missing: .lighthouserc.json"
    exit 1
fi

# Check for package.json
if [ ! -f "package.json" ]; then
    echo "❌ Missing: package.json"
    exit 1
fi

echo "✅ All configuration files are present"

# Install dependencies if package.json exists
if [ -f "package.json" ]; then
    echo "📦 Installing Node.js dependencies..."
    if command -v npm &> /dev/null; then
        npm install
        echo "✅ Dependencies installed successfully"
    else
        echo "⚠️  npm not found. Please install Node.js and npm first"
        echo "   Visit: https://nodejs.org/"
    fi
fi

# Check Docker availability
echo "🐳 Checking Docker availability..."
if command -v docker &> /dev/null; then
    echo "✅ Docker is available"
    
    # Check if Docker daemon is running
    if docker info &> /dev/null; then
        echo "✅ Docker daemon is running"
    else
        echo "⚠️  Docker daemon is not running"
        echo "   Please start Docker and try again"
    fi
else
    echo "⚠️  Docker not found. Please install Docker first"
    echo "   Visit: https://docs.docker.com/get-docker/"
fi

# Check Docker Compose availability
if command -v docker-compose &> /dev/null; then
    echo "✅ Docker Compose is available"
else
    echo "⚠️  Docker Compose not found. Please install Docker Compose first"
    echo "   Visit: https://docs.docker.com/compose/install/"
fi

echo ""
echo "🎯 Next Steps:"
echo "==============="
echo "1. Push your code to GitHub:"
echo "   git add ."
echo "   git commit -m 'Add CI/CD pipeline configuration'"
echo "   git push origin main"
echo ""
echo "2. Enable GitHub Actions in your repository:"
echo "   - Go to your repository on GitHub"
echo "   - Click on 'Actions' tab"
echo "   - Click 'Enable Actions' if prompted"
echo ""
echo "3. Set up environments (optional):"
echo "   - Go to Repository Settings → Environments"
echo "   - Create 'staging' and 'production' environments"
echo "   - Add protection rules as needed"
echo ""
echo "4. Monitor your first pipeline run:"
echo "   - Check the 'Actions' tab for pipeline status"
echo "   - Review logs for any issues"
echo ""
echo "5. Local testing commands:"
echo "   npm run lint          # Run all linting"
echo "   npm run test          # Run integration tests"
echo "   npm run start         # Start the application"
echo "   npm run stop          # Stop the application"
echo ""
echo "📚 Documentation:"
echo "================="
echo "Read CI-CD-README.md for detailed information about the pipeline"
echo ""
echo "🔧 Customization:"
echo "================="
echo "Edit the configuration files to customize:"
echo "- .eslintrc.json         # JavaScript linting rules"
echo "- .stylelintrc.json      # CSS linting rules"
echo "- .htmlhintrc           # HTML validation rules"
echo "- .lighthouserc.json    # Performance testing thresholds"
echo "- .github/workflows/ci-cd.yml # Pipeline workflow"
echo ""
echo "🎉 Setup complete! Your CI/CD pipeline is ready to use."
echo "Happy deploying! 🚀"
