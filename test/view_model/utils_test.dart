import 'package:chat_app/model/message.dart';
import 'package:chat_app/model/room.dart';
import 'package:chat_app/model/user.dart' as user_model;
import 'package:chat_app/repo/message_repo.dart';
import 'package:chat_app/repo/user_repo.dart';
import 'package:chat_app/view_model/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([
  MockSpec<FirebaseAuth>(),
  MockSpec<MessageLocalRepo>(),
  MockSpec<MessageRemoteRepo>(),
  MockSpec<UserLocalRepo>(),
  MockSpec<UserRemoteRepo>(),
])
import 'utils_test.mocks.dart';

class FakeUser extends Fake implements User {
  final String _uid;

  FakeUser(String? uid) : _uid = uid ?? "uid";

  @override
  String get uid => _uid;
}

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();
  await Firebase.initializeApp();

  late Utils sut;

  late MockFirebaseAuth firebaseAuth;
  late MockMessageLocalRepo messageLocalRepo;
  late MockMessageRemoteRepo messageRemoteRepo;
  late MockUserLocalRepo userLocalRepo;
  late MockUserRemoteRepo userRemoteRepo;

  setUp(() {
    firebaseAuth = MockFirebaseAuth();
    messageLocalRepo = MockMessageLocalRepo();
    messageRemoteRepo = MockMessageRemoteRepo();
    userLocalRepo = MockUserLocalRepo();
    userRemoteRepo = MockUserRemoteRepo();
    sut = Utils.from(
      firebaseAuth,
      messageLocalRepo,
      messageRemoteRepo,
      userLocalRepo,
      userRemoteRepo,
    );
  });
  group("Get message:", () {
    late Message message;

    setUp(() {
      message = Message(
        id: "id",
        sourceUid: "uid",
        content: "Hello",
        createdTime: DateTime.now().toUtc(),
        updatedTime: DateTime.now().toUtc(),
      );
    });

    test("Id is null", () async {
      expect(await sut.getMessage(null), null);
    });

    test("Local data has already existed", () async {
      when(messageLocalRepo.getMessage("id")).thenAnswer((_) async => message);
      when(messageRemoteRepo.getMessage("id")).thenAnswer((_) async => message);
      when(messageLocalRepo.createMessage(message)).thenAnswer((_) async {});
      when(firebaseAuth.currentUser).thenReturn(FakeUser("uid"));
      var result = await sut.getMessage("id");
      expect(result, message);
      verify(messageLocalRepo.getMessage("id")).called(1);
      verifyNever(messageRemoteRepo.getMessage("id"));
      verifyNever(messageLocalRepo.createMessage(message));
    });

    test("Local data hasn't existed yet", () async {
      when(messageLocalRepo.getMessage("id")).thenAnswer((_) async => null);
      when(messageRemoteRepo.getMessage("id")).thenAnswer((_) async => message);
      when(messageLocalRepo.createMessage(message)).thenAnswer((_) async {});
      when(firebaseAuth.currentUser).thenReturn(FakeUser("uid"));
      var result = await sut.getMessage("id");
      expect(result, message);
      verify(messageLocalRepo.getMessage("id")).called(1);
      verify(messageRemoteRepo.getMessage("id")).called(1);
      verify(messageLocalRepo.createMessage(message)).called(1);
    });

    test("Check if `isMe` is correct", () async {
      when(messageLocalRepo.getMessage("id")).thenAnswer((_) async => message);
      when(firebaseAuth.currentUser).thenReturn(FakeUser("uid"));
      var result = await sut.getMessage("id");
      expect(result?.isMe, true);
      when(firebaseAuth.currentUser).thenReturn(FakeUser("uidx"));
      result = await sut.getMessage("id");
      expect(result?.isMe, false);
    });

    test("Message not found", () async {
      when(messageLocalRepo.getMessage("id")).thenAnswer((_) async => null);
      when(messageRemoteRepo.getMessage("id")).thenAnswer((_) async => null);
      when(firebaseAuth.currentUser).thenReturn(FakeUser("uid"));
      var result = await sut.getMessage("id");
      expect(result, null);
      verify(messageLocalRepo.getMessage("id")).called(1);
      verify(messageRemoteRepo.getMessage("id")).called(1);
      verifyNever(messageLocalRepo.createMessage(any));
    });
  });

  group("Get room name:", () {
    late Room room;
    late user_model.User user;

    setUp(() {
      room = Room(
        id: "id",
        userIds: ["uid1", "uid2"],
        messageIds: [],
        createdTime: DateTime.now().toUtc(),
        updatedTime: DateTime.now().toUtc(),
      );

      user = user_model.User(
        id: "uid1/2",
        name: "uid1/2",
        email: "email@example.com",
        createdTime: DateTime.now().toUtc(),
        updatedTime: DateTime.now().toUtc(),
      );
    });

    test("`userIds` is empty", () async {
      room.userIds = [];
      expect(await sut.getRoomName(room), "");
    });

    test("Local data has already existed", () async {
      when(firebaseAuth.currentUser).thenReturn(FakeUser("uid1"));
      when(userLocalRepo.getUser(any)).thenAnswer((_) async => user);
      await sut.getRoomName(room);
      verify(userLocalRepo.getUser(any)).called(1);
      verifyNever(userRemoteRepo.getUser(any));
    });

    test("Local data hasn't existed yet", () async {
      when(firebaseAuth.currentUser).thenReturn(FakeUser("uid1"));
      when(userLocalRepo.getUser(any)).thenAnswer((_) async => null);
      when(userRemoteRepo.getUser(any)).thenAnswer((_) async => user);
      await sut.getRoomName(room);
      verify(userLocalRepo.getUser(any)).called(1);
      verify(userRemoteRepo.getUser(any)).called(1);
      verify(userLocalRepo.createUser(user)).called(1);
    });

    test("Room name not found", () async {
      when(firebaseAuth.currentUser).thenReturn(FakeUser("uid1"));
      when(userLocalRepo.getUser(any)).thenAnswer((_) async => null);
      when(userRemoteRepo.getUser(any)).thenAnswer((_) async => null);
      final result = await sut.getRoomName(room);
      expect(result, "");
      verify(userLocalRepo.getUser(any)).called(1);
      verify(userRemoteRepo.getUser(any)).called(1);
      verifyNever(userLocalRepo.createUser(any));
    });

    test("Check if name is correct", () async {
      when(userLocalRepo.getUser(any)).thenAnswer((invocation) async => user
        ..id = invocation.positionalArguments[0]
        ..name = invocation.positionalArguments[0]);
      when(firebaseAuth.currentUser).thenReturn(FakeUser("uid1"));
      var result = await sut.getRoomName(room);
      expect(result, "uid2");
      when(firebaseAuth.currentUser).thenReturn(FakeUser("uid2"));
      result = await sut.getRoomName(room);
      expect(result, "uid1");
    });
  });
}
