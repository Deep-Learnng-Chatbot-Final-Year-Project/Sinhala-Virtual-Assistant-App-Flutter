/// response : " මම විතරයි"

class ChatResponse {
  ChatResponse({
    required String response,
  }) : _response = response;

  ChatResponse.fromJson(dynamic json) : _response = json['response'];

  String _response;
  String? _question;

  ChatResponse copyWith({
    String? response,
  }) =>
      ChatResponse(
        response: response ?? _response,
      );

  set question(String question) => _question = question;

  String get response => _response;
  String get question => _question ?? '';

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['response'] = _response;
    return map;
  }
}
