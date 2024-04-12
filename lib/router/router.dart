import 'package:chat_app/router/routes.dart';
import 'package:chat_app/view/page/chat_room_page.dart';
import 'package:chat_app/view/page/chat_list_page.dart';
import 'package:go_router/go_router.dart';

abstract class Router {
  static get routerConfig => GoRouter(
        initialLocation: Routes.root.path,
        routes: [
          GoRoute(
            path: Routes.root.path,
            redirect: (context, state) => Routes.chat.path,
          ),
          GoRoute(
            path: Routes.chat.path,
            builder: (context, state) => const ChatListPage(),
          ),
          GoRoute(
            path: "${Routes.chat.path}/:room_id",
            builder: (context, state) => ChatRoomPage(state.pathParameters["room_id"]!),
          ),
        ],
      );
}
