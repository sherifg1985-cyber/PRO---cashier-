# Installation Guide

## Prerequisites

- Flutter SDK (v3.0 or higher)
- Node.js (v16 or higher)
- PostgreSQL (v12 or higher)
- Git

## Backend Setup

### 1. Clone Repository
```bash
git clone https://github.com/sherifg1985-cyber/PRO---cashier-.git
cd PRO---cashier-
```

### 2. Set Up Backend
```bash
cd backend
npm install
```

### 3. Configure Environment
```bash
cp .env.example .env
# Edit .env with your database credentials
```

### 4. Database Setup
```bash
# Create PostgreSQL database
psql -U postgres -c "CREATE DATABASE cashier_db;"

# Run migrations
cd ../database
psql -U postgres -d cashier_db -f schema.sql
```

### 5. Start Backend
```bash
cd ../backend
npm run dev
```

## Frontend Setup

### 1. Flutter App
```bash
cd flutter_app
flutter pub get
```

### 2. Run on Different Platforms

**Android:**
```bash
flutter run -d android
```

**iOS:**
```bash
flutter run -d ios
```

**Windows (Desktop):**
```bash
flutter run -d windows
```

## Configuration

### Backend Configuration
- Update `backend/.env` with database credentials
- Set JWT_SECRET for authentication
- Configure CORS_ORIGIN

### Flutter Configuration
- Update API endpoint in `lib/core/config/api_config.dart`
- Configure WebSocket URL
- Set up Firebase (optional)

## Troubleshooting

### Port Already in Use
```bash
# Change PORT in .env or use different port
export PORT=4000
```

### Database Connection Error
- Verify PostgreSQL is running
- Check credentials in .env
- Ensure database exists

### Flutter Build Issues
- Run `flutter clean` and `flutter pub get`
- Check Flutter version: `flutter --version`
- Update dependencies: `flutter upgrade`
