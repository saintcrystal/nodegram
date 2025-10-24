# 🚀 Nodegram is now Open Source

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Node.js](https://img.shields.io/badge/Node.js-16+-green.svg)](https://nodejs.org/)
[![React](https://img.shields.io/badge/React-18+-blue.svg)](https://reactjs.org/)
[![PHP](https://img.shields.io/badge/PHP-8.0+-purple.svg)](https://php.net/)

> **Nodegram** is a powerful, interactive workspace platform that allows users to create, manage, and collaborate on various types of content nodes in a visual, drag-and-drop interface. Built with modern web technologies and designed for scalability.

## [Try Nodegram.org Freemium](https://nodegram.org/)

## ✨ Features

- **16+ Node Types** - Text, images, files, calendars, charts, and more
- **Interactive Editor** - Drag & drop, zoom, pan with D3.js
- **Real-time Collaboration** - Multi-user workspace support
- **Calendar Integration** - Event scheduling and management
- **Advanced Search** - Find nodes by content, type, or metadata
- **Dark Theme** - Modern, eye-friendly interface
- **Responsive Design** - Works on desktop, tablet, and mobile
- **Keyboard Shortcuts** - Power user productivity features
- **Customizable UI** - Personalize your workspace

## 📋 Licensing Options

Nodegram offers flexible licensing to meet different needs:

### 🆓 MIT License (Open Source)
- **Free for commercial use** - Use, modify, and distribute without restrictions
- **In code attribution required** - Build upon Nodegram for your own projects
- **Self-hosting allowed** - Deploy on your own infrastructure with full control

### 💼 Commercial License (Nodegram.org Brand)
- **Exclusive brand usage** - Use the "Nodegram.org" name and branding
- **Domain usage** - Full rights to use nodegram.org domain and subdomains
- **All rights are yours** - Complete ownership of the brand, trademarks, and intellectual property

> **Note**: The MIT license allows you to use the code freely, but if you want to use the "Nodegram" brand name commercially, you'll need a separate commercial license agreement.

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

### Prerequisites
- **Node.js** 16+ 
- **PHP** 8.0+
- **MySQL** 8.0+
- **Composer** (PHP dependency manager)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **D3.js** - For the interactive node editor
- **React** - For the frontend framework
- **Stripe** - For payment processing
- **PHPMailer** - For email functionality

## 🌐 Links

- **Website** - https://nodegram.org
- **Buy me a coffee** - https://buymeacoffee.com/saintcrystal
- **Issues** - [GitHub Issues](https://github.com/saintcrystal/nodegram/issues)

