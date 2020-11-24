// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result_json_job.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResultJobData _$ResultJobDataFromJson(Map<String, dynamic> json) {
  return ResultJobData(
    json['code'] as int,
    json['message'] as String,
    (json['data'] as List)
        ?.map((e) =>
            e == null ? null : JobData.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ResultJobDataToJson(ResultJobData instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };
