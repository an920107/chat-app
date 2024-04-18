import 'dart:async';
import 'dart:collection';

import 'package:chat_app/model/message.dart';
import 'package:chat_app/model/room.dart';
import 'package:chat_app/model/user.dart';
import 'package:chat_app/repo/message_repo.dart';
import 'package:chat_app/repo/open_ai_repo.dart';
import 'package:chat_app/repo/room_repo.dart';
import 'package:chat_app/repo/user_repo.dart';
import 'package:chat_app/service/message_service.dart';
import 'package:chat_app/view_model/utils.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ChatListPageViewModel with ChangeNotifier {
  List<Room> _rooms = [];
  List<Room> get rooms => UnmodifiableListView(_rooms);

  User? _user;
  String get name => _user?.name ?? "";
  String get email => _user?.email ?? "";

  ChatListPageViewModel() {
    MessageService.stream.listen((event) {
      // TODO: this is a temporary solution,
      //  fetching all the rooms is pretty bad :(
      fetch();
    });
  }

  Future<void> fetch() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    _user = await UserLocalRepo().getUser(uid);
    _rooms = await RoomLocalRepo().getRooms(uid);
    _rooms.sort((a, b) => b.updatedTime.compareTo(a.updatedTime));
    notifyListeners();

    await UserRemoteRepo().getUser(uid).then((value) async {
      if (value == null) return;
      if (_user == null) {
        _user = value;
        await UserLocalRepo().createUser(value);
      } else if (value.updatedTime.compareTo(_user!.updatedTime) > 0) {
        _user = value;
        await UserLocalRepo().updateUser(value);
      }
    });
    final newRooms = <Room>[];
    bool isRemoteRoomsError = false, isRemoteAiRoomExist = false;
    await RoomRemoteRepo().getRooms(uid).then((value) async {
      isRemoteRoomsError = value.isEmpty;
      for (var remoteRoom in value) {
        if (Utils().isAiRoom(remoteRoom)) isRemoteAiRoomExist = true;
        try {
          final localRoom = _rooms.firstWhere((e) => e.id == remoteRoom.id);
          if (remoteRoom.updatedTime.compareTo(localRoom.updatedTime) > 0) {
            newRooms.add(remoteRoom);
            await RoomLocalRepo().updateRoom(remoteRoom);
          } else {
            newRooms.add(localRoom);
          }
        } on StateError {
          await RoomLocalRepo().createRoom(remoteRoom);
          newRooms.add(remoteRoom);
        }
      }
    });
    if (!isRemoteAiRoomExist) {
      final aiRoom = await createAiRoom();
      if (aiRoom != null) {
        newRooms.add(aiRoom);
      } else {
        isRemoteRoomsError = true;
      }
    }
    if (!isRemoteRoomsError) {
      _rooms = List.from(newRooms);
      _rooms.sort((a, b) => b.updatedTime.compareTo(a.updatedTime));
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    _rooms = [];
    _user = null;
  }

  /// Search and add a friend with the given email.
  ///
  /// If there is something going wrong, it will return
  /// the error message, otherwise it will return null.
  Future<String?> addFriend(String? email) async {
    if (email?.trim().isEmpty ?? true) {
      return "Email can't be empty.";
    }
    if (email! == FirebaseAuth.instance.currentUser!.email) {
      return "You can't add yourself as a friend.";
    }
    final friend = await UserRemoteRepo().searchUser(email);
    if (friend == null) return "User not found.";
    var room = await RoomRemoteRepo()
        .queryRoom(FirebaseAuth.instance.currentUser!.uid, friend.id);
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
    await RoomRemoteRepo().createRoom(room);

    await fetch();
    return null;
  }

  /// Change the user's display name.
  ///
  /// If there is something going wrong, it will return
  /// the error message, otherwise it will return null.
  Future<String?> changeName(String newName) async {
    if (_user == null) return "Authentication error";
    newName = newName.trim();
    if (newName.isEmpty) return "Name shouldn't be empty";
    if (newName == _user?.name) "Name haven't changed";
    _user = await UserRemoteRepo().getUser(_user!.id);
    if (_user == null) return "Authentication error";
    _user!.name = newName;
    _user!.updatedTime = DateTime.now().toUtc();
    await UserRemoteRepo().updateUser(_user!);
    await UserLocalRepo().updateUser(_user!);
    notifyListeners();
    return null;
  }

  Future<Room?> createAiRoom() async {
    final aiReply = await OpenAiRepo().getReply("Hello!");
    if (aiReply == null) return null;
    
    final aiRoom = Room(
      id: const Uuid().v4(),
      userIds: [FirebaseAuth.instance.currentUser!.uid, "ai"],
      messageIds: [],
      createdTime: DateTime.now().toUtc(),
      updatedTime: DateTime.now().toUtc(),
    );

    final firstMessage = Message(
      id: const Uuid().v4(),
      sourceUid: "ai",
      content: aiReply,
      createdTime: DateTime.now().toUtc(),
      updatedTime: DateTime.now().toUtc(),
    );

    await RoomRemoteRepo().createRoom(aiRoom);
    await RoomLocalRepo().createRoom(aiRoom);
    await MessageRemoteRepo().createMessage(firstMessage);
    await RoomRemoteRepo().patchMessage(aiRoom.id, [firstMessage.id]);
    return aiRoom;
  }
}
