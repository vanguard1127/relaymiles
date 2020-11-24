import 'package:json_annotation/json_annotation.dart';


part 'user_data.g.dart';
@JsonSerializable()
class UserData{

  @JsonKey(name: "first_name")
  String firstName;
  @JsonKey(name: "last_name")
  String lastName;


  @JsonKey(name: "dot")
  String dotNumber;
  @JsonKey(name: "mc")
  String mcNumber;
  @JsonKey(name: "created_at")
  String createdAt;

  @JsonKey(name: "photo")
  String profileImg;
  @JsonKey(name: "phone")
  String phoneNumber;
  @JsonKey(name: "email")
  String email;

  @JsonKey(name: "user_entity_id")
  String id;
  @JsonKey(name: "entity_id")
  String encrypt_id;

  double reviews = 1.0;
  @JsonKey(name: "load_completed")
  String loadCompleted;

  UserData();

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
  Map<String, dynamic> toJson() => _$UserDataToJson(this);

}