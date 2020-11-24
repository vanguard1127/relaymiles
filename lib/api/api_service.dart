import 'dart:collection';
import 'dart:convert';
import 'dart:io';



import 'package:relaymiles/model/result_json_data.dart';
import 'package:relaymiles/model/result_json_job.dart';
import 'package:relaymiles/model/result_json_user.dart';
import 'package:relaymiles/utils/constants.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:http_parser/http_parser.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:dio/dio.dart' hide Headers;



part 'api_service.g.dart';

@RestApi(baseUrl: Constants.API_BASE_URL)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  static ApiService create() {
    final dio = Dio();
    dio.interceptors.add(PrettyDioLogger());
    return ApiService(dio);
  }


  @POST(Constants.API_PATH_LOGIN)
  Future<ResultUserData> login(@Header("secret") String secret, @Body() Map<String, dynamic> map);

  @POST(Constants.API_PATH_SIGN_UP)
  Future<ResultJsonData> signup(@Header("secret") String secret, @Body() Map<String, dynamic> map);

  @POST(Constants.API_PATH_SEARCH_JOB)
  Future<ResultJobData> searchJob(@Header("secret") String secret, @Body() Map<String, dynamic> map);

  @POST(Constants.API_PATH_MY_JOBS)
  Future<ResultJobData> myJobs(@Header("secret") String secret, @Body() Map<String, dynamic> map);

  @POST(Constants.API_PATH_UPDATE_JOB)
  Future<ResultJobData> changeJobStatus(@Header("secret") String secret, @Body() Map<String, dynamic> map);

  @POST(Constants.API_PATH_UPLOAD_INVOICE)
  Future<ResultJsonData> uploadInvoice(@Part(value: "userId") String userId, @Part(value: "loadId") String loadId, @Part() File file);

  @POST(Constants.API_PATH_CHANGE_PASSWORD)
  Future<ResultJobData> changePassword(@Header("secret") String secret, @Body() Map<String, dynamic> map);

  @POST(Constants.API_PATH_CHANGE_PHOTO)
  Future<ResultJsonData> changeProfilePhoto(@Part(value: "userId") String userId, @Part() File file);

  @POST(Constants.API_PATH_LOAD_COMPLETE)
  Future<ResultJsonData> getLoadCompleteCnt(@Header("secret") String secret, @Body() Map<String, dynamic> map);

  @POST(Constants.API_PATH_RESET_PASSWORD)
  Future<ResultJsonData> resetPassword(@Header("secret") String secret, @Body() Map<String, dynamic> map);

  @POST(Constants.API_PATH_ADD_LOCATION)
  Future<ResultJsonData> addLocation(@Header("secret") String secret, @Body() Map<String, dynamic> map);
}
