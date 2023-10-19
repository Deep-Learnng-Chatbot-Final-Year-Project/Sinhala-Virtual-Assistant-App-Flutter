import 'package:ai_assistant/controller/chatController.dart';
import 'package:ai_assistant/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../widgets/chat_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false;

  late TextEditingController textEditingController;
  late ScrollController _listScrollController;
  late FocusNode focusNode;

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  final chatController = Get.find<ChatController>();

  @override
  void initState() {
    _speech = stt.SpeechToText();
    _listScrollController = ScrollController();
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          Flexible(
            child: ListView.builder(
                controller: _listScrollController,
                itemCount: chatController.chatList.length,
                itemBuilder: (context, index) {
                  var chatMsg = chatController.chatList[index];
                  return Column(
                    children: [
                      ChatWidget(
                        msg: chatMsg.response, // chatList[index].msg,
                        chatIndex: index,
                        shouldAnimate: true,
                        question: chatMsg
                            .question, // chatProvider.getChatList.length - 1 == index
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  );
                }),
          ),
          if (_isTyping || _isListening) ...[
            const SpinKitThreeBounce(
              color: Colors.white,
              size: 18,
            ),
          ],
          const SizedBox(
            height: 15,
          ),
          Material(
            color: ColorPack.cardColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      focusNode: focusNode,
                      style: const TextStyle(color: Colors.white),
                      controller: textEditingController,
                      onSubmitted: (value) async {
                        if (value.isNotEmpty) {
                          setState(() {
                            _isTyping = true;
                          });
                          await chatController.sendMessage(value);
                          setState(() {
                            _isTyping = false;
                          });
                          textEditingController.clear();
                          _listScrollController.animateTo(
                              _listScrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut);
                        }
                      },
                      decoration: const InputDecoration.collapsed(
                          hintText: "ඔබට දැනගැනීමට අවශ්‍ය මොකක්ද ",
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 10)),
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        if (textEditingController.text.isNotEmpty) {
                          setState(() {
                            _isTyping = true;
                          });
                          await chatController
                              .sendMessage(textEditingController.text);
                          setState(() {
                            _isTyping = false;
                          });
                          textEditingController.clear();
                          _listScrollController.animateTo(
                              _listScrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut);
                        }
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      )),
                  GestureDetector(
                    onTapDown: (details) async {
                      if (!_isListening) {
                        bool available = await _speech.initialize(
                          onStatus: (val) => print('onStatus: $val'),
                          onError: (val) => print('onError: $val'),
                        );
                        setState(() {
                          _isListening = true;
                          print("user is Listening");
                        });
                        var locales = await _speech.locales();
                        var selectedLocale = locales.firstWhere(
                            (element) => element.localeId == 'si_LK');
                        _speech.listen(
                          localeId: selectedLocale.localeId,
                          onResult: (val) => setState(() {
                            print(val.finalResult);
                            _text = val.recognizedWords;
                            if (val.hasConfidenceRating &&
                                val.confidence > 0) {}
                          }),
                        );
                      }
                    },
                    onTapUp: (details) async {
                      await Future.delayed(const Duration(seconds: 1));
                      _speech.stop();
                      await chatController.sendMessage(_text);
                      setState(() {
                        _isListening = false;
                      });
                    },
                    child: CircleAvatar(
                        radius: 20,
                        backgroundColor: ColorPack.primaryColor,
                        child: Icon(
                          _isListening ? Icons.mic : Icons.mic_none,
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  void scrollListToEND() {
    _listScrollController.animateTo(
        _listScrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 2),
        curve: Curves.easeOut);
  }
}
