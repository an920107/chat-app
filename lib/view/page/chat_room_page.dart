import 'package:chat_app/router/routes.dart';
import 'package:chat_app/view/widget/message_tile.dart';
import 'package:chat_app/view_model/chat_room_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
  final _textController = TextEditingController();
  final _textFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _scrollController.jumpTo(double.infinity);
      context.read<ChatRoomPageViewModel>().fetch(widget.id);
    });
  }

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
        title: Text(context.watch<ChatRoomPageViewModel>().room.name),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Consumer<ChatRoomPageViewModel>(
                builder: (context, value, child) => ListView.builder(
                  reverse: true,
                  itemCount: value.room.messageIds.length,
                  itemBuilder: (context, index) {
                    final messageFuture = value.room.messageIds.reversed
                        .toList()[index]
                        .toMessage();
                    return FutureBuilder(
                      future: messageFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done ||
                            !snapshot.hasData) {
                          return const SizedBox();
                        }
                        final message = snapshot.data!;
                        return MessageTile(
                          content: message.content,
                          sendTime: message.updatedTime,
                          isMe: message.isMe,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _textController,
                      focusNode: _textFocusNode,
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
                    onPressed: () async {
                      await context
                          .read<ChatRoomPageViewModel>()
                          .sendMessage(_textController.text);
                      _textController.clear();
                      if (context.mounted) {
                        FocusScope.of(context).requestFocus(_textFocusNode);
                      }
                    },
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
