import 'package:flutter/material.dart';
import '../models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment:
            message.isSelf ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Sender name
          if (!message.isSelf)
            Padding(
              padding: const EdgeInsets.only(left: 6, bottom: 3),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message.sender,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: message.isAdmin
                          ? const Color(0xFFE17055)
                          : const Color(0xFFA29BFE),
                    ),
                  ),
                  if (message.isAdmin) ...[
                    const SizedBox(width: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE17055).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: const Text(
                        'ADMIN',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE17055),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

          // Message bubble
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.65,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: message.isSelf
                  ? const LinearGradient(
                      colors: [Color(0xFF6C5CE7), Color(0xFF7E6EEA)],
                    )
                  : message.isAdmin
                      ? const LinearGradient(
                          colors: [Color(0xFFE17055), Color(0xFFD63031)],
                        )
                      : null,
              color: message.isSelf || message.isAdmin
                  ? null
                  : Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(18).copyWith(
                bottomRight: message.isSelf ? const Radius.circular(6) : null,
                bottomLeft: !message.isSelf ? const Radius.circular(6) : null,
              ),
              border: message.isSelf || message.isAdmin
                  ? null
                  : Border.all(
                      color: Colors.white.withOpacity(0.08),
                    ),
            ),
            child: Text(
              message.message,
              style: const TextStyle(
                fontSize: 15,
                height: 1.4,
                color: Colors.white,
              ),
            ),
          ),

          // Time
          Padding(
            padding: const EdgeInsets.only(top: 3, left: 6, right: 6),
            child: Text(
              message.time,
              style: TextStyle(
                fontSize: 10,
                color: Colors.white.withOpacity(0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
