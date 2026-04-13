import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Logger interceptor for API calls
class ApiLoggerInterceptor extends Interceptor {
  final Logger _logger;

  ApiLoggerInterceptor()
    : _logger = Logger(
        printer: PrettyPrinter(
          methodCount: 0,
          errorMethodCount: 8,
          lineLength: 120,
          colors: true,
          printEmojis: true,
          dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
        ),
      );

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      _logger.d(
        '┌─────────────────────────────────────────────────────────────',
      );
      _logger.d('│ REQUEST');
      _logger.d(
        '├─────────────────────────────────────────────────────────────',
      );
      _logger.d('│ ${options.method} ${options.uri}');
      _logger.d('│ Headers: ${options.headers}');
      if (options.queryParameters.isNotEmpty) {
        _logger.d('│ Query Parameters: ${options.queryParameters}');
      }
      if (options.data != null) {
        _logger.d('│ Body: ${options.data}');
      }
      _logger.d(
        '└─────────────────────────────────────────────────────────────',
      );
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      final statusCode = response.statusCode ?? 0;
      final statusEmoji = _getStatusEmoji(statusCode);

      _logger.i(
        '┌─────────────────────────────────────────────────────────────',
      );
      _logger.i('│ RESPONSE $statusEmoji');
      _logger.i(
        '├─────────────────────────────────────────────────────────────',
      );
      _logger.i(
        '│ ${response.requestOptions.method} ${response.requestOptions.uri}',
      );
      _logger.i('│ Status Code: $statusCode');
      _logger.i('│ Headers: ${response.headers.map}');
      if (response.data != null) {
        _logger.i('│ Data: ${response.data}');
      }
      _logger.i(
        '└─────────────────────────────────────────────────────────────',
      );
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      _logger.e(
        '┌─────────────────────────────────────────────────────────────',
      );
      _logger.e('│ ERROR ❌');
      _logger.e(
        '├─────────────────────────────────────────────────────────────',
      );
      _logger.e('│ ${err.requestOptions.method} ${err.requestOptions.uri}');
      _logger.e('│ Error Type: ${err.type}');
      _logger.e('│ Status Code: ${err.response?.statusCode ?? 'N/A'}');
      _logger.e('│ Message: ${err.message}');
      if (err.response?.data != null) {
        _logger.e('│ Error Data: ${err.response?.data}');
      }
      _logger.e('│ Stack Trace: ${err.stackTrace}');
      _logger.e(
        '└─────────────────────────────────────────────────────────────',
      );
    }
    super.onError(err, handler);
  }

  String _getStatusEmoji(int statusCode) {
    if (statusCode >= 200 && statusCode < 300) {
      return '✅';
    } else if (statusCode >= 300 && statusCode < 400) {
      return '🔄';
    } else if (statusCode >= 400 && statusCode < 500) {
      return '⚠️';
    } else if (statusCode >= 500) {
      return '❌';
    }
    return '❓';
  }
}
