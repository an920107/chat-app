import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(
    this.uid, {
    super.key,
  });

  final String uid;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
