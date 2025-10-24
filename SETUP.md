# 🚀 Nodegram Setup Guide

This guide will help you set up Nodegram for development and production environments.

## 📋 Prerequisites

### Required Software
- **Node.js** 16.0 or higher
- **PHP** 8.0 or higher
- **MySQL** 8.0 or higher
- **Composer** (PHP dependency manager)
- **Git** (version control)

### Optional Software
- **Docker** and **Docker Compose** (for containerized setup)
- **Redis** (for caching and sessions)
- **Nginx** (for production web server)

## 🐳 Quick Start with Docker (Recommended)

### 1. Clone the Repository
```bash
git clone https://github.com/saintcrystal/nodegram.git
cd nodegram
```

### 2. Start with Docker Compose
```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

### 3. Access the Application
- **Frontend**: http://localhost:5173
- **Backend API**: http://localhost:8000
- **Database**: localhost:3306
- **Mailhog** (dev): http://localhost:8025

## 🛠 Manual Setup

### Backend Setup (PHP)

#### 1. Install Dependencies
```bash
cd server
composer install
```

#### 2. Environment Configuration
```bash
# Copy environment template
cp env.example .env

# Edit configuration
nano .env
```

**Required Environment Variables:**
```env
# Database Configuration
DB_HOST=localhost
DB_NAME=nodegram
DB_USER=root
DB_PASS=your_password

# Stripe Configuration (for payments)
STRIPE_SECRET_KEY=sk_test_your_stripe_secret_key
STRIPE_PUBLISHABLE_KEY=pk_test_your_stripe_publishable_key
STRIPE_WEBHOOK_SECRET=whsec_your_webhook_secret

# Email Configuration
SMTP_HOST=smtp.gmail.com
SMTP_USERNAME=your_email@gmail.com
SMTP_PASSWORD=your_app_password
SMTP_FROM_EMAIL=your_email@gmail.com

# Security
ENCRYPTION_KEY=your_32_character_encryption_key
ENCRYPTION_IV=your_16_character_iv

# API Configuration
API_URL=http://localhost:5173
FRONTEND_URL=http://localhost:5173
```

#### 3. Database Setup
```bash
# Create database
mysql -u root -p
CREATE DATABASE nodegram CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
exit

# Import schema
mysql -u root -p nodegram < database.sql
```

#### 4. Start PHP Server
```bash
# Development server
php -S localhost:8000

# Or with specific host
php -S 0.0.0.0:8000
```

### Frontend Setup (React)

#### 1. Install Dependencies
```bash
cd client
npm install
```

#### 2. Environment Configuration
```bash
# Copy environment template
cp env.example .env

# Edit configuration
nano .env
```

**Required Environment Variables:**
```env
# API Configuration
VITE_API_URL=http://localhost:8000
VITE_FRONTEND_URL=http://localhost:5173

# Debug Settings
VITE_DEBUG=true
VITE_DISABLE_INSPECT=false
```

#### 3. Start Development Server
```bash
# Development server
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview
```

## 🔧 Configuration Details

### Database Configuration

#### MySQL Setup
```sql
-- Create database
CREATE DATABASE nodegram CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create user (optional)
CREATE USER 'nodegram'@'localhost' IDENTIFIED BY 'your_password';
GRANT ALL PRIVILEGES ON nodegram.* TO 'nodegram'@'localhost';
FLUSH PRIVILEGES;
```

#### Database Schema
The `database.sql` file contains the complete schema with:
- User management tables
- Workspace and node tables
- Subscription and payment tables
- File storage tables
- Support system tables

### Stripe Configuration

#### 1. Create Stripe Account
1. Go to [Stripe Dashboard](https://dashboard.stripe.com/)
2. Create a new account or sign in
3. Get your API keys from the Developers section

#### 2. Configure Webhooks
1. Go to Webhooks in Stripe Dashboard
2. Add endpoint: `https://yourdomain.com/api/subscriptionService/handleStripeWebhook.php`
3. Select events: `checkout.session.completed`, `invoice.payment_succeeded`, etc.
4. Copy the webhook secret to your `.env` file

#### 3. Create Products and Prices
1. Create products in Stripe Dashboard
2. Set up pricing for each plan
3. Copy price IDs to your `.env` file

### Email Configuration

#### Gmail Setup
1. Enable 2-Factor Authentication
2. Generate App Password
3. Use App Password in `SMTP_PASSWORD`

#### Other SMTP Providers
```env
# SendGrid
SMTP_HOST=smtp.sendgrid.net
SMTP_PORT=587
SMTP_USERNAME=apikey
SMTP_PASSWORD=your_sendgrid_api_key

# Mailgun
SMTP_HOST=smtp.mailgun.org
SMTP_PORT=587
SMTP_USERNAME=your_mailgun_username
SMTP_PASSWORD=your_mailgun_password
```

## 🚀 Production Deployment

### Server Requirements
- **PHP** 8.0+ with extensions: mysqli, openssl, curl, gd
- **MySQL** 8.0+ or **MariaDB** 10.3+
- **Nginx** or **Apache** web server
- **SSL Certificate** (Let's Encrypt recommended)
- **Domain name** pointing to your server

### Production Setup

#### 1. Server Preparation
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install required packages
sudo apt install nginx mysql-server php8.1-fpm php8.1-mysql php8.1-curl php8.1-gd php8.1-mbstring php8.1-xml php8.1-zip composer nodejs npm -y
```

#### 2. Database Setup
```bash
# Secure MySQL installation
sudo mysql_secure_installation

# Create database and user
sudo mysql -u root -p
CREATE DATABASE nodegram CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'nodegram'@'localhost' IDENTIFIED BY 'strong_password';
GRANT ALL PRIVILEGES ON nodegram.* TO 'nodegram'@'localhost';
FLUSH PRIVILEGES;
exit
```

#### 3. Application Deployment
```bash
# Clone repository
git clone https://github.com/yourusername/nodegram.git /var/www/nodegram
cd /var/www/nodegram

# Set permissions
sudo chown -R www-data:www-data /var/www/nodegram
sudo chmod -R 755 /var/www/nodegram

# Install dependencies
cd server && composer install --no-dev --optimize-autoloader
cd ../client && npm install && npm run build
```

#### 4. Nginx Configuration
```nginx
server {
    listen 80;
    server_name yourdomain.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name yourdomain.com;
    
    root /var/www/nodegram/client/dist;
    index index.html;
    
    # SSL configuration
    ssl_certificate /path/to/certificate.crt;
    ssl_certificate_key /path/to/private.key;
    
    # Frontend
    location / {
        try_files $uri $uri/ /index.html;
    }
    
    # Backend API
    location /api/ {
        alias /var/www/nodegram/server/;
        try_files $uri $uri/ /index.php?$query_string;
        
        location ~ \.php$ {
            fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
            fastcgi_index index.php;
            fastcgi_param SCRIPT_FILENAME $request_filename;
            include fastcgi_params;
        }
    }
    
    # File uploads
    location /uploads/ {
        alias /var/www/nodegram/server/uploads/;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
```

#### 5. SSL Certificate (Let's Encrypt)
```bash
# Install Certbot
sudo apt install certbot python3-certbot-nginx -y

# Obtain certificate
sudo certbot --nginx -d yourdomain.com

# Auto-renewal
sudo crontab -e
# Add: 0 12 * * * /usr/bin/certbot renew --quiet
```

### Docker Production

#### 1. Production Docker Compose
```yaml
version: '3.8'
services:
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf
      - ./client/dist:/var/www/html
      - ./server:/var/www/html/api
      - ./ssl:/etc/nginx/ssl
    depends_on:
      - php_server

  php_server:
    build: ./server
    environment:
      - DB_HOST=mysql
      - DB_NAME=nodegram
      - DB_USER=nodegram
      - DB_PASS=production_password
    depends_on:
      - mysql

  mysql:
    image: mysql:8.0
    environment:
      - MYSQL_ROOT_PASSWORD=root_password
      - MYSQL_DATABASE=nodegram
      - MYSQL_USER=nodegram
      - MYSQL_PASSWORD=production_password
    volumes:
      - mysql_data:/var/lib/mysql
      - ./database.sql:/docker-entrypoint-initdb.d/database.sql
```

#### 2. Build and Deploy
```bash
# Build production images
docker-compose -f docker-compose.prod.yml build

# Start production services
docker-compose -f docker-compose.prod.yml up -d
```

## 🔍 Troubleshooting

### Common Issues

#### 1. CORS Errors
**Problem**: Frontend can't connect to backend API
**Solution**: Check CORS configuration in server files
```php
// In server/index.php
header('Access-Control-Allow-Origin: ' . $config->get('api_url'));
```

#### 2. Database Connection Failed
**Problem**: Can't connect to MySQL
**Solution**: 
- Check database credentials in `.env`
- Ensure MySQL is running
- Verify database exists

#### 3. File Upload Issues
**Problem**: Files not uploading
**Solution**:
- Check upload directory permissions
- Verify PHP upload limits
- Check file size limits

#### 4. Stripe Webhook Errors
**Problem**: Payment webhooks not working
**Solution**:
- Verify webhook URL is accessible
- Check webhook secret in `.env`
- Ensure HTTPS is enabled

### Debug Mode

#### Enable Debug Logging
```env
# In .env files
DEBUG=true
VITE_DEBUG=true
```

#### Check Logs
```bash
# PHP error logs
tail -f /var/log/php8.1-fpm.log

# Nginx logs
tail -f /var/log/nginx/error.log

# Application logs
tail -f server/api/error.log
```

## 📊 Performance Optimization

### Frontend Optimization
```bash
# Build with optimizations
npm run build

# Analyze bundle size
npm run build -- --analyze
```

### Backend Optimization
```bash
# Optimize Composer autoloader
composer install --no-dev --optimize-autoloader

# Enable OPcache in PHP
# Add to php.ini:
opcache.enable=1
opcache.memory_consumption=128
opcache.max_accelerated_files=4000
```

### Database Optimization
```sql
-- Add indexes for better performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_workspace_user_id ON workspace(user_id);
CREATE INDEX idx_nodes_workspace_id ON nodes(workspace_id);
```
