// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result_json_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResultUserData _$ResultUserDataFromJson(Map<String, dynamic> json) {
  return ResultUserData(
    json['code'] as int,
    json['message'] as String,
    json['data'] == null
        ? null
        : UserData.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ResultUserDataToJson(ResultUserData instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };
