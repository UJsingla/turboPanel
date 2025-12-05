import 'package:flutter/material.dart';

class ChatInputBar extends StatelessWidget {
  const ChatInputBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.canSend,
    required this.isRecording,
    required this.emojiVisible,
    required this.onTextChanged,
    required this.onSend,
    required this.onRecordToggle,
    required this.onAddAttachment,
    required this.onEmojiToggle,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool canSend;
  final bool isRecording;
  final bool emojiVisible;
  final ValueChanged<String> onTextChanged;
  final VoidCallback onSend;
  final VoidCallback onRecordToggle;
  final VoidCallback onAddAttachment;
  final VoidCallback onEmojiToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            color: Colors.white,
            onPressed: onAddAttachment,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              style: const TextStyle(color: Colors.white),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              onChanged: onTextChanged,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.black.withOpacity(0.4),
                hintText: 'Type a message',
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: IconButton(
                  icon: Icon(
                    emojiVisible
                        ? Icons.keyboard_outlined
                        : Icons.emoji_emotions_outlined,
                    color: Colors.white70,
                  ),
                  onPressed: onEmojiToggle,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(
              canSend ? Icons.send : (isRecording ? Icons.stop : Icons.mic),
            ),
            color: Colors.white,
            onPressed: () {
              if (canSend) {
                onSend();
              } else {
                onRecordToggle();
              }
            },
          ),
        ],
      ),
    );
  }
}
