import 'package:flutter/material.dart';

import '../../models/chat_message.dart';
import 'chat_bubble.dart';

class ChatMessageList extends StatelessWidget {
  const ChatMessageList({
    super.key,
    required this.messages,
    required this.scrollController,
    required this.formatTimestamp,
    required this.formatDateHeader,
  });

  final List<ChatMessage> messages;
  final ScrollController scrollController;
  final String Function(DateTime) formatTimestamp;
  final String Function(DateTime) formatDateHeader;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];
    DateTime? lastDate;

    for (final msg in messages) {
      final currentDate = DateTime(
        msg.timestamp.year,
        msg.timestamp.month,
        msg.timestamp.day,
      );
      if (lastDate == null ||
          currentDate.isAfter(lastDate) ||
          currentDate.isBefore(lastDate)) {
        items.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.45),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  formatDateHeader(msg.timestamp),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        );
        lastDate = currentDate;
      }

      items.add(
        ChatBubble(
          text: msg.text,
          isMe: msg.isMe,
          timestamp: formatTimestamp(msg.timestamp),
          imagePath: msg.imagePath,
        ),
      );
    }

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.only(top: 16, left: 0, right: 0, bottom: 16),
      children: items,
    );
  }
}
