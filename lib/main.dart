import 'dart:async';

import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/router/router.dart';
import 'package:chat_app/service/local_database.dart';
import 'package:chat_app/view_model/chat_list_page_view_model.dart';
import 'package:chat_app/view_model/chat_room_page_view_model.dart';
import 'package:chat_app/view_model/sign_in_page_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalDatabase.initialize();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignInPageViewModel()),
        ChangeNotifierProvider(create: (_) => ChatListPageViewModel()),
        ChangeNotifierProvider(create: (_) => ChatRoomPageViewModel()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: "Let's Chat",
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true,
        ),
        routerConfig: Router.routerConfig,
      ),
    );
  }
}
