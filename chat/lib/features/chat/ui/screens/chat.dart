import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:turbo_panel/features/chat/constants/chat_constants.dart';
import 'package:turbo_panel/features/chat/data/chat_repository.dart';
import 'package:turbo_panel/features/chat/data/message_storage_service.dart';
import 'package:turbo_panel/features/chat/models/chat_message.dart';
import 'package:turbo_panel/features/chat/ui/widgets/attachments_strip.dart';
import 'package:turbo_panel/features/chat/ui/widgets/chat_input_bar.dart';
import 'package:turbo_panel/features/chat/ui/widgets/chat_message_list.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, this.onUnreadCountChanged});

  final void Function(int count)? onUnreadCountChanged;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _inputFocusNode = FocusNode();
  bool _showEmojiPicker = false;
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _attachments = [];
  final List<String> _audioAttachments = [];
  final List<ChatMessage> _messages = [];
  final Random _random = Random();
  late final ChatRepository _repository;
  bool _isRecording = false;
  bool _hasText = false;
  int _unreadCount = 0;

  bool get _canSend =>
      _hasText || _attachments.isNotEmpty || _audioAttachments.isNotEmpty;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _repository = ChatRepository(MessageStorageService.instance);
    final stored = _repository.loadMessages();
    if (stored.isNotEmpty) {
      _messages.addAll(stored);
    } else {
      final now = DateTime.now();
      _messages.addAll(ChatConstants.seedMessages(now));
      _repository.replaceAll(_messages);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
    _scrollController.addListener(() {
      if (!_scrollController.hasClients) return;
      final max = _scrollController.position.maxScrollExtent;
      final current = _scrollController.position.pixels;
      if (max - current < 40 && _unreadCount != 0) {
        _updateUnread(0);
      }
    });
  }

  void _toggleEmojiPicker() {
    setState(() {
      _showEmojiPicker = !_showEmojiPicker;
    });
    if (_showEmojiPicker) {
      FocusScope.of(context).unfocus();
    } else {
      _inputFocusNode.requestFocus();
    }
  }

  void _appendEmoji(String emoji) {
    final text = _controller.text;
    _controller.text = '$text$emoji';
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
    setState(() {
      _hasText = _controller.text.trim().isNotEmpty;
    });
  }

  void _handleTextChanged(String value) {
    setState(() {
      _hasText = value.trim().isNotEmpty;
    });
  }

  void _openAttachmentOptions() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.black.withOpacity(0.9),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.white),
                title: const Text(
                  'Take a picture',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.white),
                title: const Text(
                  'Choose from photos',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickFromGallery();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image == null) return;
      setState(() {
        _attachments.add(image);
      });
    } catch (_) {}
  }

  Future<void> _pickFromGallery() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isEmpty) return;
      setState(() {
        _attachments.addAll(images);
      });
    } catch (_) {}
  }

  void _toggleRecording() {
    setState(() {
      if (_isRecording) {
        _isRecording = false;
        _audioAttachments.add('Voice message ${_audioAttachments.length + 1}');
      } else {
        _isRecording = true;
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      final max = _scrollController.position.maxScrollExtent;
      _scrollController
          .animateTo(
            max,
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
          )
          .then((_) {
            if (!mounted) return;
            _updateUnread(0, skipSetState: true);
          });
    });
  }

  bool _isAtBottom() {
    if (!_scrollController.hasClients) return true;
    final max = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;
    return (max - current) < 40;
  }

  void _handleSend() {
    final text = _controller.text.trim();
    final bool wasAtBottom = _isAtBottom();
    final List<ChatMessage> newMessages = [];

    if (_attachments.isNotEmpty) {
      for (int i = 0; i < _attachments.length; i++) {
        final file = _attachments[i];
        final isFirst = i == 0;
        final msg = ChatMessage(
          text: isFirst ? text : '',
          isMe: true,
          timestamp: DateTime.now(),
          imagePath: file.path,
        );
        newMessages.add(msg);
      }
    } else {
      if (text.isEmpty) return;
      newMessages.add(
        ChatMessage(text: text, isMe: true, timestamp: DateTime.now()),
      );
    }

    setState(() {
      _messages.addAll(newMessages);
      _controller.clear();
      _hasText = false;
      _attachments.clear();
      _audioAttachments.clear();
      _showEmojiPicker = false;
    });
    FocusScope.of(context).unfocus();

    for (final msg in newMessages) {
      _repository.addMessage(msg);
    }

    if (wasAtBottom) {
      _scrollToBottom();
    }

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      final bool wasAtBottom = _isAtBottom();
      final replyText = ChatConstants
          .agentReplies[_random.nextInt(ChatConstants.agentReplies.length)];
      final reply = ChatMessage(
        text: replyText,
        isMe: false,
        timestamp: DateTime.now(),
      );
      setState(() {
        _messages.add(reply);
        if (!wasAtBottom) {
          _updateUnread(_unreadCount + 1, skipSetState: true);
        }
      });

      _repository.addMessage(reply);

      if (wasAtBottom) {
        _scrollToBottom();
      }
    });
  }

  void _updateUnread(int value, {bool skipSetState = false}) {
    if (!skipSetState) {
      setState(() {
        _unreadCount = value;
      });
    } else {
      _unreadCount = value;
    }
    widget.onUnreadCountChanged?.call(_unreadCount);
  }

  String _formatTimestamp(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final suffix = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $suffix';
  }

  String _formatDateHeader(DateTime dt) {
    return '${_monthName(dt.month)} ${dt.day}, ${dt.year}';
  }

  String _monthName(int month) {
    const names = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return names[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final double fabBottom = (_showEmojiPicker ? 260 : 90);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: false,
      backgroundColor: Colors.transparent,
      appBar: null,
      body: Stack(
        children: [
          // Bottom black area
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: bottomPadding,
            child: Container(color: Colors.black),
          ),
          // Main content with manual SafeArea for top, left, right
          SafeArea(
            top: true,
            left: true,
            right: true,
            bottom: false,
            child: MediaQuery.removeViewInsets(
              context: context,
              removeBottom: true,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black.withOpacity(0.25),
                    child: Column(
                      children: [
                        AttachmentsStrip(
                          imageFiles: _attachments,
                          audioLabels: _audioAttachments,
                          onRemoveImage: (index) {
                            setState(() {
                              _attachments.removeAt(index);
                            });
                          },
                          onRemoveAudio: (index) {
                            setState(() {
                              _audioAttachments.removeAt(index);
                            });
                          },
                        ),
                        Expanded(
                          child: ChatMessageList(
                            messages: _messages,
                            scrollController: _scrollController,
                            formatTimestamp: _formatTimestamp,
                            formatDateHeader: _formatDateHeader,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ChatInputBar(
                            controller: _controller,
                            focusNode: _inputFocusNode,
                            canSend: _canSend,
                            isRecording: _isRecording,
                            emojiVisible: _showEmojiPicker,
                            onTextChanged: _handleTextChanged,
                            onSend: _handleSend,
                            onRecordToggle: _toggleRecording,
                            onAddAttachment: _openAttachmentOptions,
                            onEmojiToggle: _toggleEmojiPicker,
                          ),
                        ),
                        if (_showEmojiPicker)
                          SizedBox(
                            height: 220,
                            child: GridView.count(
                              crossAxisCount: 8,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              children:
                                  [
                                    '😀',
                                    '😄',
                                    '😁',
                                    '😆',
                                    '🥹',
                                    '😍',
                                    '😎',
                                    '🤩',
                                    '🤔',
                                    '😴',
                                    '👍',
                                    '👎',
                                    '🙏',
                                    '🔥',
                                    '❤️',
                                    '🎉',
                                  ].map((e) {
                                    return IconButton(
                                      onPressed: () => _appendEmoji(e),
                                      icon: Text(
                                        e,
                                        style: const TextStyle(fontSize: 22),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (_unreadCount > 0)
                    Positioned(
                      right: 16,
                      bottom: fabBottom,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          FloatingActionButton(
                            mini: true,
                            backgroundColor: Colors.black87,
                            onPressed: _scrollToBottom,
                            child: const Icon(Icons.arrow_downward),
                          ),
                          Positioned(
                            top: -4,
                            right: -4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 1,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                '$_unreadCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
