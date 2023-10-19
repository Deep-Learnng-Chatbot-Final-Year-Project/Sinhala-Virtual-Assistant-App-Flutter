/// parameter : "led"
/// value : "on"

class IotRequest {
  IotRequest({
      required this.parameter,
      required this.value,});

  String parameter;
  String value;
IotRequest copyWith({  required String parameter,
  required String value,
}) => IotRequest(  parameter: parameter,
  value: value,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['parameter'] = parameter;
    map['value'] = value;
    return map;
  }

}

class IotTempRequest {
  IotTempRequest({
    required this.parameter});

  String parameter;
  IotTempRequest copyWith({  required String parameter,
  }) => IotTempRequest(  parameter: parameter,
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['parameter'] = parameter;
    return map;
  }

}