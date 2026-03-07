import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/join_screen.dart';
import 'services/socket_service.dart';

void main() {
  runApp(const ChatHubApp());
}

class ChatHubApp extends StatelessWidget {
  const ChatHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SocketService(),
      child: MaterialApp(
        title: 'ChatHub',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: const Color(0xFF6C5CE7),
          scaffoldBackgroundColor: const Color(0xFF0B0D17),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF6C5CE7),
            secondary: Color(0xFF00CEC9),
            surface: Color(0xFF1A1C2E),
            error: Color(0xFFFF6B6B),
          ),
          fontFamily: 'Inter',
          useMaterial3: true,
        ),
        home: const JoinScreen(),
      ),
    );
  }
}
