import 'dart:convert';

import 'package:ai_assistant/model/chatRequest.dart';
import 'package:ai_assistant/model/chatResponse.dart';
import 'package:ai_assistant/utills/appConstant.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ChatService {
  Future<ChatResponse?> getChat(String question) async {
    try {
      var response = await http.post(
        Uri.parse(AppConstant.chatApiAsk),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: json.encode(ChatRequest(text: question).toJson()),
      );
      if (response.statusCode == 200) {
        ChatResponse chatResponse =
            ChatResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
        chatResponse.question = question;
        return chatResponse;
      } else {
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }
}
