import 'package:chat_app/view/widget/chat_preview_tile.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Room"),
        automaticallyImplyLeading: false,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.menu))],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(5),
          child: Divider(),
        ),
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
