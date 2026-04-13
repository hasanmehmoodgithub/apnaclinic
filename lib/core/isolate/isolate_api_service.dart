import 'dart:async';
import 'dart:isolate';
import 'package:dio/dio.dart';

/// Service for calling APIs in isolates to keep UI responsive
class IsolateApiService {
  IsolateApiService._();

  /// Call GET API in isolate
  static Future<Map<String, dynamic>> get(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    Duration? timeout,
  }) async {
    return await _callInIsolate(
      'GET',
      url,
      headers: headers,
      queryParameters: queryParameters,
      timeout: timeout,
    );
  }

  /// Call POST API in isolate
  static Future<Map<String, dynamic>> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    Duration? timeout,
  }) async {
    return await _callInIsolate(
      'POST',
      url,
      data: data,
      headers: headers,
      queryParameters: queryParameters,
      timeout: timeout,
    );
  }

  /// Call PUT API in isolate
  static Future<Map<String, dynamic>> put(
    String url, {
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    Duration? timeout,
  }) async {
    return await _callInIsolate(
      'PUT',
      url,
      data: data,
      headers: headers,
      queryParameters: queryParameters,
      timeout: timeout,
    );
  }

  /// Call DELETE API in isolate
  static Future<Map<String, dynamic>> delete(
    String url, {
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    Duration? timeout,
  }) async {
    return await _callInIsolate(
      'DELETE',
      url,
      data: data,
      headers: headers,
      queryParameters: queryParameters,
      timeout: timeout,
    );
  }

  /// Call API in isolate
  static Future<Map<String, dynamic>> _callInIsolate(
    String method,
    String url, {
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    Duration? timeout,
  }) async {
    final receivePort = ReceivePort();
    Isolate? isolate;

    try {
      isolate = await Isolate.spawn(
        _apiCall,
        {
          'method': method,
          'url': url,
          'data': data,
          'headers': headers,
          'queryParameters': queryParameters,
          'timeout': timeout?.inSeconds,
          'sendPort': receivePort.sendPort,
        },
      );

      final result = await (timeout != null
              ? receivePort.first.timeout(timeout)
              : receivePort.first) as Map<String, dynamic>;

      return result;
    } on TimeoutException {
      isolate?.kill(priority: Isolate.immediate);
      return {
        'success': false,
        'error': 'Request timeout',
        'statusCode': 408,
      };
    } catch (e) {
      isolate?.kill(priority: Isolate.immediate);
      return {
        'success': false,
        'error': e.toString(),
        'statusCode': 500,
      };
    } finally {
      receivePort.close();
    }
  }

  /// API call function (runs in isolate)
  /// Must be static or top-level function
  static Future<void> _apiCall(Map<String, dynamic> params) async {
    final sendPort = params['sendPort'] as SendPort;
    final method = params['method'] as String;
    final url = params['url'] as String;
    final data = params['data'];
    final headers = params['headers'] as Map<String, dynamic>?;
    final queryParameters = params['queryParameters'] as Map<String, dynamic>?;
    final timeoutSeconds = params['timeout'] as int?;

    try {
      final dio = Dio();
      
      if (timeoutSeconds != null) {
        dio.options.connectTimeout = Duration(seconds: timeoutSeconds);
        dio.options.receiveTimeout = Duration(seconds: timeoutSeconds);
      }

      Response response;
      switch (method.toUpperCase()) {
        case 'GET':
          response = await dio.get(
            url,
            queryParameters: queryParameters,
            options: Options(headers: headers),
          );
          break;
        case 'POST':
          response = await dio.post(
            url,
            data: data,
            queryParameters: queryParameters,
            options: Options(headers: headers),
          );
          break;
        case 'PUT':
          response = await dio.put(
            url,
            data: data,
            queryParameters: queryParameters,
            options: Options(headers: headers),
          );
          break;
        case 'DELETE':
          response = await dio.delete(
            url,
            data: data,
            queryParameters: queryParameters,
            options: Options(headers: headers),
          );
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }

      sendPort.send({
        'success': true,
        'data': response.data,
        'statusCode': response.statusCode,
        'headers': response.headers.map,
      });
    } catch (e) {
      String errorMessage = 'Unknown error';
      int? statusCode;

      if (e is DioException) {
        errorMessage = e.message ?? e.toString();
        statusCode = e.response?.statusCode;
      } else {
        errorMessage = e.toString();
      }

      sendPort.send({
        'success': false,
        'error': errorMessage,
        'statusCode': statusCode ?? 500,
      });
    }
  }
}
