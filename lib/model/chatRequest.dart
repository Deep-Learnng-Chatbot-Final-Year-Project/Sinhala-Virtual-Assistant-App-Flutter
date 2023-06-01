/// text : " ඔයා කවුද"

class ChatRequest {
  ChatRequest({
    required String text,
  }) : _text = text;

  ChatRequest.fromJson(dynamic json) : _text = json['text'];

  String _text;

  ChatRequest copyWith({
    String? text,
  }) =>
      ChatRequest(
        text: text ?? _text,
      );

  String get text => _text;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['text'] = _text;
    return map;
  }
}