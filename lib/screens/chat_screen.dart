
import 'package:ai_assistant/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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

  // List<ChatModel> chatList = [];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: ListView.builder(
              controller: _listScrollController,
              itemCount: 5, //chatList.length,
              itemBuilder: (context, index) {
                return ChatWidget(
                    msg: "Hello", // chatList[index].msg,
                    chatIndex: index, //chatList[index].chatIndex,
                    shouldAnimate: true
                    // chatProvider.getChatList.length - 1 == index,
                    );
              }),
        ),
        if (_isTyping) ...[
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
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    focusNode: focusNode,
                    style: const TextStyle(color: Colors.white),
                    controller: textEditingController,
                    onSubmitted: (value) async {},
                    decoration: const InputDecoration.collapsed(
                        hintText: "How can I help you",
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                ),
                IconButton(
                    onPressed: () async {},
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
                      });
                      var locales = await _speech.locales();
                      var selectedLocale = locales
                          .firstWhere((element) => element.localeId == 'si_LK');
                      _speech.listen(
                        localeId: selectedLocale.localeId,
                        onResult: (val) => setState(() {
                          print(val.finalResult);
                          _text = val.recognizedWords;
                          if (val.hasConfidenceRating && val.confidence > 0) {
                          }
                        }),
                      );
                    }
                  },
                  onTapUp: (details) {
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
  }

  void scrollListToEND() {
    _listScrollController.animateTo(
        _listScrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 2),
        curve: Curves.easeOut);
  }
}

//   Future<void> sendMessageFCT(
//       {required ModelsProvider modelsProvider,
//         required ChatProvider chatProvider}) async {
//     if (_isTyping) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: TextWidget(
//             label: "You cant send multiple messages at a time",
//           ),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//     if (textEditingController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: TextWidget(
//             label: "Please type a message",
//           ),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//     try {
//       String msg = textEditingController.text;
//       setState(() {
//         _isTyping = true;
//         // chatList.add(ChatModel(msg: textEditingController.text, chatIndex: 0));
//         chatProvider.addUserMessage(msg: msg);
//         textEditingController.clear();
//         focusNode.unfocus();
//       });
//       await chatProvider.sendMessageAndGetAnswers(
//           msg: msg, chosenModelId: modelsProvider.getCurrentModel);
//       // chatList.addAll(await ApiService.sendMessage(
//       //   message: textEditingController.text,
//       //   modelId: modelsProvider.getCurrentModel,
//       // ));
//       setState(() {});
//     } catch (error) {
//       log("error $error");
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: TextWidget(
//           label: error.toString(),
//         ),
//         backgroundColor: Colors.red,
//       ));
//     } finally {
//       setState(() {
//         scrollListToEND();
//         _isTyping = false;
//       });
//     }
//   }
