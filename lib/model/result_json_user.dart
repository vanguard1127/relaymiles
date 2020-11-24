import 'package:json_annotation/json_annotation.dart';
import 'package:relaymiles/model/user_data.dart';


part 'result_json_user.g.dart';

@JsonSerializable()
class ResultUserData{

  @JsonKey(name: "code")
  int code;

  @JsonKey(name: "message")
  String message;

  @JsonKey(name: "data")
  UserData data;


  ResultUserData(
      this.code, this.message, this.data);

  factory ResultUserData.fromJson(Map<String, dynamic> json) =>
      _$ResultUserDataFromJson(json);
  Map<String, dynamic> toJson() => _$ResultUserDataToJson(this);
}