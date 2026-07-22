# Installation Guide for Testing

## 🎯 Choose Your Path

### Path 1: Fastest Way (Android Emulator)
**Time: 10-15 minutes**
- No physical device needed
- Perfect for UI testing
- Easy to switch devices

### Path 2: Physical Android Phone
**Time: 5-10 minutes**
- Real device testing
- Test actual performance
- Test fingerprint authentication

### Path 3: Windows Desktop
**Time: 10-15 minutes**
- Desktop application
- Full-screen testing
- Best for development

### Path 4: iPhone (Mac Only)
**Time: 15-20 minutes**
- iOS-specific features
- App Store readiness testing

---

## 🔧 Step-by-Step Installation

### Step 1: Install Flutter

#### macOS
```bash
# Using Homebrew
brew install flutter

# Or download from flutter.dev
# https://flutter.dev/docs/get-started/install/macos
```

#### Windows
```bash
# Download from flutter.dev
# https://flutter.dev/docs/get-started/install/windows

# Add to PATH in environment variables
# C:\flutter\bin
```

#### Linux
```bash
# Download from flutter.dev
tar xf flutter_linux_*.tar.xz
export PATH="$PATH:`pwd`/flutter/bin"
```

### Step 2: Verify Installation

```bash
flutter doctor
```

You should see:
```
✓ Flutter (X.XX.X)
✓ Dart SDK
✓ DevTools
✓ Android SDK (if testing on Android)
✓ Xcode (if testing on iOS)
```

### Step 3: Clone the Repository

```bash
git clone https://github.com/sherifg1985-cyber/PRO---cashier-.git
cd PRO---cashier-
```

### Step 4: Install App Dependencies

```bash
cd flutter_app
flutter pub get
```

Wait for dependencies to download (2-3 minutes)

### Step 5: Run the App

#### Option A: Android Emulator

```bash
# List available devices
flutter devices

# Start emulator (if not already running)
emulator -avd <device_name> &

# Run app
flutter run
```

#### Option B: Physical Android Phone

```bash
# Enable USB Debugging on phone
# Settings > Developer Options > USB Debugging

# Connect phone via USB
# Verify connection
flutter devices

# Run app
flutter run
```

#### Option C: Windows Desktop

```bash
# Enable Windows support
flutter config --enable-windows-desktop

# Run app
flutter run -d windows
```

#### Option D: iOS Simulator

```bash
# Start simulator
open -a Simulator

# Run app
flutter run
```

---

## ✅ Verify Installation

Once the app launches:

1. **Splash Screen** appears
2. **Login Screen** shows
3. **Language selector** visible (English/العربية)
4. **Branch selector** visible
5. **Username & Password fields** ready

---

## 🎮 First Time Login

### Test Account 1 (Admin)
```
Username: admin
Password: admin123
Language: English
Branch: Main Branch
```

**Features available:**
- User Management
- Branch Management
- Full system access
- Admin dashboard

### Test Account 2 (Cashier)
```
Username: cashier1
Password: cashier123
Language: English
Branch: Main Branch
```

**Features available:**
- Create sales
- Process payments
- Print receipts
- View own activity

---

## 🌍 Testing Multi-Language

1. Login to app
2. Go to **Settings**
3. Select **Language**
4. Choose **العربية** (Arabic)
5. App restarts with Arabic UI
6. Notice:
   - RTL layout (right-to-left)
   - Arabic text throughout
   - All buttons and menus in Arabic

---

## 🎨 Testing Themes

1. Open **Settings**
2. Select **Theme**
3. Choose:
   - **Light** - Bright theme
   - **Dark** - Dark theme
   - **Auto** - Matches system theme

---

## 🚀 Performance Testing

Open DevTools to monitor:

```bash
# In a new terminal (keep app running)
flutter pub global activate devtools
devtools
```

Monitor:
- CPU usage
- Memory usage
- Frame rate
- App startup time

---

## 📊 Test Different Screen Sizes

### Android Emulator

```bash
flutter run

# Rotate device
Press 'R' in terminal

# Change orientation
Alt + Right Arrow (Windows)
Command + Right Arrow (Mac)
```

### Windows

```bash
# Resize window
# Drag corner to resize
# See responsive layout in action
```

---

## 🔍 Testing Specific Features

### Login Features
- [ ] Valid login works
- [ ] Invalid password shows error
- [ ] Account lockout after 5 failed attempts
- [ ] Language switching works
- [ ] Branch selection works

### Dashboard Features
- [ ] Dashboard loads
- [ ] Widgets display correctly
- [ ] Responsive layout
- [ ] No crashes or errors

### User Management (Admin)
- [ ] Can navigate to users
- [ ] Can view user list
- [ ] UI is responsive
- [ ] Search/filter works

### Settings
- [ ] Language switching works
- [ ] Theme switching works
- [ ] RTL layout correct for Arabic
- [ ] All settings save properly

---

## 🎯 Recommended Testing Order

1. **Install & Launch** ✓
2. **Test Login** ✓
3. **Switch Language** ✓
4. **Switch Theme** ✓
5. **Test Admin Features** ✓
6. **Test Cashier Features** ✓
7. **Test Navigation** ✓
8. **Test Responsiveness** ✓
9. **Monitor Performance** ✓
10. **Report Issues** ✓

---

## 📝 Creating Bug Reports

If you find bugs:

```bash
# Go to GitHub issues
https://github.com/sherifg1985-cyber/PRO---cashier-/issues

# Click "New Issue"
# Include:
# - Device model
# - OS version
# - Steps to reproduce
# - Expected vs actual behavior
# - Screenshots/videos
```

---

## 🆘 Getting Help

### Common Issues

**"Flutter not found"**
```bash
export PATH="$PATH:~/flutter/bin"
```

**"Device not detected"**
```bash
flutter devices
adb kill-server && adb start-server
```

**"Port already in use"**
```bash
lsof -i :8888
kill -9 <PID>
```

### Support Channels

1. **GitHub Issues:** https://github.com/sherifg1985-cyber/PRO---cashier-/issues
2. **Email:** sherifg1985@gmail.com
3. **Documentation:** Check docs/ folder
4. **Flutter Docs:** https://flutter.dev/docs

---

## 🎉 You're Ready!

Now you can:

✅ Run PRO Cashier locally
✅ Test all features
✅ Explore the UI
✅ Test in multiple languages
✅ Try different themes
✅ Report issues
✅ Contribute improvements

Happy Testing! 🚀
