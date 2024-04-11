import 'package:chat_app/router/routes.dart';
import 'package:chat_app/view/page/chat_page.dart';
import 'package:chat_app/view/page/home_page.dart';
import 'package:go_router/go_router.dart';

abstract class Router {
  static get routerConfig => GoRouter(
        initialLocation: Routes.root.path,
        routes: [
          GoRoute(
            path: Routes.chat.path,
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: "${Routes.chat.path}/:uid",
            builder: (context, state) => ChatPage(state.pathParameters["uid"]!),
          ),
        ],
      );
}
