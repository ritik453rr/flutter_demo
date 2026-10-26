import 'package:demo/core/storage/app_storage.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

/// Interceptor that handles authorization headers and console logging for API calls.
class ApiInterceptor extends Interceptor {
  final Logger _logger = Logger(printer: PrettyPrinter(methodCount: 0));

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = AppStorage.getAuthToken();
    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    _logger.i('--> ${options.method.toUpperCase()} ${options.uri}');
    _logger.d('Headers: ${options.headers}');
    if (options.data != null) {
      _logger.d('Body: ${options.data}');
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.i('<-- ${response.statusCode} ${response.requestOptions.uri}');
    _logger.d('Response Data: ${response.data}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.e(
      '<-- ERROR ${err.response?.statusCode} ${err.requestOptions.uri}',
      error: err.error,
      stackTrace: err.stackTrace,
    );
    if (err.response != null) {
      _logger.e('Error Data: ${err.response?.data}');
    }
    handler.next(err);
  }
}
