import 'package:chat_app/view/widget/message_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  group("Message tile:", () {
    testWidgets("Informations are shown", (widgetTester) async {
      final now = DateTime.now().toUtc();
      await widgetTester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: MessageTile(
            content: "Hello world",
            sendTime: now,
            isMe: true,
          ),
        ),
      ));

      expect(find.text("Hello world"), findsOneWidget);
      expect(
        find.text(DateFormat(DateFormat.HOUR24_MINUTE).format(now.toLocal())),
        findsOneWidget,
      );
    });
  });
}
