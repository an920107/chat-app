import 'package:chat_app/view/widget/chat_preview_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  group("Chat preview tile:", () {
    testWidgets("Informations are shown", (tester) async {
      final now = DateTime.now().toUtc();
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ChatPreviewTile(
            roomId: "roomId",
            name: "name",
            lastMessage: "lastMessage",
            lastTime: now,
            unread: 0,
          ),
        ),
      ));

      expect(find.text("name"), findsOneWidget);
      expect(find.text("lastMessage"), findsOneWidget);
      expect(
        find.textContaining(
            DateFormat(DateFormat.HOUR24_MINUTE).format(now.toLocal())),
        findsOneWidget,
      );
    });
  });
}
