import 'package:chat_app/model/message.dart';
import 'package:chat_app/repo/local/message_local_repo.dart';

extension IdToMessage on String {
  Future<Message> toMessage() async {
    final message = await MessageLocalRepo.getMessage(this);
    if (message == null) throw Exception("Message not found");
    // TODO: user id
    message.isMe = message.sourceUid == "6b38a418-5ada-4c69-8cac-6354d74b4811";
    return message;
  }
}
