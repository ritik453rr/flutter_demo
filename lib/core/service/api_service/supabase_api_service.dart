import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import '../../constants/app_keys.dart';
import '../../global/global.dart';
import 'api_interceptor.dart';
import 'api_response_model.dart';

class SupabaseApiService {
  // ---- Singleton Setup ----
  SupabaseApiService._internal() {
    dio.options.baseUrl = AppKeys.supabaseUrl;
    dio.options.headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "apikey": AppKeys.supabaseAnonKey,
    };
    dio.interceptors.add(ApiInterceptor());
  }

  static final SupabaseApiService _instance = SupabaseApiService._internal();

  // Public factory -> always same instance
  factory SupabaseApiService() => _instance;

  // ---- Single Dio Instance ----
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: AppKeys.supabaseUrl,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "apikey": AppKeys.supabaseAnonKey,
      },
    ),
  );

  /// Helper to handle response status consistently
  ApiResponseModel _handleResponse(Response response, dynamic model) {
    final dynamic responseData = response.data;
    final bool isSuccess =
        (response.statusCode == 200 || response.statusCode == 201);

    if (isSuccess) {
      final successMsg = responseData is Map
          ? (responseData['message'] ?? responseData['msg'] ?? "")
          : "";
      return ApiResponseModel(
        status: true,
        data: model != null ? model(jsonEncode(responseData)) : responseData,
        message: successMsg,
      );
    } else {
      final errorMsg = responseData is Map
          ? (responseData['error_description'] ??
                responseData['message'] ??
                responseData['msg'] ??
                "Something went wrong")
          : "Something went wrong";
      return ApiResponseModel(message: errorMsg);
    }
  }

  ApiResponseModel _handleDioError(DioException e) {
    if (CancelToken.isCancel(e)) {
      return ApiResponseModel();
    }
    if (e.response != null) {
      final data = e.response!.data;
      final errorMsg = data is Map
          ? (data["error_description"] ??
                data["message"] ??
                data["msg"] ??
                "Something went wrong")
          : "Something went wrong";
      return ApiResponseModel(message: errorMsg);
    } else {
      return ApiResponseModel(message: "Something went wrong");
    }
  }

  Future<ApiResponseModel> postRequest({
    required String endpoint,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Options? options,
    File? file,
    String? fileKey = 'file',
    dynamic model,
  }) async {
    if (!await Global.checkInternet()) {
      return ApiResponseModel();
    }
    try {
      dio.options.baseUrl = AppKeys.supabaseUrl;
      dio.options.headers['apikey'] = AppKeys.supabaseAnonKey;

      dynamic payload = body;
      if (file != null) {
        final fileName = file.path.split('/').last;
        final Map<String, dynamic> mapData = {
          ...?body,
          fileKey ?? 'file': await MultipartFile.fromFile(
            file.path,
            filename: fileName,
          ),
        };
        payload = FormData.fromMap(mapData);
      }
      final response = await dio.post(
        endpoint,
        data: payload,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse(response, model);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponseModel(message: e.toString());
    }
  }

  Future<ApiResponseModel> getRequest({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    dynamic model,
  }) async {
    if (!await Global.checkInternet()) {
      return ApiResponseModel();
    }
    try {
      dio.options.baseUrl = AppKeys.supabaseUrl;
      dio.options.headers['apikey'] = AppKeys.supabaseAnonKey;

      final response = await dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return _handleResponse(response, model);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponseModel(message: e.toString());
    }
  }
}
