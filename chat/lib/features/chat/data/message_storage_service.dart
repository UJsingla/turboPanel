import 'package:hive_flutter/hive_flutter.dart';

import 'package:turbo_panel/features/chat/models/chat_message.dart';

/// Service responsible for persisting chat messages locally using Hive.
class MessageStorageService {
  MessageStorageService._internal();

  static final MessageStorageService instance =
      MessageStorageService._internal();

  static const String _boxName = 'chat_messages_box';

  Box<dynamic>? _box;

  /// Initialize Hive and open the messages box.
  Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.initFlutter();
      _box = await Hive.openBox<dynamic>(_boxName);
    } else {
      _box = Hive.box<dynamic>(_boxName);
    }
  }

  Box<dynamic> get _messagesBox {
    final box = _box;
    if (box == null) {
      throw StateError(
        'MessageStorageService not initialized. Call init() before use.',
      );
    }
    return box;
  }

  Future<void> addMessage(ChatMessage message) async {
    await _messagesBox.add(message.toJson());
  }

  Future<void> replaceAll(List<ChatMessage> messages) async {
    final encoded = messages.map((m) => m.toJson()).toList();
    await _messagesBox.clear();
    await _messagesBox.addAll(encoded);
  }

  List<ChatMessage> loadMessages() {
    final values = _messagesBox.values.toList();
    return values
        .whereType<Map>()
        .map((raw) => ChatMessage.fromJson(Map<String, dynamic>.from(raw)))
        .toList();
  }

  Future<void> clear() async {
    await _messagesBox.clear();
  }

  Future<void> close() async {
    await _messagesBox.close();
  }
}
