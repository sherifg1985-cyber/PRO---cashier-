# Architecture Guide

## System Overview

The cashier system follows a modern client-server architecture with mobile-first design.

## Components

### Frontend (Flutter)
- **Presentation Layer**: UI components and screens
- **State Management**: Provider and Riverpod
- **Data Layer**: Local SQLite database and API clients
- **Services**: Authentication, API, WebSocket

### Backend (Node.js/Express)
- **API Routes**: RESTful endpoints
- **Business Logic**: Sales, inventory, reports
- **Database**: PostgreSQL
- **Real-time**: WebSocket for live updates
- **Authentication**: JWT-based

### Database (PostgreSQL)
- Users and roles
- Products and inventory
- Sales and transactions
- Sync logs for offline-online reconciliation

## Data Flow

```
Flutter App → HTTP/WebSocket → Express Server → PostgreSQL
   ↓
Local SQLite (offline cache)
```

## Key Features Architecture

### 1. Offline-First
- Local SQLite stores transactions
- Automatic sync when online
- Conflict resolution

### 2. Real-time Updates
- WebSocket connections
- Broadcast inventory changes
- Live sales notifications

### 3. Multi-Language Support
- Arabic (RTL) and English (LTR)
- Localization provider
- Dynamic language switching

### 4. Security
- JWT authentication
- Password hashing (bcrypt)
- CORS protection
- Rate limiting

## Technology Stack

| Layer | Technology |
|-------|------------|
| Frontend | Flutter |
| Backend | Node.js + Express |
| Database | PostgreSQL + SQLite |
| Real-time | WebSocket |
| Auth | JWT + bcrypt |
| API | REST |
