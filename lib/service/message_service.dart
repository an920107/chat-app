import 'dart:async';

import 'package:chat_app/model/message.dart';

abstract class MessageService {
  static final streamController = StreamController<Message>.broadcast();

  static Stream<Message> get stream => streamController.stream;

  static void addMessage(Message message) {
    streamController.add(message);
  }
}
