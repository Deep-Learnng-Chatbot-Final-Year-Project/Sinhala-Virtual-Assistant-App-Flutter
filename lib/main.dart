import 'package:ai_assistant/screens/chat_screen.dart';
import 'package:ai_assistant/theme/colors.dart';
import 'package:ai_assistant/utills/appConstant.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'controller/appBinding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '',
      initialBinding: AppBinding(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: ColorPack.backgroundColor,
          appBarTheme: const AppBarTheme(
            color: ColorPack.cardColor,
          )),
      home: const SpeechScreen(),
    );
  }
}

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({Key? key}) : super(key: key);

  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: const Padding(
          padding: EdgeInsets.all(6.0),
        ),
        title: const Center(child: Text('Virtual Assistant')),
        actions: [
          PopupMenuButton(onSelected: (value) {
            setState(() {
                if(value == 'addIp'){
                  _showAddIpAddressDialog(context);
                }
            });
            print(value);
            Navigator.pushNamed(context, value.toString());
          }, itemBuilder: (BuildContext bc) {
            return const [
              PopupMenuItem(
                child: Text("Add Ip Address"),
                value: 'addIp',
              ),

            ];
          })
        ],
      ),
      body: Container(

        child: const ChatScreen(),
      ),
    );
  }

  Future<void> _saveIpAddress(String ipAddress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ipAddress', ipAddress);
    AppConstant.iotApi = ipAddress;
  }

  void _showAddIpAddressDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        String ipAddress = '';

        return AlertDialog(
          title: Text('Add IP Address'),
          content: TextField(
            onChanged: (value) {
              ipAddress = value;

            },
            decoration: InputDecoration(labelText: 'IP Address'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                // Handle the IP address that the user entered (ipAddress)
                print('IP Address: $ipAddress');
                _saveIpAddress(ipAddress);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        var locales = await _speech.locales();
        var selectedLocale =
            locales.firstWhere((element) => element.localeId == 'si_LK');
        print(selectedLocale.name);
        _speech.listen(
          localeId: selectedLocale.localeId,
          onResult: (val) => setState(() {
            print(val.finalResult);
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
}
