import 'dart:convert';

import 'package:ai_assistant/model/IotRequest.dart';
import 'package:ai_assistant/model/TempResponse.dart';
import 'package:ai_assistant/model/chatResponse.dart';
import 'package:ai_assistant/utills/appConstant.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../services/chatService.dart';

class ChatController extends GetxController {
  final ChatService chatService = ChatService();
  var chatList = <ChatResponse>[].obs;
  var savedIpAddress = '';

  @override
  void onInit() {
    _loadIpAddress();
    super.onInit();
  }

  Future<void> _loadIpAddress() async {
    final prefs = await SharedPreferences.getInstance();
    savedIpAddress = prefs.getString('ipAddress') ?? '';
    if (savedIpAddress.isNotEmpty) {
      AppConstant.iotApi = savedIpAddress;
    }
    print(AppConstant.iotApi);
  }

  sendMessage(String value) async {
    await chatService.getChat(value).then((response) {
      if (response != null) {
        var message = response.response;
        if (message.contains("<")) {
          print(message);
         wakeIot2Device(message, response.question);
        } else {
          chatList.add(response);
        }
      }
    });
  }
  wakeIotDevice(String message, String question) async {
    if (message.contains(AppConstant.bulbOn)) {
      var TotJsonBody = IotRequest(parameter: "led", value: "on").toJson();
      print(TotJsonBody);
      print(question);
      String url = "${AppConstant.iotApi}/update" ;
      print(url);

      var response = await http.post(
                  Uri.parse(url),
                  headers: {
                    "Accept": "application/json",
                    "content-type": "application/json"
                  },
                  body: json.encode(IotRequest(parameter: "led", value: "on").toJson()),
                );
      print(response);
    }
    }


  wakeIot2Device(String message, String question) async {
    if (message.contains(AppConstant.bulbOn)) {
      print(message);
      try{
        String url = "${AppConstant.iotApi}/update" ;
        var response = await http.post(
          Uri.parse(url),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json"
          },
          body: json.encode(IotRequest(parameter: "led", value: "on").toJson()),
        );
        print("Response: ${response.statusCode}");
        if (response.statusCode == 200) {
          chatList
              .add(ChatResponse(response: "බල්බය දැල්වුනා", question: question));
        } else {
          chatList.add(ChatResponse(
              response: "ඔබගේ උත්සාහය අසාර්ථකයි", question: question));
        }
      }catch (e){
        print(e);
      }

    } else if (message.contains(AppConstant.bulbOff)) {
      var response = await http.post(
        Uri.parse("${AppConstant.iotApi}/fetch"),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: json.encode(IotRequest(parameter: "led", value: "off")),
      );

      if (response.statusCode == 200) {
        chatList.add(ChatResponse(
            response: "බල්බය ක්‍රියාත්මක කරා", question: question));
      } else {
        chatList.add(ChatResponse(
            response: "ඔබගේ උත්සාහය අසාර්ථකයි", question: question));
      }
    } else if (message.contains(AppConstant.iotTempQuery)) {
      var response = await http.post(
        Uri.parse("${AppConstant.iotApi}/fetch"),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: json.encode(IotTempRequest(
          parameter: "temp",
        )),
      );
      var tempResponse = TempResponse.fromJson(response.body);
      if (response.statusCode == 200) {
        chatList.add(ChatResponse(
            response: "${tempResponse.value}°C", question: question));
      } else {
        chatList.add(ChatResponse(
            response: "ඔබගේ උත්සාහය අසාර්ථකයි", question: question));
      }
    }
  }

  clearChatList() {
    chatList.clear();
    update();
  }
}
