# DM System Tutorial: Security & Deployment

## Table of Contents
1. [Security Best Practices](#security-best-practices)
2. [Authentication & Authorization](#authentication--authorization)
3. [Data Validation & Sanitization](#data-validation--sanitization)
4. [Rate Limiting & Abuse Prevention](#rate-limiting--abuse-prevention)
5. [Deployment Guide](#deployment-guide)
6. [Testing Strategy](#testing-strategy)

---

## Security Best Practices

### 1. Environment Variables & Configuration

```javascript
// .env (Backend)
NODE_ENV=production
PORT=5000
MONGODB_URI=mongodb://localhost:27017/dm_system
JWT_SECRET=your-super-secure-jwt-secret-here
JWT_EXPIRES_IN=7d

# CORS settings
CLIENT_URL=http://localhost:3000

# File upload settings
MAX_FILE_SIZE=10485760  # 10MB
ALLOWED_FILE_TYPES=image/jpeg,image/png,image/gif,application/pdf

# Rate limiting
RATE_LIMIT_WINDOW_MS=900000  # 15 minutes
RATE_LIMIT_MAX_REQUESTS=100

# Email settings (for notifications)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-app-password

# AWS S3 (for file storage)
AWS_REGION=us-east-1
AWS_ACCESS_KEY_ID=your-access-key
AWS_SECRET_ACCESS_KEY=your-secret-key
S3_BUCKET_NAME=your-bucket-name
```

```javascript
// config/security.js
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const mongoSanitize = require('express-mongo-sanitize');
const xss = require('xss-clean');
const hpp = require('hpp');

const securityMiddleware = (app) => {
  // Basic security headers
  app.use(helmet({
    crossOriginResourcePolicy: { policy: "cross-origin" },
    contentSecurityPolicy: {
      directives: {
        defaultSrc: ["'self'"],
        styleSrc: ["'self'", "'unsafe-inline'", "https://fonts.googleapis.com"],
        fontSrc: ["'self'", "https://fonts.gstatic.com"],
        imgSrc: ["'self'", "data:", "https:", "blob:"],
        scriptSrc: ["'self'"],
        connectSrc: ["'self'", "ws:", "wss:"],
      },
    },
  }));

  // Rate limiting
  const limiter = rateLimit({
    windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS) || 15 * 60 * 1000,
    max: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS) || 100,
    message: {
      error: 'Too many requests from this IP, please try again later.',
    },
    standardHeaders: true,
    legacyHeaders: false,
  });

  app.use('/api/', limiter);

  // More strict rate limiting for auth endpoints
  const authLimiter = rateLimit({
    windowMs: 15 * 60 * 1000, // 15 minutes
    max: 5, // 5 attempts per window
    message: {
      error: 'Too many authentication attempts, please try again later.',
    },
    skipSuccessfulRequests: true,
  });

  app.use('/api/auth/login', authLimiter);
  app.use('/api/auth/register', authLimiter);

  // Data sanitization against NoSQL injection
  app.use(mongoSanitize());

  // Data sanitization against XSS
  app.use(xss());

  // Prevent parameter pollution
  app.use(hpp());
};

module.exports = securityMiddleware;
```

### 2. JWT Token Security

```javascript
// middleware/auth.js
const jwt = require('jsonwebtoken');
const User = require('../models/User');

// Token blacklist (in production, use Redis)
const blacklistedTokens = new Set();

const authMiddleware = async (req, res, next) => {
  try {
    const authHeader = req.header('Authorization');
    
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ message: 'Access denied. No valid token provided.' });
    }

    const token = authHeader.substring(7); // Remove 'Bearer ' prefix

    // Check if token is blacklisted
    if (blacklistedTokens.has(token)) {
      return res.status(401).json({ message: 'Token has been invalidated.' });
    }

    // Verify token
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    
    // Check if user still exists
    const user = await User.findById(decoded.userId).select('-password');
    if (!user) {
      return res.status(401).json({ message: 'User no longer exists.' });
    }

    // Check if user changed password after token was issued
    if (user.passwordChangedAt && user.passwordChangedAt > new Date(decoded.iat * 1000)) {
      return res.status(401).json({ 
        message: 'Password was recently changed. Please log in again.' 
      });
    }

    req.user = { userId: user._id, user };
    next();
  } catch (error) {
    if (error.name === 'JsonWebTokenError') {
      return res.status(401).json({ message: 'Invalid token.' });
    } else if (error.name === 'TokenExpiredError') {
      return res.status(401).json({ message: 'Token has expired.' });
    }
    
    console.error('Auth middleware error:', error);
    res.status(500).json({ message: 'Server error in authentication.' });
  }
};

// Function to blacklist a token (for logout)
const blacklistToken = (token) => {
  blacklistedTokens.add(token);
  
  // Clean up expired tokens periodically
  setTimeout(() => {
    blacklistedTokens.delete(token);
  }, 7 * 24 * 60 * 60 * 1000); // 7 days
};

module.exports = { authMiddleware, blacklistToken };
```

### 3. Input Validation & Sanitization

```javascript
// middleware/validation.js
const { body, validationResult } = require('express-validator');
const DOMPurify = require('isomorphic-dompurify');

// Custom validation middleware
const validateInput = (req, res, next) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({
      message: 'Validation failed',
      errors: errors.array()
    });
  }
  next();
};

// Sanitize HTML content in messages
const sanitizeMessage = (req, res, next) => {
  if (req.body.content) {
    // Remove potentially dangerous HTML but keep basic formatting
    req.body.content = DOMPurify.sanitize(req.body.content, {
      ALLOWED_TAGS: ['b', 'i', 'em', 'strong', 'br'],
      ALLOWED_ATTR: []
    });
    
    // Limit message length
    if (req.body.content.length > 4000) {
      return res.status(400).json({
        message: 'Message too long. Maximum 4000 characters allowed.'
      });
    }
  }
  next();
};

// Message validation rules
const messageValidation = [
  body('content')
    .optional()
    .isString()
    .trim()
    .isLength({ min: 1, max: 4000 })
    .withMessage('Message content must be 1-4000 characters'),
  
  body('type')
    .optional()
    .isIn(['text', 'image', 'file'])
    .withMessage('Invalid message type'),
  
  body('conversationId')
    .isMongoId()
    .withMessage('Invalid conversation ID'),
  
  body('replyTo')
    .optional()
    .isMongoId()
    .withMessage('Invalid reply message ID')
];

// User registration validation
const registrationValidation = [
  body('username')
    .isLength({ min: 3, max: 30 })
    .matches(/^[a-zA-Z0-9_]+$/)
    .withMessage('Username must be 3-30 characters and contain only letters, numbers, and underscores'),
  
  body('email')
    .isEmail()
    .normalizeEmail()
    .withMessage('Please provide a valid email address'),
  
  body('password')
    .isLength({ min: 8 })
    .matches(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]/)
    .withMessage('Password must be at least 8 characters with uppercase, lowercase, number, and special character'),
  
  body('displayName')
    .isLength({ min: 1, max: 50 })
    .trim()
    .escape()
    .withMessage('Display name must be 1-50 characters')
];

module.exports = {
  validateInput,
  sanitizeMessage,
  messageValidation,
  registrationValidation
};
```

### 4. File Upload Security

```javascript
// middleware/upload.js
const multer = require('multer');
const path = require('path');
const crypto = require('crypto');

// File type validation
const fileFilter = (req, file, cb) => {
  const allowedTypes = process.env.ALLOWED_FILE_TYPES?.split(',') || [
    'image/jpeg',
    'image/jpg',
    'image/png',
    'image/gif',
    'application/pdf',
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
  ];

  if (allowedTypes.includes(file.mimetype)) {
    cb(null, true);
  } else {
    cb(new Error('Invalid file type. Only images and documents are allowed.'), false);
  }
};

// Generate secure filename
const generateFilename = (file) => {
  const timestamp = Date.now();
  const randomBytes = crypto.randomBytes(16).toString('hex');
  const extension = path.extname(file.originalname);
  return `${timestamp}-${randomBytes}${extension}`;
};

// Multer configuration
const upload = multer({
  storage: multer.memoryStorage(), // Store in memory for processing
  limits: {
    fileSize: parseInt(process.env.MAX_FILE_SIZE) || 10 * 1024 * 1024, // 10MB
    files: 1 // Only one file per request
  },
  fileFilter: fileFilter
});

// File upload middleware with virus scanning (basic)
const uploadMiddleware = (fieldName) => {
  return [
    upload.single(fieldName),
    (req, res, next) => {
      if (req.file) {
        // Basic file validation
        const buffer = req.file.buffer;
        
        // Check for executable signatures (basic malware prevention)
        const executableSignatures = [
          Buffer.from([0x4D, 0x5A]), // PE executable
          Buffer.from([0x7F, 0x45, 0x4C, 0x46]), // ELF executable
        ];
        
        for (const signature of executableSignatures) {
          if (buffer.indexOf(signature) === 0) {
            return res.status(400).json({
              message: 'Executable files are not allowed.'
            });
          }
        }
        
        // Generate secure filename
        req.file.secureFilename = generateFilename(req.file);
      }
      next();
    }
  ];
};

module.exports = { uploadMiddleware };
```

---

## Deployment Guide

### 1. Docker Configuration

```dockerfile
# Dockerfile (Backend)
FROM node:18-alpine

# Create app directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production && npm cache clean --force

# Copy source code
COPY . .

# Create non-root user
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001

# Change ownership of the app directory
RUN chown -R nextjs:nodejs /app
USER nextjs

# Expose port
EXPOSE 5000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:5000/api/health || exit 1

CMD ["node", "server.js"]
```

```dockerfile
# Dockerfile (Frontend)
FROM node:18-alpine as build

WORKDIR /app
COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

# Production stage
FROM nginx:alpine

COPY --from=build /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

```yaml
# docker-compose.yml
version: '3.8'

services:
  mongodb:
    image: mongo:6.0
    restart: unless-stopped
    environment:
      MONGO_INITDB_ROOT_USERNAME: admin
      MONGO_INITDB_ROOT_PASSWORD: ${MONGO_PASSWORD}
      MONGO_INITDB_DATABASE: dm_system
    volumes:
      - mongo_data:/data/db
    networks:
      - dm_network

  backend:
    build: ./backend
    restart: unless-stopped
    environment:
      NODE_ENV: production
      MONGODB_URI: mongodb://admin:${MONGO_PASSWORD}@mongodb:27017/dm_system?authSource=admin
      JWT_SECRET: ${JWT_SECRET}
      CLIENT_URL: ${CLIENT_URL}
    depends_on:
      - mongodb
    ports:
      - "5000:5000"
    networks:
      - dm_network
    volumes:
      - ./uploads:/app/uploads

  frontend:
    build: ./frontend
    restart: unless-stopped
    ports:
      - "80:80"
    environment:
      REACT_APP_API_URL: ${API_URL}
    depends_on:
      - backend
    networks:
      - dm_network

  redis:
    image: redis:7-alpine
    restart: unless-stopped
    command: redis-server --requirepass ${REDIS_PASSWORD}
    volumes:
      - redis_data:/data
    networks:
      - dm_network

volumes:
  mongo_data:
  redis_data:

networks:
  dm_network:
    driver: bridge
```

### 2. Production Environment Setup

```bash
#!/bin/bash
# deploy.sh

set -e

echo "🚀 Starting deployment..."

# Pull latest code
git pull origin main

# Build and deploy with Docker Compose
docker-compose down
docker-compose build --no-cache
docker-compose up -d

# Wait for services to be healthy
echo "⏳ Waiting for services to be healthy..."
sleep 30

# Run database migrations if needed
docker-compose exec backend npm run migrate

# Check if services are running
if docker-compose ps | grep -q "Up"; then
    echo "✅ Deployment successful!"
else
    echo "❌ Deployment failed!"
    docker-compose logs
    exit 1
fi

echo "🎉 All services are running!"
```

```nginx
# nginx.conf
events {
    worker_connections 1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;
    
    # Rate limiting
    limit_req_zone $binary_remote_addr zone=api:10m rate=10r/s;
    limit_req_zone $binary_remote_addr zone=login:10m rate=1r/s;
    
    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml text/javascript;

    server {
        listen 80;
        server_name localhost;
        
        # Security headers
        add_header X-Frame-Options DENY;
        add_header X-Content-Type-Options nosniff;
        add_header X-XSS-Protection "1; mode=block";
        add_header Referrer-Policy strict-origin-when-cross-origin;
        
        # Static files
        location / {
            root /usr/share/nginx/html;
            try_files $uri $uri/ /index.html;
        }
        
        # API proxy with rate limiting
        location /api/ {
            limit_req zone=api burst=20 nodelay;
            proxy_pass http://backend:5000;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection 'upgrade';
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_cache_bypass $http_upgrade;
        }
        
        # Stricter rate limiting for auth endpoints
        location /api/auth/ {
            limit_req zone=login burst=5 nodelay;
            proxy_pass http://backend:5000;
            proxy_http_version 1.1;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
        
        # WebSocket proxy
        location /socket.io/ {
            proxy_pass http://backend:5000;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}
```

---

## Testing Strategy

### 1. Backend Unit Tests

```javascript
// tests/auth.test.js
const request = require('supertest');
const mongoose = require('mongoose');
const app = require('../server');
const User = require('../models/User');

describe('Authentication', () => {
  beforeAll(async () => {
    // Connect to test database
    await mongoose.connect(process.env.MONGODB_TEST_URI);
  });

  beforeEach(async () => {
    // Clean up database before each test
    await User.deleteMany({});
  });

  afterAll(async () => {
    await mongoose.connection.close();
  });

  describe('POST /api/auth/register', () => {
    const validUser = {
      username: 'testuser',
      email: 'test@example.com',
      password: 'StrongPass123!',
      displayName: 'Test User'
    };

    it('should register a new user with valid data', async () => {
      const response = await request(app)
        .post('/api/auth/register')
        .send(validUser)
        .expect(201);

      expect(response.body).toHaveProperty('token');
      expect(response.body.user.email).toBe(validUser.email);
      expect(response.body.user).not.toHaveProperty('password');
    });

    it('should reject registration with weak password', async () => {
      const weakPasswordUser = { ...validUser, password: '123' };
      
      await request(app)
        .post('/api/auth/register')
        .send(weakPasswordUser)
        .expect(400);
    });

    it('should reject duplicate email registration', async () => {
      // Register first user
      await request(app)
        .post('/api/auth/register')
        .send(validUser);

      // Try to register with same email
      const duplicateUser = { ...validUser, username: 'different' };
      
      await request(app)
        .post('/api/auth/register')
        .send(duplicateUser)
        .expect(400);
    });
  });

  describe('POST /api/auth/login', () => {
    beforeEach(async () => {
      // Create test user
      await request(app)
        .post('/api/auth/register')
        .send({
          username: 'testuser',
          email: 'test@example.com',
          password: 'StrongPass123!',
          displayName: 'Test User'
        });
    });

    it('should login with valid credentials', async () => {
      const response = await request(app)
        .post('/api/auth/login')
        .send({
          login: 'test@example.com',
          password: 'StrongPass123!'
        })
        .expect(200);

      expect(response.body).toHaveProperty('token');
      expect(response.body.user.email).toBe('test@example.com');
    });

    it('should reject invalid credentials', async () => {
      await request(app)
        .post('/api/auth/login')
        .send({
          login: 'test@example.com',
          password: 'wrongpassword'
        })
        .expect(400);
    });
  });
});
```

### 2. Frontend Component Tests

```typescript
// src/components/__tests__/MessageBubble.test.tsx
import React from 'react';
import { render, screen } from '@testing-library/react';
import { MessageBubble } from '../Chat/MessageBubble';
import { AuthProvider } from '../../contexts/AuthContext';
import { Message } from '../../services/api';

// Mock message data
const mockMessage: Message = {
  _id: '1',
  content: 'Hello, world!',
  type: 'text',
  conversation: 'conv1',
  sender: {
    _id: 'user1',
    username: 'testuser',
    email: 'test@example.com',
    displayName: 'Test User',
    isOnline: true,
    lastSeen: new Date()
  },
  readBy: [],
  createdAt: new Date(),
};

const mockCurrentUser = {
  _id: 'user2',
  username: 'currentuser',
  email: 'current@example.com',
  displayName: 'Current User',
  isOnline: true,
  lastSeen: new Date()
};

// Mock auth context
jest.mock('../../contexts/AuthContext', () => ({
  useAuth: () => ({
    user: mockCurrentUser,
    token: 'mock-token',
    isLoading: false,
    error: null,
    login: jest.fn(),
    register: jest.fn(),
    logout: jest.fn(),
    updateUser: jest.fn(),
  }),
}));

describe('MessageBubble', () => {
  it('renders message content correctly', () => {
    render(<MessageBubble message={mockMessage} />);
    
    expect(screen.getByText('Hello, world!')).toBeInTheDocument();
    expect(screen.getByText('Test User')).toBeInTheDocument();
  });

  it('applies correct styling for own messages', () => {
    const ownMessage = { ...mockMessage, sender: { ...mockCurrentUser } };
    
    render(<MessageBubble message={ownMessage} />);
    
    // Own messages should have different styling
    const messageContainer = screen.getByText('Hello, world!').closest('div');
    expect(messageContainer).toHaveStyle('background-color: primary.main');
  });

  it('shows reply context when message is a reply', () => {
    const replyMessage = {
      ...mockMessage,
      replyTo: {
        ...mockMessage,
        _id: '2',
        content: 'Original message',
      }
    };

    render(<MessageBubble message={replyMessage} />);
    
    expect(screen.getByText('Replying to Test User')).toBeInTheDocument();
    expect(screen.getByText('Original message')).toBeInTheDocument();
  });
});
```

### 3. Integration Tests

```javascript
// tests/integration/messaging.test.js
const request = require('supertest');
const app = require('../../server');
const User = require('../../models/User');
const Conversation = require('../../models/Conversation');

describe('Messaging Integration', () => {
  let user1Token, user2Token, user1Id, user2Id, conversationId;

  beforeEach(async () => {
    // Create test users
    const user1Response = await request(app)
      .post('/api/auth/register')
      .send({
        username: 'user1',
        email: 'user1@example.com',
        password: 'StrongPass123!',
        displayName: 'User One'
      });

    const user2Response = await request(app)
      .post('/api/auth/register')
      .send({
        username: 'user2',
        email: 'user2@example.com',
        password: 'StrongPass123!',
        displayName: 'User Two'
      });

    user1Token = user1Response.body.token;
    user2Token = user2Response.body.token;
    user1Id = user1Response.body.user._id;
    user2Id = user2Response.body.user._id;

    // Create conversation
    const conversationResponse = await request(app)
      .post('/api/conversations')
      .set('Authorization', `Bearer ${user1Token}`)
      .send({
        type: 'direct',
        participants: [user2Id]
      });

    conversationId = conversationResponse.body._id;
  });

  it('should complete full messaging flow', async () => {
    // User 1 sends a message
    const messageResponse = await request(app)
      .post('/api/messages')
      .set('Authorization', `Bearer ${user1Token}`)
      .send({
        conversationId,
        content: 'Hello from user 1!'
      })
      .expect(201);

    const messageId = messageResponse.body.data._id;

    // User 2 retrieves messages
    const messagesResponse = await request(app)
      .get(`/api/messages/conversation/${conversationId}`)
      .set('Authorization', `Bearer ${user2Token}`)
      .expect(200);

    expect(messagesResponse.body.messages).toHaveLength(1);
    expect(messagesResponse.body.messages[0].content).toBe('Hello from user 1!');

    // User 2 marks message as read
    await request(app)
      .put(`/api/messages/${messageId}/read`)
      .set('Authorization', `Bearer ${user2Token}`)
      .expect(200);

    // User 2 replies
    await request(app)
      .post('/api/messages')
      .set('Authorization', `Bearer ${user2Token}`)
      .send({
        conversationId,
        content: 'Hello back!',
        replyTo: messageId
      })
      .expect(201);
  });
});
```

This comprehensive tutorial covers all aspects of building a modern, secure Direct Message system with real-time capabilities. The code examples are production-ready and include proper security measures, error handling, and testing strategies.