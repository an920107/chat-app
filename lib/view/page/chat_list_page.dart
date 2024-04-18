import 'package:chat_app/model/message.dart';
import 'package:chat_app/router/routes.dart';
import 'package:chat_app/view/widget/change_name_dialog.dart';
import 'package:chat_app/view/widget/chat_preview_tile.dart';
import 'package:chat_app/view/widget/user_search_dialog.dart';
import 'package:chat_app/view_model/chat_list_page_view_model.dart';
import 'package:chat_app/view_model/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatListPageViewModel>().fetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        // TODO: preference
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const Icon(Icons.menu),
          ),
        ),
        title: const Text("Let's Chat"),
        actions: [
          IconButton(
            onPressed: () async {
              final email = await showDialog<String?>(
                context: context,
                builder: (context) => const UserSearchDialog(),
              );
              if (!context.mounted || email == null) return;
              final errorMessage =
                  await context.read<ChatListPageViewModel>().addFriend(email);
              if (!context.mounted || errorMessage == null) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(errorMessage)),
              );
            },
            icon: const Icon(Icons.person_add),
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: Consumer<ChatListPageViewModel>(
        builder: (context, value, child) => Drawer(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                ),
                // TODO: user avatar
                currentAccountPicture: ClipOval(
                  child: Container(
                    color: Colors.grey,
                    child: const Icon(
                      Icons.person,
                      size: 64,
                    ),
                  ),
                ),
                accountName: Text(value.name),
                accountEmail: Text(value.email),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    ListTile(
                      onTap: () async {
                        final name = await showDialog(
                          context: context,
                          builder: (context) => ChangeNameDialog(value.name),
                        );
                        if (!context.mounted || name == null) return;
                        final errorMessage = await value.changeName(name);
                        if (!context.mounted || errorMessage == null) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(errorMessage)),
                        );
                      },
                      leading: const Icon(Icons.person),
                      title: const Text("Change Name"),
                    ),
                    const Divider(),
                    ListTile(
                      onTap: () async {
                        await value.signOut();
                        if (!context.mounted) return;
                        context.pushReplacement(Routes.root.path);
                      },
                      leading: const Icon(Icons.logout),
                      title: const Text("Sign Out"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Consumer<ChatListPageViewModel>(
        builder: (context, value, child) => ListView(
          children: value.rooms.map((room) {
            String? name;
            Message? message;
            final nameFuture = Utils().getRoomName(room);
            final messageFuture =
                Utils().getMessage(room.messageIds.lastOrNull);
            return FutureBuilder(
              future: Future.wait([
                nameFuture.then((value) => name = value),
                messageFuture.then((value) => message = value),
              ]),
              builder: (context, snapshot) => ChatPreviewTile(
                roomId: room.id,
                name: name ?? "",
                lastMessage: message?.content ?? "<No Message>",
                lastTime: room.updatedTime,
                unread: room.unread.length,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
