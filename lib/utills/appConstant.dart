class AppConstant {
  static String chatApiAsk = "https://chat.enzy.live/chat/ask";
  // {"text": " ඔයා කවුද"}

  static String iotApi = "http://192.168.155.200";
  static String bulbOn = "iot-bulb-on";
  static String bulbOff = "iot-bulb-off";
  static String iotTempQuery = "iot-temp-query";
}

// POST request to endpoint: http://192.168.a.b/update with JSON body
//
//     {
// "parameter": "led",
// "value": "on"
// }
// Here the parameter could be:
//
// led
// and the value could be one of:
//
// on
// off
// Response will be: 200
//
// LED turned ON