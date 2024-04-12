import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageTile extends StatelessWidget {
  const MessageTile({
    super.key,
    required this.isMe,
  });

  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TODO: user avatar
          if (!isMe)
            ClipOval(
              child: Container(
                color: Colors.grey,
                child: const Icon(
                  Icons.person,
                  size: 36,
                ),
              ),
            ),
          if (!isMe) const SizedBox(width: 16),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isMe)
                _buildSendTime(isMe: isMe, time: DateTime.now()),
              ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 36,
                  maxWidth: MediaQuery.of(context).size.width / 1.6,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: isMe ? Colors.green.shade200 : Colors.grey.shade300,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(isMe ? 10 : 0),
                      topRight: Radius.circular(isMe ? 0 : 10),
                      bottomRight: const Radius.circular(10),
                      bottomLeft: const Radius.circular(10),
                    ),
                  ),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Hello!!!\nasasdasd\naasqweqweq\nn1231231231aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa2",
                        softWrap: true,
                      ),
                    ),
                  ),
                ),
              ),
              if (!isMe)
                _buildSendTime(isMe: isMe, time: DateTime.now()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSendTime({required bool isMe,required DateTime time}) {
    return Padding(
      padding: EdgeInsets.only(
        left: isMe ? 0 : 10,
        right: isMe ? 10 : 0,
      ),
      child: Text(
        DateFormat(DateFormat.HOUR24_MINUTE).format(time),
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
    );
  }
}
