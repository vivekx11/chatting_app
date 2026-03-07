# 💬 ChatHub - Flutter App

A secure, modern real-time group chatroom Flutter application with Admin/User roles and PIN-based authentication.

## ✨ Features

- **Cross-Platform**: Works on Android, iOS, Web, Windows, macOS, and Linux
- **Role-Based Access**: Admin creates rooms, Users join with PIN
- **Real-time Messaging**: Instant message delivery using Socket.IO
- **User Management**: See who's online, admin can kick users
- **Typing Indicators**: See when others are typing
- **Modern UI**: Dark theme with Material Design 3
- **Responsive**: Adapts to different screen sizes
- **Secure**: PIN-based room authentication

## 🚀 Quick Start

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Backend server running (see backend folder)

### Installation

1. Install dependencies:
```bash
flutter pub get
```

2. Make sure your backend server is running:
```bash
cd ../backend
npm install
npm start
```

3. Server is already configured to use production backend:
```dart
// Production backend (already configured)
socketService.connect('https://chatting-server-u30c.onrender.com');

// For local development, change to:
// socketService.connect('http://localhost:3000');
// For Android emulator: http://10.0.2.2:3000
```

4. Run the app:
```bash
# For Android
flutter run

# For iOS
flutter run

# For Web
flutter run -d chrome

# For Windows
flutter run -d windows

# For macOS
flutter run -d macos

# For Linux
flutter run -d linux
```

## 📱 Platform-Specific Setup

### Android
- Minimum SDK: 21 (Android 5.0)
- Internet permission is already added in AndroidManifest.xml

### iOS
- Minimum iOS version: 12.0
- Network permissions are configured

### Web
- Works out of the box
- Make sure CORS is enabled on your server

## 🔧 Configuration

### Server URL

Update the server URL in `lib/screens/join_screen.dart`:

```dart
socketService.connect('YOUR_SERVER_URL');
```

**Common URLs:**
- Local development: `http://localhost:3000`
- Android emulator: `http://10.0.2.2:3000`
- iOS simulator: `http://localhost:3000`
- Real device: `http://YOUR_COMPUTER_IP:3000`
- Production: `https://your-domain.com`

## 📖 How to Use

### Creating a Room (Admin)

1. Select "👑 Admin — Create a Room"
2. Enter your display name
3. Create a numeric PIN (remember this!)
4. Tap "Create Room"
5. Share the PIN with others

### Joining a Room (User)

1. Select "👤 User — Join a Room"
2. Enter your display name
3. Enter the PIN shared by the admin
4. Tap "Join Room"

### Chat Features

- **Send Messages**: Type and press send button
- **View Members**: Tap the drawer icon to see online users
- **Kick Users** (Admin only): Tap the X button next to a user
- **Leave Room**: Tap the exit icon in the app bar

## 🛠️ Tech Stack

- **Framework**: Flutter 3.x
- **State Management**: Provider
- **Real-time**: Socket.IO Client
- **UI**: Material Design 3

## 📁 Project Structure

```
chatroom/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── models/
│   │   ├── user_model.dart         # User data model
│   │   └── message_model.dart      # Message data model
│   ├── screens/
│   │   ├── join_screen.dart        # Join/Create room screen
│   │   └── chat_screen.dart        # Chat interface
│   ├── services/
│   │   └── socket_service.dart     # Socket.IO service
│   └── widgets/
│       ├── message_bubble.dart     # Message UI component
│       └── user_list_drawer.dart   # User list drawer
├── pubspec.yaml                     # Dependencies
└── README.md                        # Documentation
```

## 🐛 Troubleshooting

### Cannot connect to server

1. Make sure the backend server is running
2. Check the server URL in `join_screen.dart`
3. For Android emulator, use `http://10.0.2.2:3000`
4. For real devices, use your computer's IP address
5. Ensure firewall allows connections

### Build errors

```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

## 📝 License

MIT License

---

Made with ❤️ using Flutter and Socket.IO
