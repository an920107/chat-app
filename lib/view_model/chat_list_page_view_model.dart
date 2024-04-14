import 'dart:async';
import 'dart:collection';

import 'package:chat_app/model/room.dart';
import 'package:chat_app/repo/remote/room_remote_repo.dart';
import 'package:chat_app/repo/remote/user_remote_repo.dart';
import 'package:chat_app/service/message_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

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
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return;
    _rooms = await RoomRemoteRepo.getRooms(firebaseUser.uid);
    notifyListeners();
  }

  /// Search and add a friend with the given email.
  /// If there is something going wrong, it will return
  /// the error message, otherwise it will return null.
  Future<String?> addFriend(String? email) async {
    if (email?.trim().isEmpty ?? true) {
      return "Email can't be empty.";
    }
    if (email! == FirebaseAuth.instance.currentUser!.email) {
      return "You can't add yourself as a friend.";
    }
    final friend = await UserRemoteRepo.searchUser(email);
    if (friend == null) return "User not found.";
    var room = await RoomRemoteRepo.queryRoom(
        FirebaseAuth.instance.currentUser!.uid, friend.id);
    if (room != null) {
      return "You already have a friend with this user.";
    }

    room = Room(
      id: const Uuid().v4(),
      userIds: [FirebaseAuth.instance.currentUser!.uid, friend.id],
      messageIds: [],
      createdTime: DateTime.now().toUtc(),
      updatedTime: DateTime.now().toUtc(),
    );
    await RoomRemoteRepo.createRoom(room);

    return null;
  }
}
