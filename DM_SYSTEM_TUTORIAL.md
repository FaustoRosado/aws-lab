# Direct Message System Tutorial: Complete Implementation Guide

## Table of Contents
1. [System Architecture Overview](#system-architecture-overview)
2. [Database Design & Models](#database-design--models)
3. [Backend Implementation](#backend-implementation)
4. [Frontend Implementation](#frontend-implementation)
5. [Real-Time Messaging](#real-time-messaging)
6. [Security & Authentication](#security--authentication)
7. [Testing & Deployment](#testing--deployment)

---

## System Architecture Overview

### What We're Building
A complete Direct Message system that allows users to:
- Send and receive private messages in real-time
- Create group chats
- See online/offline status
- Search message history
- Share files and media

### Tech Stack
- **Backend**: Node.js with Express.js
- **Database**: MongoDB with Mongoose ODM
- **Real-time**: Socket.IO for WebSocket connections
- **Frontend**: React with TypeScript
- **Authentication**: JWT tokens
- **File Storage**: AWS S3 (optional) or local storage

### High-Level Architecture

```
┌─────────────────┐    HTTP/WebSocket    ┌─────────────────┐
│   React Client  │ ◄─────────────────► │   Node.js API   │
│                 │                     │                 │
│ - Chat UI       │                     │ - REST Routes   │
│ - Real-time     │                     │ - Socket.IO     │
│ - State Mgmt    │                     │ - Auth Middleware│
└─────────────────┘                     └─────────────────┘
                                                  │
                                                  ▼
                                        ┌─────────────────┐
                                        │    MongoDB      │
                                        │                 │
                                        │ - Users         │
                                        │ - Conversations │
                                        │ - Messages      │
                                        └─────────────────┘
```

---

## Database Design & Models

### 1. User Model
Stores user information and authentication data.

**Key Concepts:**
- Each user has a unique identifier
- Passwords are hashed for security
- Track online status and last seen
- Store profile information

```javascript
// models/User.js
const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const userSchema = new mongoose.Schema({
  // Basic user information
  username: {
    type: String,
    required: true,
    unique: true,
    trim: true,
    minlength: 3,
    maxlength: 30
  },
  email: {
    type: String,
    required: true,
    unique: true,
    lowercase: true,
    trim: true
  },
  password: {
    type: String,
    required: true,
    minlength: 6
  },
  
  // Profile information
  displayName: {
    type: String,
    required: true,
    trim: true
  },
  avatar: {
    type: String,
    default: null // URL to avatar image
  },
  bio: {
    type: String,
    maxlength: 500,
    default: ''
  },
  
  // Status and activity
  isOnline: {
    type: Boolean,
    default: false
  },
  lastSeen: {
    type: Date,
    default: Date.now
  },
  
  // Metadata
  createdAt: {
    type: Date,
    default: Date.now
  },
  updatedAt: {
    type: Date,
    default: Date.now
  }
});

// Hash password before saving
userSchema.pre('save', async function(next) {
  // Only hash password if it's been modified
  if (!this.isModified('password')) return next();
  
  // Hash password with salt rounds of 12
  this.password = await bcrypt.hash(this.password, 12);
  next();
});

// Instance method to check password
userSchema.methods.comparePassword = async function(candidatePassword) {
  return bcrypt.compare(candidatePassword, this.password);
};

// Update the updatedAt field before saving
userSchema.pre('save', function(next) {
  this.updatedAt = Date.now();
  next();
});

module.exports = mongoose.model('User', userSchema);
```

**How it works:**
- `pre('save')` middleware automatically hashes passwords before storing
- `comparePassword` method safely compares entered passwords with stored hashes
- Tracks user activity with `isOnline` and `lastSeen` fields

### 2. Conversation Model
Represents a chat conversation (1-on-1 or group).

**Key Concepts:**
- A conversation can be direct (2 participants) or group (3+ participants)
- Track participants and their roles
- Store conversation metadata

```javascript
// models/Conversation.js
const mongoose = require('mongoose');

const conversationSchema = new mongoose.Schema({
  // Conversation type and basic info
  type: {
    type: String,
    enum: ['direct', 'group'],
    required: true
  },
  name: {
    type: String,
    // Required for group chats, optional for direct messages
    required: function() {
      return this.type === 'group';
    },
    trim: true,
    maxlength: 100
  },
  description: {
    type: String,
    maxlength: 500,
    default: ''
  },
  
  // Participants with roles
  participants: [{
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true
    },
    role: {
      type: String,
      enum: ['admin', 'member'],
      default: 'member'
    },
    joinedAt: {
      type: Date,
      default: Date.now
    },
    // Track read status per participant
    lastReadMessage: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Message',
      default: null
    }
  }],
  
  // Conversation settings
  settings: {
    // Who can add new participants
    canInvite: {
      type: String,
      enum: ['admin', 'all'],
      default: 'admin'
    },
    // Message deletion policy
    messageRetention: {
      type: Number,
      default: null // null means keep forever
    }
  },
  
  // Latest message for quick access
  lastMessage: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Message',
    default: null
  },
  lastActivity: {
    type: Date,
    default: Date.now
  },
  
  // Metadata
  createdAt: {
    type: Date,
    default: Date.now
  },
  createdBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  }
});

// Create compound index for efficient participant queries
conversationSchema.index({ 'participants.user': 1 });
conversationSchema.index({ lastActivity: -1 });

// Static method to find conversations for a user
conversationSchema.statics.findByUser = function(userId) {
  return this.find({
    'participants.user': userId
  })
  .populate('participants.user', 'username displayName avatar isOnline')
  .populate('lastMessage')
  .sort({ lastActivity: -1 });
};

module.exports = mongoose.model('Conversation', conversationSchema);
```

**How it works:**
- `participants` array stores all users in the conversation with their roles
- `lastReadMessage` tracks read status per user for unread count calculation
- Compound indexes improve query performance for user conversations

### 3. Message Model
Stores individual messages within conversations.

**Key Concepts:**
- Messages belong to a conversation and are sent by a user
- Support different message types (text, image, file)
- Track message status (sent, delivered, read)

```javascript
// models/Message.js
const mongoose = require('mongoose');

const messageSchema = new mongoose.Schema({
  // Message content and type
  content: {
    type: String,
    required: function() {
      return this.type === 'text';
    },
    maxlength: 4000
  },
  type: {
    type: String,
    enum: ['text', 'image', 'file', 'system'],
    default: 'text'
  },
  
  // File/media information (for non-text messages)
  media: {
    filename: String,
    originalName: String,
    mimetype: String,
    size: Number,
    url: String, // S3 URL or local path
  },
  
  // Message relationships
  conversation: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Conversation',
    required: true
  },
  sender: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  
  // Reply functionality
  replyTo: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Message',
    default: null
  },
  
  // Message status and metadata
  status: {
    type: String,
    enum: ['sent', 'delivered', 'failed'],
    default: 'sent'
  },
  
  // Read status per participant
  readBy: [{
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    },
    readAt: {
      type: Date,
      default: Date.now
    }
  }],
  
  // Edit and deletion tracking
  editedAt: {
    type: Date,
    default: null
  },
  isDeleted: {
    type: Boolean,
    default: false
  },
  deletedAt: {
    type: Date,
    default: null
  },
  
  // Metadata
  createdAt: {
    type: Date,
    default: Date.now
  }
});

// Indexes for efficient querying
messageSchema.index({ conversation: 1, createdAt: -1 });
messageSchema.index({ sender: 1 });

// Static method to find messages in a conversation with pagination
messageSchema.statics.findByConversation = function(conversationId, page = 1, limit = 50) {
  const skip = (page - 1) * limit;
  
  return this.find({
    conversation: conversationId,
    isDeleted: false
  })
  .populate('sender', 'username displayName avatar')
  .populate('replyTo')
  .sort({ createdAt: -1 })
  .skip(skip)
  .limit(limit);
};

// Instance method to mark as read by user
messageSchema.methods.markAsRead = function(userId) {
  // Check if user already read this message
  const existingRead = this.readBy.find(read => 
    read.user.toString() === userId.toString()
  );
  
  if (!existingRead) {
    this.readBy.push({
      user: userId,
      readAt: new Date()
    });
  }
  
  return this.save();
};

module.exports = mongoose.model('Message', messageSchema);
```

**How it works:**
- `readBy` array tracks which users have read the message
- `replyTo` reference enables threaded conversations
- Compound indexes optimize conversation message queries
- `findByConversation` provides pagination for large chat histories

---

## Backend Implementation

Now let's build the Express.js server with all the necessary routes and middleware.

### 1. Server Setup & Configuration

```javascript
// server.js
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const socketIo = require('socket.io');
const http = require('http');
require('dotenv').config();

// Import routes
const authRoutes = require('./routes/auth');
const userRoutes = require('./routes/users');
const conversationRoutes = require('./routes/conversations');
const messageRoutes = require('./routes/messages');

// Import middleware
const authMiddleware = require('./middleware/auth');
const errorHandler = require('./middleware/errorHandler');

// Import socket handlers
const socketAuth = require('./sockets/auth');
const messageHandlers = require('./sockets/messageHandlers');

const app = express();
const server = http.createServer(app);

// Configure Socket.IO with CORS
const io = socketIo(server, {
  cors: {
    origin: process.env.CLIENT_URL || "http://localhost:3000",
    methods: ["GET", "POST"],
    credentials: true
  }
});

// Rate limiting to prevent spam
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // Limit each IP to 100 requests per windowMs
  message: 'Too many requests from this IP, please try again later.'
});

// Middleware
app.use(helmet()); // Security headers
app.use(cors({
  origin: process.env.CLIENT_URL || "http://localhost:3000",
  credentials: true
}));
app.use(limiter);
app.use(express.json({ limit: '10mb' })); // Increased for file uploads
app.use(express.urlencoded({ extended: true }));

// Connect to MongoDB
mongoose.connect(process.env.MONGODB_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
.then(() => console.log('Connected to MongoDB'))
.catch(err => console.error('MongoDB connection error:', err));

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/users', authMiddleware, userRoutes);
app.use('/api/conversations', authMiddleware, conversationRoutes);
app.use('/api/messages', authMiddleware, messageRoutes);

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.json({ 
    status: 'OK', 
    timestamp: new Date().toISOString(),
    uptime: process.uptime()
  });
});

// Socket.IO authentication and handlers
io.use(socketAuth); // Authenticate socket connections

// Socket event handlers
io.on('connection', (socket) => {
  console.log(`User ${socket.user.username} connected`);
  
  // Join user to their personal room for notifications
  socket.join(`user:${socket.user._id}`);
  
  // Update user online status
  socket.user.updateOne({ isOnline: true });
  
  // Handle messaging events
  messageHandlers(io, socket);
  
  // Handle disconnection
  socket.on('disconnect', () => {
    console.log(`User ${socket.user.username} disconnected`);
    // Update offline status after a delay (user might reconnect)
    setTimeout(() => {
      socket.user.updateOne({ 
        isOnline: false, 
        lastSeen: new Date() 
      });
    }, 30000); // 30 second delay
  });
});

// Global error handler
app.use(errorHandler);

const PORT = process.env.PORT || 5000;
server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
```

**How it works:**
- Express server is wrapped with Socket.IO for real-time functionality
- Rate limiting prevents API abuse
- MongoDB connection with error handling
- Socket authentication ensures only logged-in users can connect
- User online status is tracked via socket connections

### 2. Authentication Routes

```javascript
// routes/auth.js
const express = require('express');
const jwt = require('jsonwebtoken');
const { body, validationResult } = require('express-validator');
const User = require('../models/User');
const authMiddleware = require('../middleware/auth');

const router = express.Router();

// Register new user
router.post('/register', [
  body('username')
    .isLength({ min: 3, max: 30 })
    .withMessage('Username must be 3-30 characters')
    .matches(/^[a-zA-Z0-9_]+$/)
    .withMessage('Username can only contain letters, numbers, and underscores'),
  body('email')
    .isEmail()
    .normalizeEmail()
    .withMessage('Please provide a valid email'),
  body('password')
    .isLength({ min: 6 })
    .withMessage('Password must be at least 6 characters'),
  body('displayName')
    .isLength({ min: 1, max: 50 })
    .withMessage('Display name is required and max 50 characters')
], async (req, res) => {
  try {
    // Check for validation errors
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ 
        message: 'Validation failed', 
        errors: errors.array() 
      });
    }

    const { username, email, password, displayName } = req.body;

    // Check if user already exists
    const existingUser = await User.findOne({
      $or: [{ email }, { username }]
    });

    if (existingUser) {
      return res.status(400).json({ 
        message: existingUser.email === email 
          ? 'Email already registered' 
          : 'Username already taken' 
      });
    }

    // Create new user
    const user = new User({
      username,
      email,
      password, // Will be hashed by the pre-save middleware
      displayName
    });

    await user.save();

    // Generate JWT token
    const token = jwt.sign(
      { userId: user._id },
      process.env.JWT_SECRET,
      { expiresIn: '7d' }
    );

    // Return user data (excluding password)
    const userData = {
      _id: user._id,
      username: user.username,
      email: user.email,
      displayName: user.displayName,
      avatar: user.avatar,
      createdAt: user.createdAt
    };

    res.status(201).json({
      message: 'User created successfully',
      token,
      user: userData
    });

  } catch (error) {
    console.error('Registration error:', error);
    res.status(500).json({ message: 'Server error during registration' });
  }
});

// Login user
router.post('/login', [
  body('login')
    .notEmpty()
    .withMessage('Username or email is required'),
  body('password')
    .notEmpty()
    .withMessage('Password is required')
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ 
        message: 'Validation failed', 
        errors: errors.array() 
      });
    }

    const { login, password } = req.body;

    // Find user by username or email
    const user = await User.findOne({
      $or: [
        { username: login },
        { email: login }
      ]
    });

    if (!user) {
      return res.status(400).json({ message: 'Invalid credentials' });
    }

    // Check password
    const isMatch = await user.comparePassword(password);
    if (!isMatch) {
      return res.status(400).json({ message: 'Invalid credentials' });
    }

    // Update last seen
    user.lastSeen = new Date();
    await user.save();

    // Generate JWT token
    const token = jwt.sign(
      { userId: user._id },
      process.env.JWT_SECRET,
      { expiresIn: '7d' }
    );

    // Return user data (excluding password)
    const userData = {
      _id: user._id,
      username: user.username,
      email: user.email,
      displayName: user.displayName,
      avatar: user.avatar,
      isOnline: user.isOnline,
      lastSeen: user.lastSeen
    };

    res.json({
      message: 'Login successful',
      token,
      user: userData
    });

  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ message: 'Server error during login' });
  }
});

// Get current user profile
router.get('/me', authMiddleware, async (req, res) => {
  try {
    const user = await User.findById(req.user.userId)
      .select('-password'); // Exclude password

    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    res.json({ user });
  } catch (error) {
    console.error('Get profile error:', error);
    res.status(500).json({ message: 'Server error' });
  }
});

// Logout user (client-side mainly, but we can blacklist tokens)
router.post('/logout', authMiddleware, async (req, res) => {
  try {
    // Update user status
    await User.findByIdAndUpdate(req.user.userId, {
      isOnline: false,
      lastSeen: new Date()
    });

    // In a production app, you might want to maintain a token blacklist
    // For now, we rely on client-side token removal
    
    res.json({ message: 'Logged out successfully' });
  } catch (error) {
    console.error('Logout error:', error);
    res.status(500).json({ message: 'Server error during logout' });
  }
});

module.exports = router;
```

**How it works:**
- Input validation ensures data integrity
- Passwords are never returned in responses
- JWT tokens expire after 7 days for security
- Login accepts either username or email
- Online status is updated during login/logout

### 3. Message Routes

```javascript
// routes/messages.js
const express = require('express');
const { body, query, validationResult } = require('express-validator');
const Message = require('../models/Message');
const Conversation = require('../models/Conversation');
const User = require('../models/User');

const router = express.Router();

// Get messages for a conversation with pagination
router.get('/conversation/:conversationId', [
  query('page')
    .optional()
    .isInt({ min: 1 })
    .withMessage('Page must be a positive integer'),
  query('limit')
    .optional()
    .isInt({ min: 1, max: 100 })
    .withMessage('Limit must be between 1 and 100')
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { conversationId } = req.params;
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 50;

    // Verify user is participant in conversation
    const conversation = await Conversation.findOne({
      _id: conversationId,
      'participants.user': req.user.userId
    });

    if (!conversation) {
      return res.status(404).json({ 
        message: 'Conversation not found or access denied' 
      });
    }

    // Get messages with pagination
    const messages = await Message.findByConversation(
      conversationId, 
      page, 
      limit
    );

    // Get total count for pagination
    const totalMessages = await Message.countDocuments({
      conversation: conversationId,
      isDeleted: false
    });

    const totalPages = Math.ceil(totalMessages / limit);

    res.json({
      messages,
      pagination: {
        currentPage: page,
        totalPages,
        totalMessages,
        hasMore: page < totalPages
      }
    });

  } catch (error) {
    console.error('Get messages error:', error);
    res.status(500).json({ message: 'Server error' });
  }
});

// Send a new message
router.post('/', [
  body('conversationId')
    .notEmpty()
    .isMongoId()
    .withMessage('Valid conversation ID is required'),
  body('content')
    .optional()
    .isString()
    .isLength({ max: 4000 })
    .withMessage('Message content max 4000 characters'),
  body('type')
    .optional()
    .isIn(['text', 'image', 'file'])
    .withMessage('Invalid message type'),
  body('replyTo')
    .optional()
    .isMongoId()
    .withMessage('Reply to must be valid message ID')
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { conversationId, content, type = 'text', replyTo } = req.body;

    // Verify user is participant in conversation
    const conversation = await Conversation.findOne({
      _id: conversationId,
      'participants.user': req.user.userId
    });

    if (!conversation) {
      return res.status(404).json({ 
        message: 'Conversation not found or access denied' 
      });
    }

    // Validate reply message if specified
    if (replyTo) {
      const replyMessage = await Message.findOne({
        _id: replyTo,
        conversation: conversationId
      });

      if (!replyMessage) {
        return res.status(400).json({ 
          message: 'Reply message not found' 
        });
      }
    }

    // Create new message
    const message = new Message({
      content,
      type,
      conversation: conversationId,
      sender: req.user.userId,
      replyTo: replyTo || null
    });

    await message.save();

    // Populate sender information
    await message.populate('sender', 'username displayName avatar');
    if (replyTo) {
      await message.populate('replyTo');
    }

    // Update conversation's last message and activity
    conversation.lastMessage = message._id;
    conversation.lastActivity = new Date();
    await conversation.save();

    // Get the populated conversation for socket broadcast
    const populatedConversation = await Conversation.findById(conversationId)
      .populate('participants.user', 'username displayName avatar isOnline');

    // Emit to all participants via Socket.IO
    // This will be handled by the socket server
    req.io?.to(`conversation:${conversationId}`).emit('new_message', {
      message,
      conversation: populatedConversation
    });

    res.status(201).json({
      message: 'Message sent successfully',
      data: message
    });

  } catch (error) {
    console.error('Send message error:', error);
    res.status(500).json({ message: 'Server error' });
  }
});

// Mark message as read
router.put('/:messageId/read', async (req, res) => {
  try {
    const { messageId } = req.params;

    // Find message and verify access
    const message = await Message.findById(messageId)
      .populate('conversation');

    if (!message) {
      return res.status(404).json({ message: 'Message not found' });
    }

    // Check if user is participant in conversation
    const conversation = await Conversation.findOne({
      _id: message.conversation._id,
      'participants.user': req.user.userId
    });

    if (!conversation) {
      return res.status(403).json({ 
        message: 'Access denied to this conversation' 
      });
    }

    // Mark message as read
    await message.markAsRead(req.user.userId);

    // Update user's last read message in conversation
    await Conversation.updateOne(
      { 
        _id: message.conversation._id,
        'participants.user': req.user.userId 
      },
      { 
        $set: { 
          'participants.$.lastReadMessage': messageId 
        } 
      }
    );

    res.json({ message: 'Message marked as read' });

  } catch (error) {
    console.error('Mark read error:', error);
    res.status(500).json({ message: 'Server error' });
  }
});

// Search messages in a conversation
router.get('/search', [
  query('conversationId')
    .notEmpty()
    .isMongoId()
    .withMessage('Valid conversation ID is required'),
  query('q')
    .notEmpty()
    .isLength({ min: 1 })
    .withMessage('Search query is required')
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { conversationId, q } = req.query;

    // Verify user access to conversation
    const conversation = await Conversation.findOne({
      _id: conversationId,
      'participants.user': req.user.userId
    });

    if (!conversation) {
      return res.status(404).json({ 
        message: 'Conversation not found or access denied' 
      });
    }

    // Search messages using text index
    const messages = await Message.find({
      conversation: conversationId,
      isDeleted: false,
      $text: { $search: q }
    })
    .populate('sender', 'username displayName avatar')
    .sort({ createdAt: -1 })
    .limit(50);

    res.json({
      messages,
      query: q,
      count: messages.length
    });

  } catch (error) {
    console.error('Search messages error:', error);
    res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router;
```

**How it works:**
- Pagination prevents loading too many messages at once
- Access control ensures users can only see their conversations
- Message validation prevents abuse and data corruption
- Search functionality uses MongoDB text indexes
- Real-time updates via Socket.IO integration

Let me continue with the frontend implementation and real-time messaging components.