/// response : " මම විතරයි"

class ChatResponse {
  ChatResponse({
    required String response,
  }) : _response = response;

  ChatResponse.fromJson(dynamic json) : _response = json['response'];

  String _response;

  ChatResponse copyWith({
    String? response,
  }) =>
      ChatResponse(
        response: response ?? _response,
      );

  String get response => _response;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['response'] = _response;
    return map;
  }
}