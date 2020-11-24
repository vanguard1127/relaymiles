// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result_json_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResultJsonData _$ResultJsonDataFromJson(Map<String, dynamic> json) {
  return ResultJsonData(
    json['code'] as int,
    json['message'] as String,
    json['data'],
  );
}

Map<String, dynamic> _$ResultJsonDataToJson(ResultJsonData instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };
