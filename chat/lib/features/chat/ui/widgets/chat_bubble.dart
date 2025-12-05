import 'dart:io';

import 'package:flutter/material.dart';

/// A reusable, modern-looking chat bubble used for messages in the chat screen.
class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.text,
    required this.isMe,
    this.timestamp,
    this.imagePath,
  });

  final String text;
  final bool isMe;
  final String? timestamp;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bubbleColor = isMe
        ? const Color(0xFF2563EB)
        : const Color(0xFF0F172A);

    final textColor = Colors.white;

    // User (isMe == true) on the right, agent (isMe == false) on the left.
    final alignment = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(18),
      topRight: const Radius.circular(18),
      bottomLeft: Radius.circular(isMe ? 18 : 4),
      bottomRight: Radius.circular(isMe ? 4 : 18),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxBubbleWidth = constraints.maxWidth * 0.58;
          return Column(
            crossAxisAlignment: alignment,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxBubbleWidth),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: imagePath == null
                        ? LinearGradient(
                            colors: isMe
                                ? [
                                    const Color(0xFF2563EB),
                                    const Color(0xFF1E3A8A),
                                  ]
                                : [
                                    const Color(0xFF101828),
                                    const Color(0xFF0F172A),
                                  ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: imagePath == null ? null : bubbleColor,
                    borderRadius: borderRadius,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.06),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: borderRadius,
                    child: Column(
                      crossAxisAlignment: alignment,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (imagePath != null)
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxHeight: 200,
                              minHeight: 110,
                            ),
                            child: Image.file(
                              File(imagePath!),
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        if (imagePath == null || text.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: Text(
                                    text,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: textColor,
                                      height: 1.3,
                                      fontWeight: isMe ? FontWeight.w600 : null,
                                    ),
                                  ),
                                ),
                                if (timestamp != null) ...[
                                  const SizedBox(width: 8),
                                  Text(
                                    timestamp!,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: Colors.white70,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                        if (timestamp != null &&
                            (imagePath != null && text.isEmpty)) ...[
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                              bottom: 6,
                              top: 4,
                            ),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                timestamp!,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: Colors.white70,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
