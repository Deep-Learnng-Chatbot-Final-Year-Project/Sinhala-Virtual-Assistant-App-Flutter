import 'package:ai_assistant/model/chatResponse.dart';
import 'package:get/get.dart';

import '../services/chatService.dart';

class ChatController extends GetxController {
  final ChatService chatService = ChatService();
  var chatList = <ChatResponse>[].obs;

  sendMessage(String value) async {
    await chatService.getChat(value).then((response) {
      if (response != null) {
        chatList.add(response);
      }
    });
  }
}
