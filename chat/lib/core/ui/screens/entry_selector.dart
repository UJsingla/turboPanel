import 'package:flutter/material.dart';

import '../../../features/chat/ui/screens/chat.dart';
import '../../../features/dashboard/ui/screens/dashboard_page.dart';

class EntrySelectorPage extends StatefulWidget {
  const EntrySelectorPage({super.key});

  @override
  State<EntrySelectorPage> createState() => _EntrySelectorPageState();
}

class _EntrySelectorPageState extends State<EntrySelectorPage> {
  int _chatUnread = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Material(
                color: Colors.black87,
                child: TabBar(
                  indicatorColor: Colors.white,
                  tabs: [
                    _buildChatTab(),
                    const Tab(
                      icon: Icon(Icons.dashboard_outlined),
                      text: 'Dashboard',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  physics:
                      const NeverScrollableScrollPhysics(), // prevent over-sensitive swipes
                  children: [
                    ChatPage(
                      onUnreadCountChanged: (count) {
                        setState(() {
                          _chatUnread = count;
                        });
                      },
                    ),
                    const DashboardPage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatTab() {
    if (_chatUnread <= 0) {
      return const Tab(icon: Icon(Icons.chat_bubble_outline), text: 'Chat');
    }
    return Tab(
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(Icons.chat_bubble_outline),
          Positioned(
            right: -10,
            top: -6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$_chatUnread',
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
      text: 'Chat',
    );
  }
}
