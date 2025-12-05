import 'package:turbo_panel/features/chat/models/chat_message.dart';

class ChatConstants {
  ChatConstants._();

  static List<ChatMessage> seedMessages(DateTime now) => [
    ChatMessage(
      text: 'Hi there, I\'m turbo_agent. How can I help today?',
      isMe: false,
      timestamp: now.subtract(const Duration(days: 1, minutes: 2)),
    ),
    ChatMessage(
      text: 'I want to learn more about TurboVets tools.',
      isMe: true,
      timestamp: now.subtract(const Duration(days: 1, minutes: 1)),
    ),
    ChatMessage(
      text:
          'Great! This is just a demo conversation, but the real agent would appear here.',
      isMe: false,
      timestamp: now.subtract(const Duration(days: 1)),
    ),
  ];

  static const List<String> agentReplies = [
    'Thanks for reaching out! I\'m turbo_agent 🤖',
    'Happy to help with anything related to TurboVets tools.',
    'This is a simulated support reply for the assessment.',
    'Got it. I\'m “checking” that for you now.',
    'If this were production, a real agent would be typing here 👨‍⚕️👩‍⚕️',
  ];
}
