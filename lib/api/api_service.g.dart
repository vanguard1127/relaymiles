// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _ApiService implements ApiService {
  _ApiService(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    this.baseUrl ??= 'https://relaymiles.com/';
  }

  final Dio _dio;

  String baseUrl;

  @override
  login(secret, map) async {
    ArgumentError.checkNotNull(secret, 'secret');
    ArgumentError.checkNotNull(map, 'map');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(map ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'apis/login',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{'secret': secret},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = ResultUserData.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  signup(secret, map) async {
    ArgumentError.checkNotNull(secret, 'secret');
    ArgumentError.checkNotNull(map, 'map');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(map ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'apis/register',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{'secret': secret},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = ResultJsonData.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  searchJob(secret, map) async {
    ArgumentError.checkNotNull(secret, 'secret');
    ArgumentError.checkNotNull(map, 'map');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(map ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'apis/search_job',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{'secret': secret},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = ResultJobData.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  myJobs(secret, map) async {
    ArgumentError.checkNotNull(secret, 'secret');
    ArgumentError.checkNotNull(map, 'map');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(map ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'apis/my_jobs',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{'secret': secret},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = ResultJobData.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  changeJobStatus(secret, map) async {
    ArgumentError.checkNotNull(secret, 'secret');
    ArgumentError.checkNotNull(map, 'map');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(map ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'apis/change_job_status',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{'secret': secret},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = ResultJobData.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  uploadInvoice(userId, loadId, file) async {
    ArgumentError.checkNotNull(userId, 'userId');
    ArgumentError.checkNotNull(loadId, 'loadId');
    ArgumentError.checkNotNull(file, 'file');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = FormData();
    if (userId != null) {
      _data.fields.add(MapEntry('userId', userId));
    }
    if (loadId != null) {
      _data.fields.add(MapEntry('loadId', loadId));
    }
    _data.files.add(MapEntry(
        'file',
        MultipartFile.fromFileSync(file.path,
            filename: file.path.split(Platform.pathSeparator).last)));
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'apis/upload_invoice',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = ResultJsonData.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  changePassword(secret, map) async {
    ArgumentError.checkNotNull(secret, 'secret');
    ArgumentError.checkNotNull(map, 'map');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(map ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'apis/update_password',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{'secret': secret},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = ResultJobData.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  changeProfilePhoto(userId, file) async {
    ArgumentError.checkNotNull(userId, 'userId');
    ArgumentError.checkNotNull(file, 'file');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = FormData();
    if (userId != null) {
      _data.fields.add(MapEntry('userId', userId));
    }
    _data.files.add(MapEntry(
        'file',
        MultipartFile.fromFileSync(file.path,
            filename: file.path.split(Platform.pathSeparator).last)));
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'apis/change_profile_photo',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = ResultJsonData.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  getLoadCompleteCnt(secret, map) async {
    ArgumentError.checkNotNull(secret, 'secret');
    ArgumentError.checkNotNull(map, 'map');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(map ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'apis/getLoadCompletedCount',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{'secret': secret},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = ResultJsonData.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  resetPassword(secret, map) async {
    ArgumentError.checkNotNull(secret, 'secret');
    ArgumentError.checkNotNull(map, 'map');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(map ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'apis/resetPassword',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{'secret': secret},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = ResultJsonData.fromJson(_result.data);
    return Future.value(value);
  }

  @override
  addLocation(secret, map) async {
    ArgumentError.checkNotNull(secret, 'secret');
    ArgumentError.checkNotNull(map, 'map');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(map ?? <String, dynamic>{});
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'apis/add_location',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{'secret': secret},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = ResultJsonData.fromJson(_result.data);
    return Future.value(value);
  }
}
