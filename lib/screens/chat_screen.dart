import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/socket_service.dart';
import '../widgets/message_bubble.dart';
import '../widgets/user_list_drawer.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final socketService = context.read<SocketService>();
    socketService.sendMessage(text);
    socketService.stopTyping();

    _messageController.clear();
    setState(() => _isTyping = false);

    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }

  void _onTyping(String text) {
    final socketService = context.read<SocketService>();

    if (text.isNotEmpty && !_isTyping) {
      socketService.startTyping();
      setState(() => _isTyping = true);
    } else if (text.isEmpty && _isTyping) {
      socketService.stopTyping();
      setState(() => _isTyping = false);
    }
  }

  void _leaveRoom() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Room'),
        content: const Text('Are you sure you want to leave the room?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<SocketService>().disconnect();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Leave', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SocketService>(
      builder: (context, socketService, _) {
        // Listen for errors.
        if (socketService.errorMessage != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(socketService.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
          });
        }

        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '💬 ChatHub',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  socketService.isConnected ? 'Connected' : 'Disconnected',
                  style: TextStyle(
                    fontSize: 12,
                    color: socketService.isConnected
                        ? const Color(0xFF00CEC9)
                        : Colors.red,
                  ),
                ),
              ],
            ),
            actions: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF00CEC9).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF00CEC9).withOpacity(0.25),
                  ),
                ),
                child: Text(
                  '${socketService.users.length} online',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF00CEC9),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.exit_to_app),
                onPressed: _leaveRoom,
                tooltip: 'Leave Room',
              ),
            ],
          ),
          drawer: const UserListDrawer(),
          body: Column(
            children: [
              // Messages
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: socketService.messages.length,
                  itemBuilder: (context, index) {
                    final message = socketService.messages[index];
                    if (message.role == 'system') {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            message.message,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.4),
                            ),
                          ),
                        ),
                      );
                    }
                    return MessageBubble(message: message);
                  },
                ),
              ),

              // Typing indicator
              if (socketService.typingUsers.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      ...List.generate(
                        3,
                        (i) => Container(
                          margin: const EdgeInsets.only(right: 4),
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFFA29BFE),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${socketService.typingUsers.join(", ")} is typing...',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                ),

              // Input
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.03),
                  border: Border(
                    top: BorderSide(
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        onChanged: _onTyping,
                        onSubmitted: (_) => _sendMessage(),
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.06),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(26),
                            borderSide: BorderSide(
                              color: Colors.white.withOpacity(0.08),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(26),
                            borderSide: BorderSide(
                              color: Colors.white.withOpacity(0.08),
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF6C5CE7), Color(0xFF7E6EEA)],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.send, size: 20),
                        onPressed: _sendMessage,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
