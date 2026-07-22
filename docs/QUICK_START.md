# Quick Start Guide - Testing PRO Cashier

## 🚀 Get Started in 5 Minutes

This guide will help you run PRO Cashier on your device.

---

## Option 1: Android Emulator (Fastest Way)

### Prerequisites
- Flutter SDK installed (get it from [flutter.dev](https://flutter.dev/docs/get-started/install))
- Android Studio with emulator (optional, or use any Android emulator)

### Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/sherifg1985-cyber/PRO---cashier-.git
   cd PRO---cashier-
   ```

2. **Install Flutter dependencies**
   ```bash
   cd flutter_app
   flutter pub get
   ```

3. **Launch Android Emulator**
   ```bash
   # Using Android Studio (easiest)
   # Open Android Studio > Device Manager > Create/Launch Virtual Device
   
   # Or from command line
   emulator -avd Pixel_4_API_30 &
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

   The app will start building and launch on your emulator!

---

## Option 2: Physical Android Phone

### Prerequisites
- Android phone connected via USB
- USB debugging enabled on phone
- Flutter installed

### Steps

1. **Enable USB Debugging**
   ```
   Settings > Developer Options > USB Debugging (Enable)
   ```

2. **Connect phone via USB**
   ```bash
   # Verify connection
   flutter devices
   # You should see your phone listed
   ```

3. **Run the app**
   ```bash
   cd flutter_app
   flutter pub get
   flutter run
   ```

---

## Option 3: Windows Desktop (Recommended for Testing)

### Prerequisites
- Windows 10 or later
- Flutter with Windows support enabled
- Visual Studio with C++ tools (or MinGW)

### Steps

1. **Enable Windows support**
   ```bash
   flutter config --enable-windows-desktop
   ```

2. **Run on Windows**
   ```bash
   cd flutter_app
   flutter pub get
   flutter run -d windows
   ```

   The app will open in a Windows window!

---

## Option 4: iOS (Mac Only)

### Prerequisites
- Mac with Xcode installed
- iOS device or simulator
- Cocoapods installed

### Steps

1. **Install dependencies**
   ```bash
   cd flutter_app
   flutter pub get
   cd ios
   pod install
   cd ..
   ```

2. **Launch iOS Simulator**
   ```bash
   open -a Simulator
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

---

## 📝 Test Credentials

Use these test accounts to log in:

### Admin Account
```
Username: admin
Password: admin123
Branch: Main Branch
```

### Cashier Account
```
Username: cashier1
Password: cashier123
Branch: Main Branch
```

### Manager Account
```
Username: manager1
Password: manager123
Branch: Main Branch
```

⚠️ **Note:** These are demo credentials. For production, you must:
1. Set up the backend server
2. Configure the database
3. Create real user accounts

---

## 🔧 Development Mode (With Backend)

If you want to test with a real backend:

### 1. Start Backend Server

```bash
cd backend
npm install
cp .env.example .env
# Edit .env with your settings
npm run dev
```

Backend runs on: `http://localhost:3000`

### 2. Set Up Database

```bash
# Create PostgreSQL database
psql -U postgres -c "CREATE DATABASE cashier_db;"

# Run migrations
cd database
psql -U postgres -d cashier_db -f schema.sql
psql -U postgres -d cashier_db -f schema_extended.sql
```

### 3. Update API Endpoint

Edit `flutter_app/lib/core/config/api_constants.dart`:

```dart
static const String baseUrl = 'http://localhost:3000/api';
static const String wsUrl = 'ws://localhost:3000';
```

### 4. Run Flutter App

```bash
cd flutter_app
flutter run
```

---

## 🎮 Demo Features to Try

### 1. **Login**
   - Try with different user roles
   - Try with wrong credentials
   - Test account lockout

### 2. **User Management** (Admin Only)
   - Create new users
   - Edit user details
   - Disable/enable users
   - Lock/unlock accounts
   - View user activity logs

### 3. **Branch Management** (Admin Only)
   - Create new branches
   - Edit branch details
   - View branch configuration
   - Assign branch managers

### 4. **Dashboard**
   - View sales summary
   - Check inventory status
   - See today's transactions

### 5. **Language Switching**
   - Switch between English and Arabic
   - Check RTL layout
   - Verify translations

---

## 🐛 Troubleshooting

### Issue: "Flutter command not found"
**Solution:**
```bash
# Add Flutter to PATH
export PATH="$PATH:`pwd`/flutter/bin"
# Or install Flutter from flutter.dev
```

### Issue: "Android SDK not found"
**Solution:**
```bash
flutter doctor --android-licenses
# Accept all licenses
```

### Issue: "Device not detected"
**Solution:**
```bash
# Check connected devices
flutter devices

# If nothing shows, restart ADB
adb kill-server
adb start-server
```

### Issue: "Port 3000 already in use"
**Solution:**
```bash
# Find process on port 3000
lsof -i :3000
# Kill the process
kill -9 <PID>
```

### Issue: "Database connection error"
**Solution:**
```bash
# Check PostgreSQL is running
sudo service postgresql status

# Start PostgreSQL
sudo service postgresql start

# Verify credentials in .env
```

---

## 📱 Testing Checklist

- [ ] App launches successfully
- [ ] Login screen appears
- [ ] Can log in with test credentials
- [ ] Can switch between English and Arabic
- [ ] Dashboard loads correctly
- [ ] User management works (Admin)
- [ ] Branch management works (Admin)
- [ ] Navigation between screens works
- [ ] Responsive design on different screen sizes
- [ ] No crashes or errors

---

## 🎯 Next Steps

1. **Explore the UI** - Get familiar with the interface
2. **Test All Features** - Try different user roles
3. **Check Responsiveness** - Test on different screen sizes
4. **Test Languages** - Verify English and Arabic support
5. **Report Issues** - Create GitHub issues for any bugs

---

## 📞 Support

If you encounter issues:

1. Check [Troubleshooting](#troubleshooting) section
2. Check [Flutter Documentation](https://flutter.dev/docs)
3. Create an issue on [GitHub](https://github.com/sherifg1985-cyber/PRO---cashier-/issues)
4. Contact: sherifg1985@gmail.com

---

## ✨ Tips for Better Testing

1. **Use Landscape Mode** - Test on different orientations
2. **Test on Multiple Devices** - Different screen sizes show different layouts
3. **Enable Dark Mode** - Go to Settings > Theme > Dark
4. **Test Offline** - Disconnect internet and test offline features
5. **Monitor Performance** - Use DevTools to check performance

```bash
# Open DevTools
flutter pub global activate devtools
devtools
```

---

**Happy Testing! 🎉**

Enjoy exploring PRO Cashier. For feedback and feature requests, please reach out!
