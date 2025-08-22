# Sample Website - AI Challenge

A modern, responsive website built with HTML, CSS, and JavaScript, fully dockerized for easy deployment.

## Features

- 🎨 **Modern Design**: Clean, responsive design with smooth animations
- 📱 **Mobile First**: Optimized for all device sizes
- 🚀 **Performance**: Optimized CSS and JavaScript with lazy loading
- 🔒 **Security**: Security headers and best practices
- 🐳 **Dockerized**: Easy deployment with Docker and Docker Compose
- 📝 **Contact Form**: Interactive contact form with validation
- 🎭 **Smooth Animations**: CSS animations and scroll effects

## Technologies Used

- **Frontend**: HTML5, CSS3, JavaScript (ES6+)
- **Web Server**: Nginx
- **Containerization**: Docker
- **Fonts**: Google Fonts (Inter)
- **Icons**: Emoji icons for simplicity

## Project Structure

```
sample-website/
├── index.html          # Main HTML file
├── styles.css          # CSS styles and animations
├── script.js           # JavaScript functionality
├── Dockerfile          # Docker configuration
├── nginx.conf          # Nginx server configuration
├── docker-compose.yml  # Docker Compose configuration
├── .dockerignore       # Docker ignore file
└── README.md           # This file
```

## Quick Start

### Option 1: Using Docker Compose (Recommended)

1. **Navigate to the project directory:**
   ```bash
   cd sample-website
   ```

2. **Build and run the container:**
   ```bash
   docker-compose up --build
   ```

3. **Access the website:**
   Open your browser and go to `http://localhost:8080`

4. **Stop the container:**
   ```bash
   docker-compose down
   ```

### Option 2: Using Docker directly

1. **Build the Docker image:**
   ```bash
   docker build -t sample-website .
   ```

2. **Run the container:**
   ```bash
   docker run -d -p 8080:80 --name sample-website sample-website
   ```

3. **Access the website:**
   Open your browser and go to `http://localhost:8080`

4. **Stop and remove the container:**
   ```bash
   docker stop sample-website
   docker rm sample-website
   ```

## Development

### Local Development (without Docker)

1. **Open the HTML file directly in your browser:**
   - Double-click `index.html` or drag it into your browser
   - Or use a local server like Python's built-in server:
     ```bash
     python3 -m http.server 8000
     ```

2. **Make changes to the files:**
   - Edit `index.html` for structure
   - Edit `styles.css` for styling
   - Edit `script.js` for functionality

### Customization

- **Colors**: Modify the CSS variables in `styles.css`
- **Content**: Update the HTML content in `index.html`
- **Functionality**: Add new features in `script.js`
- **Styling**: Customize the design in `styles.css`

## Docker Configuration

### Dockerfile
- Uses lightweight Alpine Linux Nginx image
- Copies website files to Nginx serving directory
- Exposes port 80

### Nginx Configuration
- Optimized for performance with gzip compression
- Security headers enabled
- Static asset caching
- Client-side routing support

### Docker Compose
- Maps port 8080 on host to port 80 in container
- Automatic restart policy
- Volume mounting for logs
- Custom network configuration

## Performance Features

- **Gzip Compression**: Reduces file sizes for faster loading
- **Asset Caching**: Long-term caching for static files
- **Lazy Loading**: Images and content load as needed
- **Minified Assets**: Optimized CSS and JavaScript
- **CDN Ready**: Easy to deploy to CDN services

## Security Features

- **Security Headers**: XSS protection, frame options, content type options
- **Input Validation**: Form validation on both client and server side
- **HTTPS Ready**: Configured for secure connections
- **Access Control**: Denies access to sensitive files

## Browser Support

- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)
- Mobile browsers (iOS Safari, Chrome Mobile)

## Deployment

### Production Deployment

1. **Build the production image:**
   ```bash
   docker build -t sample-website:production .
   ```

2. **Run with production settings:**
   ```bash
   docker run -d -p 80:80 --name sample-website-prod sample-website:production
   ```

### Cloud Deployment

- **AWS**: Use ECS or EC2 with the Docker image
- **Google Cloud**: Deploy to Cloud Run or GKE
- **Azure**: Use Azure Container Instances or AKS
- **DigitalOcean**: Deploy to App Platform or Droplets

## Monitoring and Logs

- **Access Logs**: `/var/log/nginx/access.log`
- **Error Logs**: `/var/log/nginx/error.log`
- **Container Logs**: `docker logs sample-website`

## Troubleshooting

### Common Issues

1. **Port already in use:**
   ```bash
   # Check what's using port 8080
   lsof -i :8080
   
   # Use a different port in docker-compose.yml
   ports:
     - "8081:80"
   ```

2. **Container won't start:**
   ```bash
   # Check container logs
   docker logs sample-website
   
   # Check container status
   docker ps -a
   ```

3. **Website not loading:**
   - Verify container is running: `docker ps`
   - Check port mapping: `docker port sample-website`
   - Verify firewall settings

### Performance Issues

- Enable gzip compression in nginx.conf
- Optimize images and assets
- Use CDN for static content
- Monitor container resource usage

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is created for the AI Challenge and is open source.

## Support

For issues or questions:
- Check the troubleshooting section
- Review the Docker and Nginx logs
- Ensure all dependencies are properly installed

---

**Happy Coding! 🚀**
