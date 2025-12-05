import 'package:turbo_panel/features/chat/models/chat_message.dart';
import 'package:turbo_panel/features/chat/data/message_storage_service.dart';

/// Repository layer that isolates storage access from UI.
class ChatRepository {
  ChatRepository(this._storage);

  final MessageStorageService _storage;

  Future<void> init() => _storage.init();
  List<ChatMessage> loadMessages() => _storage.loadMessages();
  Future<void> addMessage(ChatMessage message) => _storage.addMessage(message);
  Future<void> replaceAll(List<ChatMessage> messages) =>
      _storage.replaceAll(messages);
  Future<void> clear() => _storage.clear();
}
