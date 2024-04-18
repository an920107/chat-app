import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class OpenAiRepo {
  static final OpenAiRepo _instance = OpenAiRepo._internal();
  factory OpenAiRepo() => _instance;
  OpenAiRepo._internal() {
    _secret = dotenv.env["OPENAI_SECRET"] ?? "";
  }

  late final String _secret;
  final _authority = "api.openai.com";

  Future<String?> getReply(String content) async {
    final response = await http.post(
      Uri.https(_authority, "/v1/chat/completions"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $_secret",
      },
      body: json.encode({
        "model": "gpt-3.5-turbo",
        "temperature": 0.7,
        "messages": [
          {"role": "user", "content": content}
        ],
      }),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body)["choices"]?[0]["message"]["content"];
    } else {
      return null;
    }
  }
}
