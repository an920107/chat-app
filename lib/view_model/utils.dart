import 'package:chat_app/model/message.dart';
import 'package:chat_app/model/room.dart';
import 'package:chat_app/repo/message_repo.dart';
import 'package:chat_app/repo/user_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Utils {
  static final Utils _instance = Utils._internal();
  factory Utils() => _instance;

  late FirebaseAuth firebaseAuth;
  late MessageLocalRepo messageLocalRepo;
  late MessageRemoteRepo messageRemoteRepo;
  late UserLocalRepo userLocalRepo;
  late UserRemoteRepo userRemoteRepo;

  Utils._internal() {
    firebaseAuth = FirebaseAuth.instance;
    messageLocalRepo = MessageLocalRepo();
    messageRemoteRepo = MessageRemoteRepo();
    userLocalRepo = UserLocalRepo();
    userRemoteRepo = UserRemoteRepo();
  }

  Utils.from(
    this.firebaseAuth,
    this.messageLocalRepo,
    this.messageRemoteRepo,
    this.userLocalRepo,
    this.userRemoteRepo,
  );

  Future<Message?> getMessage(String? id) async {
    if (id == null) return null;
    var message = await messageLocalRepo.getMessage(id);
    if (message == null) {
      message = await messageRemoteRepo.getMessage(id);
      if (message == null) return null;
      await messageLocalRepo.createMessage(message);
    }
    message.isMe = message.sourceUid == firebaseAuth.currentUser!.uid;
    return message;
  }

  Future<String> getRoomName(Room room) async {
    if (room.userIds.isEmpty) return "";
    final otherSideId =
        room.userIds.firstWhere((e) => e != firebaseAuth.currentUser!.uid);
    var otherSideUser = await userLocalRepo.getUser(otherSideId);
    if (otherSideUser == null) {
      otherSideUser = await userRemoteRepo.getUser(otherSideId);
      if (otherSideUser == null) return "";
      await userLocalRepo.createUser(otherSideUser);
    }
    return otherSideUser.name;
  }
}
