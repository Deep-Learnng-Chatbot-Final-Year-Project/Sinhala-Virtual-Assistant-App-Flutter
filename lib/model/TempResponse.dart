/// parameter : "temp"
/// value : 27

class TempResponse {
  TempResponse({
      String? parameter, 
      num? value,}){
    _parameter = parameter;
    _value = value;
}

  TempResponse.fromJson(dynamic json) {
    _parameter = json['parameter'];
    _value = json['value'];
  }
  String? _parameter;
  num? _value;
TempResponse copyWith({  String? parameter,
  num? value,
}) => TempResponse(  parameter: parameter ?? _parameter,
  value: value ?? _value,
);
  String? get parameter => _parameter;
  num? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['parameter'] = _parameter;
    map['value'] = _value;
    return map;
  }

}