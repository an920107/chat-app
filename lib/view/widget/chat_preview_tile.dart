import 'package:chat_app/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ChatPreviewTile extends StatelessWidget {
  const ChatPreviewTile({
    super.key,
    required this.roomId,
    required this.name,
    required this.lastMessage,
    required this.lastTime,
    required this.unread,
  });

  final String roomId;
  final String name;
  final String lastMessage;
  final DateTime lastTime;
  final int unread;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => context.push("${Routes.chat.path}/$roomId"),
      // TODO: user avatar
      leading: ClipOval(
        child: Container(
          color: Colors.grey,
          child: const Icon(
            Icons.person,
            size: 36,
          ),
        ),
      ),
      title: Text(
        name,
        style: unread > 0 ? const TextStyle(fontWeight: FontWeight.bold) : null,
      ),
      subtitle: Row(
        children: [
          Flexible(
            child: Text(
              lastMessage,
              softWrap: false,
              overflow: TextOverflow.fade,
              style: unread > 0
                  ? const TextStyle(fontWeight: FontWeight.bold)
                  : null,
            ),
          ),
          Text(
            " • ${DateFormat(DateFormat.HOUR24_MINUTE).format(lastTime.toLocal())}",
            style: unread > 0
                ? const TextStyle(fontWeight: FontWeight.bold)
                : null,
          ),
        ],
      ),
      trailing: unread > 0
          ? ClipOval(
              child: Container(
                width: 20,
                height: 20,
                color: Colors.red.shade300,
                child: Center(
                  child: Text(
                    unread.toString(),
                    style: TextStyle(color: Colors.grey.shade200),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
