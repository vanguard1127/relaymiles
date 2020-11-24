import 'package:json_annotation/json_annotation.dart';
import 'package:relaymiles/model/job_data.dart';
import 'package:relaymiles/model/user_data.dart';


part 'result_json_job.g.dart';

@JsonSerializable()
class ResultJobData{

  @JsonKey(name: "code")
  int code;

  @JsonKey(name: "message")
  String message;

  @JsonKey(name: "data")
  List<JobData> data;


  ResultJobData(
      this.code, this.message, this.data);

  factory ResultJobData.fromJson(Map<String, dynamic> json) =>
      _$ResultJobDataFromJson(json);
  Map<String, dynamic> toJson() => _$ResultJobDataToJson(this);
}