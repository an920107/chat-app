import 'dart:async';
import 'dart:collection';

import 'package:chat_app/model/room.dart';
import 'package:chat_app/repo/room_local_repo.dart';
import 'package:chat_app/service/message_service.dart';
import 'package:flutter/material.dart';

class ChatListPageViewModel with ChangeNotifier {
  List<Room> _rooms = [];
  List<Room> get rooms => UnmodifiableListView(_rooms);

  ChatListPageViewModel() {
    MessageService.stream.listen((event) {
      // TODO: this is a temporary solution,
      //  fetching all the rooms is pretty bad :(
      fetch();
    });
  }

  Future<void> fetch() async {
    _rooms = await RoomLocalRepo.getRooms();
    notifyListeners();
  }
}
