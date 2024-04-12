import 'package:chat_app/router/routes.dart';
import 'package:chat_app/view/widget/message_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage(
    this.id, {
    super.key,
  });

  final String id;

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () =>
              context.canPop() ? context.pop() : context.go(Routes.chat.path),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Chat Room Name"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ListView(
                children: [
                  MessageTile(isMe: true),
                  MessageTile(isMe: false),
                  MessageTile(isMe: true),
                  MessageTile(isMe: true),
                  MessageTile(isMe: false),
                  MessageTile(isMe: false),
                  MessageTile(isMe: true),
                  MessageTile(isMe: true),
                  MessageTile(isMe: false),
                  MessageTile(isMe: false),
                  MessageTile(isMe: true),
                  MessageTile(isMe: false),
                  MessageTile(isMe: false),
                  MessageTile(isMe: true),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 0,
                        ),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                      minLines: 1,
                      maxLines: 5,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
