import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/socket_service.dart';

class UserListDrawer extends StatelessWidget {
  const UserListDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF070911),
      child: Consumer<SocketService>(
        builder: (context, socketService, _) {
          return Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Row(
                    children: [
                      const Text(
                        '👥 Online',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6C5CE7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${socketService.users.length}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // User list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: socketService.users.length,
                  itemBuilder: (context, index) {
                    final user = socketService.users[index];
                    final isMe = user.username == socketService.username;

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: user.isAdmin
                            ? const Color(0xFFE17055)
                            : const Color(0xFF6C5CE7),
                        child: Text(
                          user.username[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        user.username,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: user.isAdmin
                                  ? const Color(0xFFE17055).withOpacity(0.2)
                                  : const Color(0xFF6C5CE7).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              user.isAdmin ? 'ADMIN' : 'USER',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: user.isAdmin
                                    ? const Color(0xFFE17055)
                                    : const Color(0xFFA29BFE),
                              ),
                            ),
                          ),
                          if (socketService.isAdmin &&
                              !isMe &&
                              !user.isAdmin)
                            IconButton(
                              icon: const Icon(Icons.close, size: 18),
                              color: Colors.red,
                              onPressed: () {
                                _showKickDialog(
                                  context,
                                  socketService,
                                  user.username,
                                );
                              },
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Footer
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: socketService.isAdmin
                            ? const Color(0xFFE17055).withOpacity(0.2)
                            : const Color(0xFF6C5CE7).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        socketService.isAdmin ? '👑 ADMIN' : '👤 USER',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: socketService.isAdmin
                              ? const Color(0xFFE17055)
                              : const Color(0xFFA29BFE),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        socketService.username ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showKickDialog(
    BuildContext context,
    SocketService socketService,
    String username,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove User'),
        content: Text('Remove "$username" from the room?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              socketService.kickUser(username);
              Navigator.pop(context);
            },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
