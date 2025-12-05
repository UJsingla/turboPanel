class ChatMessage {
  ChatMessage({
    required this.text,
    required this.isMe,
    required this.timestamp,
    this.imagePath,
  });

  final String text;
  final bool isMe;
  final DateTime timestamp;
  final String? imagePath;

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isMe': isMe,
      'timestamp': timestamp.toIso8601String(),
      'imagePath': imagePath,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      text: json['text'] as String? ?? '',
      isMe: json['isMe'] as bool? ?? false,
      timestamp: DateTime.parse(json['timestamp'] as String),
      imagePath: json['imagePath'] as String?,
    );
  }
}
