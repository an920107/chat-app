import 'package:chat_app/model/message.dart';
import 'package:chat_app/model/room.dart';
import 'package:chat_app/repo/message_repo.dart';
import 'package:chat_app/repo/user_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Utils {
  static final Utils _instance = Utils._internal();
  factory Utils() => _instance;

  late FirebaseAuth _firebaseAuth;
  late MessageLocalRepo _messageLocalRepo;
  late MessageRemoteRepo _messageRemoteRepo;
  late UserLocalRepo _userLocalRepo;
  late UserRemoteRepo _userRemoteRepo;

  Utils._internal() {
    _firebaseAuth = FirebaseAuth.instance;
    _messageLocalRepo = MessageLocalRepo();
    _messageRemoteRepo = MessageRemoteRepo();
    _userLocalRepo = UserLocalRepo();
    _userRemoteRepo = UserRemoteRepo();
  }

  Utils.from(
    this._firebaseAuth,
    this._messageLocalRepo,
    this._messageRemoteRepo,
    this._userLocalRepo,
    this._userRemoteRepo,
  );

  Future<Message?> getMessage(String? id) async {
    if (id == null) return null;
    var message = await _messageLocalRepo.getMessage(id);
    if (message == null) {
      message = await _messageRemoteRepo.getMessage(id);
      if (message == null) return null;
      await _messageLocalRepo.createMessage(message);
    }
    message.isMe = message.sourceUid == _firebaseAuth.currentUser!.uid;
    return message;
  }

  Future<String> getRoomName(Room room) async {
    if (room.userIds.isEmpty) return "";
    final otherSideId =
        room.userIds.firstWhere((e) => e != _firebaseAuth.currentUser!.uid);
    var otherSideUser = await _userLocalRepo.getUser(otherSideId);
    if (otherSideUser == null) {
      otherSideUser = await _userRemoteRepo.getUser(otherSideId);
      if (otherSideUser == null) return "";
      await _userLocalRepo.createUser(otherSideUser);
    }
    return otherSideUser.name;
  }

  bool isAiRoom(Room room) => room.userIds.contains("ai");
}
