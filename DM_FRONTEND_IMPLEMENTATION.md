# DM System Tutorial: Frontend Implementation

## Table of Contents
1. [Project Setup](#project-setup)
2. [API Client & Authentication](#api-client--authentication)
3. [Chat Interface Components](#chat-interface-components)
4. [Real-Time Messaging](#real-time-messaging)
5. [Main App Component](#main-app-component)

---

## Project Setup

```bash
# Create React app with TypeScript
npx create-react-app dm-frontend --template typescript
cd dm-frontend

# Install additional dependencies
npm install socket.io-client axios react-router-dom @types/react-router-dom
npm install @mui/material @emotion/react @emotion/styled
npm install @mui/icons-material date-fns
npm install react-query @tanstack/react-query

# Install dev dependencies
npm install -D @types/socket.io-client
```

## Real-Time Messaging with Socket.IO

### 1. Socket Context

```typescript
// src/contexts/SocketContext.tsx
import React, { createContext, useContext, useEffect, useRef, useState } from 'react';
import { io, Socket } from 'socket.io-client';
import { useAuth } from './AuthContext';
import { Message, Conversation, User } from '../services/api';

interface SocketContextType {
  socket: Socket | null;
  isConnected: boolean;
  onlineUsers: Set<string>;
  sendMessage: (data: {
    conversationId: string;
    content: string;
    type?: string;
    replyTo?: string;
  }) => void;
  joinConversation: (conversationId: string) => void;
  leaveConversation: (conversationId: string) => void;
  // Event callbacks
  onMessageReceived: (callback: (message: Message) => void) => void;
  onUserOnlineStatusChanged: (callback: (data: { userId: string; isOnline: boolean }) => void) => void;
  onTypingStarted: (callback: (data: { userId: string; conversationId: string; username: string }) => void) => void;
  onTypingStopped: (callback: (data: { userId: string; conversationId: string }) => void) => void;
}

const SocketContext = createContext<SocketContextType | null>(null);

export const SocketProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const { user, token } = useAuth();
  const [socket, setSocket] = useState<Socket | null>(null);
  const [isConnected, setIsConnected] = useState(false);
  const [onlineUsers, setOnlineUsers] = useState(new Set<string>());
  
  // Event callback refs
  const messageCallbacks = useRef<Set<(message: Message) => void>>(new Set());
  const userStatusCallbacks = useRef<Set<(data: { userId: string; isOnline: boolean }) => void>>(new Set());
  const typingStartedCallbacks = useRef<Set<(data: { userId: string; conversationId: string; username: string }) => void>>(new Set());
  const typingStoppedCallbacks = useRef<Set<(data: { userId: string; conversationId: string }) => void>>(new Set());

  useEffect(() => {
    if (user && token) {
      // Create socket connection with authentication
      const newSocket = io(process.env.REACT_APP_API_URL || 'http://localhost:5000', {
        auth: {
          token,
        },
        transports: ['websocket', 'polling'],
      });

      // Connection event handlers
      newSocket.on('connect', () => {
        console.log('Connected to server');
        setIsConnected(true);
      });

      newSocket.on('disconnect', () => {
        console.log('Disconnected from server');
        setIsConnected(false);
      });

      newSocket.on('connect_error', (error) => {
        console.error('Connection error:', error);
        setIsConnected(false);
      });

      // Message events
      newSocket.on('new_message', (data: { message: Message; conversation: Conversation }) => {
        messageCallbacks.current.forEach(callback => callback(data.message));
      });

      // User status events
      newSocket.on('user_online', (data: { userId: string; username: string }) => {
        setOnlineUsers(prev => new Set([...prev, data.userId]));
        userStatusCallbacks.current.forEach(callback => 
          callback({ userId: data.userId, isOnline: true })
        );
      });

      newSocket.on('user_offline', (data: { userId: string; username: string }) => {
        setOnlineUsers(prev => {
          const updated = new Set(prev);
          updated.delete(data.userId);
          return updated;
        });
        userStatusCallbacks.current.forEach(callback => 
          callback({ userId: data.userId, isOnline: false })
        );
      });

      // Typing events
      newSocket.on('typing_started', (data: { userId: string; conversationId: string; username: string }) => {
        typingStartedCallbacks.current.forEach(callback => callback(data));
      });

      newSocket.on('typing_stopped', (data: { userId: string; conversationId: string }) => {
        typingStoppedCallbacks.current.forEach(callback => callback(data));
      });

      // Online users list
      newSocket.on('online_users', (users: string[]) => {
        setOnlineUsers(new Set(users));
      });

      setSocket(newSocket);

      return () => {
        newSocket.close();
      };
    } else {
      setSocket(null);
      setIsConnected(false);
      setOnlineUsers(new Set());
    }
  }, [user, token]);

  const sendMessage = (data: {
    conversationId: string;
    content: string;
    type?: string;
    replyTo?: string;
  }) => {
    if (socket) {
      socket.emit('send_message', data);
    }
  };

  const joinConversation = (conversationId: string) => {
    if (socket) {
      socket.emit('join_conversation', { conversationId });
    }
  };

  const leaveConversation = (conversationId: string) => {
    if (socket) {
      socket.emit('leave_conversation', { conversationId });
    }
  };

  // Event subscription methods
  const onMessageReceived = (callback: (message: Message) => void) => {
    messageCallbacks.current.add(callback);
    
    // Return unsubscribe function
    return () => {
      messageCallbacks.current.delete(callback);
    };
  };

  const onUserOnlineStatusChanged = (callback: (data: { userId: string; isOnline: boolean }) => void) => {
    userStatusCallbacks.current.add(callback);
    
    return () => {
      userStatusCallbacks.current.delete(callback);
    };
  };

  const onTypingStarted = (callback: (data: { userId: string; conversationId: string; username: string }) => void) => {
    typingStartedCallbacks.current.add(callback);
    
    return () => {
      typingStartedCallbacks.current.delete(callback);
    };
  };

  const onTypingStopped = (callback: (data: { userId: string; conversationId: string }) => void) => {
    typingStoppedCallbacks.current.add(callback);
    
    return () => {
      typingStoppedCallbacks.current.delete(callback);
    };
  };

  return (
    <SocketContext.Provider
      value={{
        socket,
        isConnected,
        onlineUsers,
        sendMessage,
        joinConversation,
        leaveConversation,
        onMessageReceived,
        onUserOnlineStatusChanged,
        onTypingStarted,
        onTypingStopped,
      }}
    >
      {children}
    </SocketContext.Provider>
  );
};

export const useSocket = () => {
  const context = useContext(SocketContext);
  if (!context) {
    throw new Error('useSocket must be used within SocketProvider');
  }
  return context;
};
```

### 2. Socket Event Handlers (Backend)

```javascript
// sockets/messageHandlers.js
const Message = require('../models/Message');
const Conversation = require('../models/Conversation');

module.exports = (io, socket) => {
  // Join a conversation room
  socket.on('join_conversation', async (data) => {
    try {
      const { conversationId } = data;
      
      // Verify user is participant
      const conversation = await Conversation.findOne({
        _id: conversationId,
        'participants.user': socket.user._id
      });
      
      if (conversation) {
        socket.join(`conversation:${conversationId}`);
        console.log(`User ${socket.user.username} joined conversation ${conversationId}`);
      }
    } catch (error) {
      console.error('Join conversation error:', error);
    }
  });

  // Leave a conversation room
  socket.on('leave_conversation', (data) => {
    const { conversationId } = data;
    socket.leave(`conversation:${conversationId}`);
    console.log(`User ${socket.user.username} left conversation ${conversationId}`);
  });

  // Send message via socket
  socket.on('send_message', async (data) => {
    try {
      const { conversationId, content, type = 'text', replyTo } = data;

      // Verify user is participant
      const conversation = await Conversation.findOne({
        _id: conversationId,
        'participants.user': socket.user._id
      });

      if (!conversation) {
        socket.emit('error', { message: 'Conversation not found or access denied' });
        return;
      }

      // Create new message
      const message = new Message({
        content,
        type,
        conversation: conversationId,
        sender: socket.user._id,
        replyTo: replyTo || null
      });

      await message.save();
      
      // Populate sender info
      await message.populate('sender', 'username displayName avatar');
      if (replyTo) {
        await message.populate('replyTo');
      }

      // Update conversation
      conversation.lastMessage = message._id;
      conversation.lastActivity = new Date();
      await conversation.save();

      // Emit to all participants
      io.to(`conversation:${conversationId}`).emit('new_message', {
        message,
        conversationId
      });

      // Send push notifications to offline users (implement separately)
      const offlineParticipants = conversation.participants.filter(
        p => p.user.toString() !== socket.user._id.toString() && !p.user.isOnline
      );

      // TODO: Send push notifications to offline users

    } catch (error) {
      console.error('Send message error:', error);
      socket.emit('error', { message: 'Failed to send message' });
    }
  });

  // Typing indicators
  socket.on('typing_start', (data) => {
    const { conversationId } = data;
    socket.to(`conversation:${conversationId}`).emit('typing_started', {
      userId: socket.user._id,
      conversationId,
      username: socket.user.username
    });
  });

  socket.on('typing_stop', (data) => {
    const { conversationId } = data;
    socket.to(`conversation:${conversationId}`).emit('typing_stopped', {
      userId: socket.user._id,
      conversationId
    });
  });

  // Mark messages as read
  socket.on('mark_messages_read', async (data) => {
    try {
      const { conversationId, messageIds } = data;

      // Verify access
      const conversation = await Conversation.findOne({
        _id: conversationId,
        'participants.user': socket.user._id
      });

      if (!conversation) return;

      // Mark messages as read
      await Message.updateMany(
        { 
          _id: { $in: messageIds },
          conversation: conversationId
        },
        {
          $addToSet: {
            readBy: {
              user: socket.user._id,
              readAt: new Date()
            }
          }
        }
      );

      // Update user's last read message in conversation
      await Conversation.updateOne(
        { 
          _id: conversationId,
          'participants.user': socket.user._id 
        },
        { 
          $set: { 
            'participants.$.lastReadMessage': messageIds[messageIds.length - 1] 
          } 
        }
      );

      // Emit read receipt to other participants
      socket.to(`conversation:${conversationId}`).emit('messages_read', {
        userId: socket.user._id,
        messageIds,
        conversationId
      });

    } catch (error) {
      console.error('Mark read error:', error);
    }
  });
};
```

### 3. Chat Window Component

```typescript
// src/components/Chat/ChatWindow.tsx
import React, { useState, useEffect, useRef, useCallback } from 'react';
import {
  Box,
  TextField,
  IconButton,
  Typography,
  CircularProgress,
  Paper,
  Divider,
} from '@mui/material';
import { Send, AttachFile, EmojiEmotions } from '@mui/icons-material';
import { MessageBubble } from './MessageBubble';
import { TypingIndicator } from './TypingIndicator';
import { useSocket } from '../../contexts/SocketContext';
import { useAuth } from '../../contexts/AuthContext';
import { Message, Conversation, messagesAPI } from '../../services/api';

interface ChatWindowProps {
  conversation: Conversation;
}

export const ChatWindow: React.FC<ChatWindowProps> = ({ conversation }) => {
  const { user } = useAuth();
  const { sendMessage, joinConversation, leaveConversation, onMessageReceived } = useSocket();
  
  const [messages, setMessages] = useState<Message[]>([]);
  const [newMessage, setNewMessage] = useState('');
  const [isLoading, setIsLoading] = useState(true);
  const [isTyping, setIsTyping] = useState(false);
  const [typingUsers, setTypingUsers] = useState<Set<string>>(new Set());
  const [replyingTo, setReplyingTo] = useState<Message | null>(null);
  
  const messagesEndRef = useRef<HTMLDivElement>(null);
  const typingTimeoutRef = useRef<NodeJS.Timeout>();

  // Load messages when conversation changes
  useEffect(() => {
    const loadMessages = async () => {
      setIsLoading(true);
      try {
        const response = await messagesAPI.getByConversation(conversation._id);
        setMessages(response.data.messages.reverse()); // Reverse to show oldest first
      } catch (error) {
        console.error('Failed to load messages:', error);
      } finally {
        setIsLoading(false);
      }
    };

    if (conversation._id) {
      loadMessages();
      joinConversation(conversation._id);
    }

    return () => {
      if (conversation._id) {
        leaveConversation(conversation._id);
      }
    };
  }, [conversation._id, joinConversation, leaveConversation]);

  // Handle new messages via socket
  useEffect(() => {
    const unsubscribe = onMessageReceived((message: Message) => {
      if (message.conversation === conversation._id) {
        setMessages(prev => [...prev, message]);
        
        // Mark message as read if window is focused and user is looking at this conversation
        if (document.hasFocus() && message.sender._id !== user?._id) {
          // Mark as read after a short delay
          setTimeout(() => {
            messagesAPI.markAsRead(message._id).catch(console.error);
          }, 1000);
        }
      }
    });

    return unsubscribe;
  }, [conversation._id, onMessageReceived, user]);

  // Auto-scroll to bottom when new messages arrive
  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages]);

  const handleSendMessage = useCallback((e?: React.FormEvent) => {
    e?.preventDefault();
    
    if (!newMessage.trim()) return;

    // Send via socket for real-time delivery
    sendMessage({
      conversationId: conversation._id,
      content: newMessage.trim(),
      type: 'text',
      replyTo: replyingTo?._id,
    });

    // Also send via HTTP API as fallback
    messagesAPI.send({
      conversationId: conversation._id,
      content: newMessage.trim(),
      type: 'text',
      replyTo: replyingTo?._id,
    }).catch(console.error);

    setNewMessage('');
    setReplyingTo(null);
    setIsTyping(false);
  }, [newMessage, conversation._id, replyingTo, sendMessage]);

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setNewMessage(e.target.value);
    
    // Handle typing indicators
    if (!isTyping) {
      setIsTyping(true);
      // Emit typing start event
    }
    
    // Reset typing timeout
    if (typingTimeoutRef.current) {
      clearTimeout(typingTimeoutRef.current);
    }
    
    typingTimeoutRef.current = setTimeout(() => {
      setIsTyping(false);
      // Emit typing stop event
    }, 2000);
  };

  const handleReply = (message: Message) => {
    setReplyingTo(message);
  };

  const handleCancelReply = () => {
    setReplyingTo(null);
  };

  const getConversationName = () => {
    if (conversation.type === 'group') {
      return conversation.name || 'Group Chat';
    }
    
    const otherParticipant = conversation.participants.find(
      p => p.user._id !== user?._id
    );
    
    return otherParticipant?.user.displayName || 'Unknown User';
  };

  const getOnlineStatus = () => {
    if (conversation.type === 'group') {
      const onlineCount = conversation.participants.filter(
        p => p.user.isOnline && p.user._id !== user?._id
      ).length;
      
      return onlineCount > 0 ? `${onlineCount} online` : 'No one online';
    }
    
    const otherParticipant = conversation.participants.find(
      p => p.user._id !== user?._id
    );
    
    return otherParticipant?.user.isOnline ? 'Online' : 'Offline';
  };

  if (isLoading) {
    return (
      <Box sx={{ 
        display: 'flex', 
        justifyContent: 'center', 
        alignItems: 'center',
        height: '100%' 
      }}>
        <CircularProgress />
      </Box>
    );
  }

  return (
    <Box sx={{ 
      height: '100%', 
      display: 'flex', 
      flexDirection: 'column',
      bgcolor: 'background.default'
    }}>
      {/* Header */}
      <Paper 
        sx={{ 
          p: 2, 
          borderBottom: '1px solid',
          borderBottomColor: 'divider',
          bgcolor: 'background.paper'
        }}
      >
        <Typography variant="h6" component="h2">
          {getConversationName()}
        </Typography>
        <Typography variant="body2" color="text.secondary">
          {getOnlineStatus()}
        </Typography>
      </Paper>

      {/* Messages area */}
      <Box sx={{ 
        flex: 1, 
        overflow: 'auto', 
        p: 1,
        display: 'flex',
        flexDirection: 'column'
      }}>
        {messages.length === 0 ? (
          <Box sx={{ 
            display: 'flex', 
            justifyContent: 'center', 
            alignItems: 'center',
            height: '100%',
            color: 'text.secondary'
          }}>
            <Typography>No messages yet. Start the conversation!</Typography>
          </Box>
        ) : (
          messages.map((message, index) => {
            const prevMessage = index > 0 ? messages[index - 1] : null;
            const showAvatar = !prevMessage || 
              prevMessage.sender._id !== message.sender._id ||
              (new Date(message.createdAt).getTime() - new Date(prevMessage.createdAt).getTime()) > 300000; // 5 minutes
            
            return (
              <MessageBubble
                key={message._id}
                message={message}
                showAvatar={showAvatar}
                onReply={handleReply}
              />
            );
          })
        )}
        
        {typingUsers.size > 0 && (
          <TypingIndicator users={Array.from(typingUsers)} />
        )}
        
        <div ref={messagesEndRef} />
      </Box>

      {/* Reply preview */}
      {replyingTo && (
        <Paper sx={{ p: 1, m: 1, bgcolor: 'grey.50' }}>
          <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
            <Box>
              <Typography variant="caption" color="text.secondary">
                Replying to {replyingTo.sender.displayName}
              </Typography>
              <Typography variant="body2">
                {replyingTo.content}
              </Typography>
            </Box>
            <IconButton size="small" onClick={handleCancelReply}>
              ×
            </IconButton>
          </Box>
        </Paper>
      )}

      {/* Message input */}
      <Paper sx={{ p: 2, bgcolor: 'background.paper' }}>
        <Box component="form" onSubmit={handleSendMessage} sx={{ display: 'flex', gap: 1 }}>
          <TextField
            fullWidth
            multiline
            maxRows={4}
            placeholder="Type a message..."
            value={newMessage}
            onChange={handleInputChange}
            variant="outlined"
            size="small"
            onKeyPress={(e) => {
              if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                handleSendMessage();
              }
            }}
          />
          
          <IconButton size="small">
            <AttachFile />
          </IconButton>
          
          <IconButton size="small">
            <EmojiEmotions />
          </IconButton>
          
          <IconButton 
            type="submit"
            disabled={!newMessage.trim()}
            sx={{ 
              bgcolor: 'primary.main', 
              color: 'white',
              '&:hover': { bgcolor: 'primary.dark' },
              '&:disabled': { bgcolor: 'grey.300' }
            }}
          >
            <Send />
          </IconButton>
        </Box>
      </Paper>
    </Box>
  );
};
```

### 4. Typing Indicator Component

```typescript
// src/components/Chat/TypingIndicator.tsx
import React from 'react';
import { Box, Typography } from '@mui/material';
import './TypingIndicator.css'; // CSS for animation

interface TypingIndicatorProps {
  users: string[];
}

export const TypingIndicator: React.FC<TypingIndicatorProps> = ({ users }) => {
  const getTypingText = () => {
    if (users.length === 1) {
      return `${users[0]} is typing...`;
    } else if (users.length === 2) {
      return `${users[0]} and ${users[1]} are typing...`;
    } else {
      return `${users.length} people are typing...`;
    }
  };

  return (
    <Box sx={{ 
      display: 'flex', 
      alignItems: 'center',
      p: 1,
      ml: 5, // Align with other messages
    }}>
      <Box className="typing-dots" sx={{ mr: 1 }}>
        <span></span>
        <span></span>
        <span></span>
      </Box>
      <Typography variant="body2" color="text.secondary" sx={{ fontStyle: 'italic' }}>
        {getTypingText()}
      </Typography>
    </Box>
  );
};
```

```css
/* src/components/Chat/TypingIndicator.css */
.typing-dots {
  display: inline-flex;
  align-items: center;
  gap: 2px;
}

.typing-dots span {
  height: 4px;
  width: 4px;
  background-color: #999;
  border-radius: 50%;
  animation: typing-pulse 1.4s ease-in-out infinite;
}

.typing-dots span:nth-child(1) {
  animation-delay: -0.32s;
}

.typing-dots span:nth-child(2) {
  animation-delay: -0.16s;
}

@keyframes typing-pulse {
  0%, 80%, 100% {
    opacity: 0.3;
    transform: scale(0.8);
  }
  40% {
    opacity: 1;
    transform: scale(1);
  }
}
```

## Main App Component

```typescript
// src/App.tsx
import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { ThemeProvider, createTheme } from '@mui/material/styles';
import { CssBaseline, Box } from '@mui/material';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';

import { AuthProvider, useAuth } from './contexts/AuthContext';
import { SocketProvider } from './contexts/SocketContext';
import { ChatDashboard } from './components/Chat/ChatDashboard';
import { LoginForm } from './components/Auth/LoginForm';
import { RegisterForm } from './components/Auth/RegisterForm';

const theme = createTheme({
  palette: {
    mode: 'light',
    primary: {
      main: '#1976d2',
    },
    secondary: {
      main: '#dc004e',
    },
  },
});

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      retry: 1,
      refetchOnWindowFocus: false,
    },
  },
});

// Protected route component
const ProtectedRoute: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const { user, isLoading } = useAuth();
  
  if (isLoading) {
    return <div>Loading...</div>;
  }
  
  return user ? <>{children}</> : <Navigate to="/login" />;
};

// Public route component (redirect if authenticated)
const PublicRoute: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const { user, isLoading } = useAuth();
  
  if (isLoading) {
    return <div>Loading...</div>;
  }
  
  return user ? <Navigate to="/chat" /> : <>{children}</>;
};

function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <ThemeProvider theme={theme}>
        <CssBaseline />
        <AuthProvider>
          <SocketProvider>
            <Router>
              <Box sx={{ height: '100vh', display: 'flex', flexDirection: 'column' }}>
                <Routes>
                  <Route path="/login" element={
                    <PublicRoute>
                      <LoginForm />
                    </PublicRoute>
                  } />
                  
                  <Route path="/register" element={
                    <PublicRoute>
                      <RegisterForm />
                    </PublicRoute>
                  } />
                  
                  <Route path="/chat" element={
                    <ProtectedRoute>
                      <ChatDashboard />
                    </ProtectedRoute>
                  } />
                  
                  <Route path="/" element={<Navigate to="/chat" />} />
                </Routes>
              </Box>
            </Router>
          </SocketProvider>
        </AuthProvider>
      </ThemeProvider>
    </QueryClientProvider>
  );
}

export default App;
```

**How Real-Time Messaging Works:**

1. **Socket Connection**: Authenticated users connect to Socket.IO server
2. **Room Management**: Users join conversation rooms for targeted message delivery
3. **Event Handling**: Real-time events for messages, typing, online status
4. **Fallback Strategy**: HTTP API calls as backup for reliability
5. **Typing Indicators**: Show when users are actively typing
6. **Online Status**: Track and display user presence
7. **Read Receipts**: Show when messages are read by recipients

The system provides a seamless real-time experience while maintaining data integrity through the REST API fallback.