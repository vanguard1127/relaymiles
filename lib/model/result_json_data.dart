import 'package:json_annotation/json_annotation.dart';


part 'result_json_data.g.dart';

@JsonSerializable()
class ResultJsonData{

  @JsonKey(name: "code")
  int code;

  @JsonKey(name: "message")
  String message;

  @JsonKey(name: "data")
  dynamic data;


  ResultJsonData(
      this.code, this.message, this.data);

  factory ResultJsonData.fromJson(Map<String, dynamic> json) =>
      _$ResultJsonDataFromJson(json);
  Map<String, dynamic> toJson() => _$ResultJsonDataToJson(this);
}