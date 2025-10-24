# 🚀 Nodegram - Interactive Workspace Platform

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Node.js](https://img.shields.io/badge/Node.js-16+-green.svg)](https://nodejs.org/)
[![React](https://img.shields.io/badge/React-18+-blue.svg)](https://reactjs.org/)
[![PHP](https://img.shields.io/badge/PHP-8.0+-purple.svg)](https://php.net/)

> **Nodegram** is a powerful, interactive workspace platform that allows users to create, manage, and collaborate on various types of content nodes in a visual, drag-and-drop interface. Built with modern web technologies and designed for scalability.

## ✨ Features

### 🎯 Core Functionality
- **16+ Node Types** - Text, images, files, calendars, charts, and more
- **Interactive Editor** - Drag & drop, zoom, pan with D3.js
- **Real-time Collaboration** - Multi-user workspace support
- **Calendar Integration** - Event scheduling and management
- **Advanced Search** - Find nodes by content, type, or metadata

### 🔐 Security & Authentication
- **JWT Authentication** - Secure user sessions
- **Google OAuth** - Social login integration
- **Data Encryption** - Sensitive data encrypted at rest
- **Role-based Access** - Workspace permissions and member management
- **Rate Limiting** - API protection against abuse

### 🎨 User Experience
- **Dark Theme** - Modern, eye-friendly interface
- **Responsive Design** - Works on desktop, tablet, and mobile
- **Keyboard Shortcuts** - Power user productivity features
- **Customizable UI** - Personalize your workspace

## 🏗 Architecture

### Frontend (React + Vite)
```
client/
├── src/
│   ├── components/          # React components
│   │   ├── common/         # Reusable UI components
│   │   ├── layout/         # Layout components
│   │   └── pages/          # Page components
│   ├── store/              # State management
│   ├── utils/              # Utility functions
│   └── App.jsx             # Main application
├── public/                 # Static assets
└── package.json           # Dependencies
```

### Backend (PHP + MySQL)
```
server/
├── api/                   # API endpoints
│   ├── auth/              # Authentication
│   ├── workspace/         # Workspace management
│   ├── subscription/      # Payment processing
│   └── support/           # Support system
├── config/                # Configuration files
├── uploads/               # File storage
└── vendor/                # Composer dependencies
```

## 🚀 Quick Start

### Prerequisites
- **Node.js** 16+ 
- **PHP** 8.0+
- **MySQL** 8.0+
- **Composer** (PHP dependency manager)
- **Docker** (optional, for containerized setup)

### Option 1: Docker Setup (Recommended)

1. **Clone the repository:**
```bash
git clone https://github.com/saintcrystal/nodegram.git
cd nodegram
```

2. **Start with Docker Compose:**
```bash
docker-compose up -d
```

3. **Access the application:**
- Frontend: http://localhost:5173
- Backend API: http://localhost:8000
- Database: localhost:3306

### Option 2: Manual Setup

#### Backend Setup

1. **Install PHP dependencies:**
```bash
cd server
composer install
```

2. **Configure environment:**
```bash
cp env.example .env
# Edit .env with your database credentials
```

3. **Set up database:**
```bash
mysql -u root -p
CREATE DATABASE nodegram CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
# Import the schema
mysql -u root -p nodegram < database.sql
```

4. **Start PHP server:**
```bash
php -S localhost:8000
```

#### Frontend Setup

1. **Install dependencies:**
```bash
cd client
npm install
```

2. **Configure environment:**
```bash
cp env.example .env
# Edit .env with your API URL
```

3. **Start development server:**
```bash
npm run dev
```

## 🛠 Development

### Available Scripts

#### Frontend
```bash
npm run dev          # Start development server
npm run build        # Build for production
npm run preview      # Preview production build
npm run lint         # Run ESLint
```

#### Backend
```bash
composer install     # Install dependencies
composer update      # Update dependencies
php -S localhost:8000 # Start development server
```

## 🚀 Deployment

### Production Build

#### Frontend
```bash
cd client
npm run build
# Deploy dist/ folder to your web server
```

#### Backend
```bash
cd server
# Ensure .env is configured for production
# Deploy to your PHP server
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **D3.js** - For the interactive node editor
- **React** - For the frontend framework
- **Stripe** - For payment processing
- **PHPMailer** - For email functionality

## 📞 Support

- **Issues** - [GitHub Issues](https://github.com/saintcrystal/nodegram/issues)
- **Discussions** - [GitHub Discussions](https://github.com/saintcrystal/nodegram/discussions)
- **Email** - support@nodegram.org

## 🌐 Links

- **Website** - https://nodegram.org
- **Buy me a coffee** - https://buymeacoffee.com/saintcrystal

