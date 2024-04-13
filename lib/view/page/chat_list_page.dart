import 'package:chat_app/view/widget/chat_preview_tile.dart';
import 'package:chat_app/view_model/chat_list_page_view_model.dart';
import 'package:chat_app/view_model/extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatListPageViewModel>().fetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
        title: const Text("Let's Chat"),
      ),
      body: Consumer<ChatListPageViewModel>(
        builder: (context, value, child) => ListView(
          children: value.rooms.map((room) {
            final lastMessageFuture = room.messageIds.lastOrNull?.toMessage();
            return FutureBuilder(
              future: lastMessageFuture,
              builder: (context, snapshot) => ChatPreviewTile(
                roomId: room.id,
                name: room.name,
                lastMessage: snapshot.data?.content ?? "<No message>",
                lastTime: room.updatedTime,
                unread: room.unread.length,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
