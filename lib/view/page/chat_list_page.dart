import 'package:chat_app/view/widget/chat_preview_tile.dart';
import 'package:flutter/material.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: const Text("Let's Chat"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
          const SizedBox(width: 10),
        ],
      ),
      body: ListView(
        children: [
          ChatPreviewTile(
            name: "Squid Spirit",
            lastMessage:
                "Hello! Nice to meet you! This message is very very long.",
            lastTime: DateTime(2024, 4, 10, 23, 57),
            unread: 12,
          ),
          ChatPreviewTile(
            name: "Lightning Xunhaoz",
            lastMessage: "When are you available?",
            lastTime: DateTime(2024, 4, 10, 22, 12),
            unread: 0,
          ),
        ],
      ),
    );
  }
}
