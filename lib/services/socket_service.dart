import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/user_model.dart';
import '../models/message_model.dart';

class SocketService extends ChangeNotifier {
  IO.Socket? _socket;
  String? _username;
  String? _role;
  List<UserModel> _users = [];
  List<MessageModel> _messages = [];
  List<String> _typingUsers = [];
  bool _isConnected = false;
  String? _errorMessage;

  // Getters
  String? get username => _username;
  String? get role => _role;
  List<UserModel> get users => _users;
  List<MessageModel> get messages => _messages;
  List<String> get typingUsers => _typingUsers;
  bool get isConnected => _isConnected;
  String? get errorMessage => _errorMessage;
  bool get isAdmin => _role == 'admin';

  // Connect to server
  void connect(String serverUrl) {
    _socket = IO.io(
      serverUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    _socket!.connect();

    _socket!.onConnect((_) {
      _isConnected = true;
      notifyListeners();
    });

    _socket!.onDisconnect((_) {
      _isConnected = false;
      notifyListeners();
    });

    _setupListeners();
  }

  void _setupListeners() {
    // Join success
    _socket!.on('join-success', (data) {
      _username = data['username'];
      _role = data['role'];
      _users = (data['users'] as List)
          .map((u) => UserModel.fromJson(u))
          .toList();
      _errorMessage = null;
      notifyListeners();
    });

    // Join error
    _socket!.on('join-error', (msg) {
      _errorMessage = msg;
      notifyListeners();
    });

    // Receive message
    _socket!.on('receive-message', (data) {
      final message = MessageModel.fromJson(data, _username ?? '');
      _messages.add(message);
      notifyListeners();
    });

    // User joined
    _socket!.on('user-joined', (data) {
      _users = (data['users'] as List)
          .map((u) => UserModel.fromJson(u))
          .toList();
      _addSystemMessage('${data['username']} joined the room');
      notifyListeners();
    });

    // User left
    _socket!.on('user-left', (data) {
      _users = (data['users'] as List)
          .map((u) => UserModel.fromJson(u))
          .toList();
      final msg = data['kicked'] == true
          ? '${data['username']} was removed by Admin'
          : '${data['username']} left the room';
      _addSystemMessage(msg);
      _typingUsers.remove(data['username']);
      notifyListeners();
    });

    // Typing indicators
    _socket!.on('user-typing', (data) {
      final username = data['username'];
      if (!_typingUsers.contains(username)) {
        _typingUsers.add(username);
        notifyListeners();
      }
    });

    _socket!.on('user-stop-typing', (data) {
      _typingUsers.remove(data['username']);
      notifyListeners();
    });

    // Kicked
    _socket!.on('kicked', (msg) {
      _errorMessage = msg;
      disconnect();
      notifyListeners();
    });

    // Room closed
    _socket!.on('room-closed', (msg) {
      _errorMessage = msg;
      disconnect();
      notifyListeners();
    });
  }

  void _addSystemMessage(String text) {
    _messages.add(MessageModel(
      sender: 'System',
      role: 'system',
      message: text,
      time: '',
      isSelf: false,
    ));
  }

  // Join room
  void joinRoom(String username, String pin, String role) {
    _socket!.emit('join-room', {
      'username': username,
      'pin': pin,
      'role': role,
    });
  }

  // Send message
  void sendMessage(String message) {
    _socket!.emit('send-message', {'message': message});
  }

  // Typing events
  void startTyping() {
    _socket!.emit('typing');
  }

  void stopTyping() {
    _socket!.emit('stop-typing');
  }

  // Kick user (admin only)
  void kickUser(String targetUsername) {
    _socket!.emit('kick-user', {'targetUsername': targetUsername});
  }

  // Disconnect
  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _isConnected = false;
    notifyListeners();
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }
}
