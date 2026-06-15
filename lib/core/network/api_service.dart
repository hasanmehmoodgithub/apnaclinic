import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:dio/dio.dart';

import '../di/dependency_injection.dart';
import '../flavor/flavor_config.dart';
import '../preference/app_pref.dart';
import '../utils/api_error_message_utils.dart';
import '../utils/chucker_guard.dart';
import 'api_exceptions.dart';
import 'api_logger_interceptor.dart';
import 'auth_interceptor.dart';
import 'device_headers_provider.dart';
import 'dio_app_network_config.dart';
import 'header_interceptor.dart';

export 'api_exceptions.dart';

/// Dio wrapper: JSON defaults, [AuthInterceptor], optional logging/Chucker.
/// See `API_SERVICE.md` in this folder for behavior and extension points.
class ApiService {
  ApiService({String? baseUrl, Duration? timeout, bool? enableLogging})
    : _appPref = sl<AppPref>(),
      _deviceHeadersProvider = sl<DeviceHeadersProvider>(),
      _dio = Dio(
        BaseOptions(
          //baseUrl: baseUrl ?? ApiConfig.baseUrl,
          connectTimeout: timeout ?? const Duration(seconds: 60),
          receiveTimeout: timeout ?? const Duration(seconds: 60),
          sendTimeout: timeout ?? const Duration(seconds: 60),
          headers: const {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      ) {
    configureDioForAppNetwork(_dio);
    _dio.interceptors.add(
      HeaderInterceptor(
        deviceHeadersProvider: _deviceHeadersProvider,
        appPref: _appPref,
      ),
    );
    _dio.interceptors.add(
      AuthInterceptor(
        dio: _dio,
        appPref: _appPref,
        deviceHeadersProvider: _deviceHeadersProvider,
      ),
    );
    if (enableLogging ?? FlavorConfig.enableLogging) {
      _dio.interceptors.add(ApiLoggerInterceptor());
    }
    if (ChuckerGuard.isEnabled) {
      _dio.interceptors.add(ChuckerDioInterceptor());
    }
    _syncAuthHeader();
  }

  final Dio _dio;
  final AppPref _appPref;
  final DeviceHeadersProvider _deviceHeadersProvider;

  void _syncAuthHeader() {
    try {
      final token = _appPref.getToken();
      if (token.isNotEmpty) {
        _dio.options.headers['Authorization'] = 'Bearer $token';
      } else {
        _dio.options.headers.remove('Authorization');
      }
    } catch (_) {}
  }

  /// Re-read token from prefs into Dio default headers (after login / refresh).
  void refreshToken() => _syncAuthHeader();

  void removeToken() => _dio.options.headers.remove('Authorization');

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Duration? timeout,
  }) {
    return _send(
      'GET',
      endpoint,
      queryParameters: queryParameters,
      headers: headers,
      timeout: timeout,
    );
  }

  Future<Map<String, dynamic>> post(
    String endpoint, {
    dynamic data,
    Map<String, String>? headers,
    Duration? timeout,
  }) {
    return _send(
      'POST',
      endpoint,
      data: data,
      headers: headers,
      timeout: timeout,
    );
  }

  Future<Map<String, dynamic>> put(
    String endpoint, {
    dynamic data,
    Map<String, String>? headers,
    Duration? timeout,
  }) {
    return _send(
      'PUT',
      endpoint,
      data: data,
      headers: headers,
      timeout: timeout,
    );
  }

  Future<Map<String, dynamic>> patch(
    String endpoint, {
    dynamic data,
    Map<String, String>? headers,
    Duration? timeout,
  }) {
    return _send(
      'PATCH',
      endpoint,
      data: data,
      headers: headers,
      timeout: timeout,
    );
  }

  Future<Map<String, dynamic>> delete(
    String endpoint, {
    dynamic data,
    Map<String, String>? headers,
    Duration? timeout,
  }) {
    if (data != null) {
      return _send(
        'DELETE',
        endpoint,
        data: data,
        headers: headers,
        timeout: timeout,
      );
    }

    return _sendWithoutBody(
      'DELETE',
      endpoint,
      headers: headers,
      timeout: timeout,
    );
  }

  /// Bodyless requests must not send `Content-Type: application/json` from defaults.
  Future<Map<String, dynamic>> _sendWithoutBody(
    String method,
    String endpoint, {
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    try {
      _syncAuthHeader();
      final requestHeaders = Map<String, dynamic>.from(_dio.options.headers);
      requestHeaders.removeWhere((key, _) => key.toLowerCase() == 'content-type');
      if (headers != null) {
        requestHeaders.addAll(headers);
      }

      final requestOptions = RequestOptions(
        path: endpoint,
        method: method,
        headers: requestHeaders,
        contentType: null,
        sendTimeout: timeout,
        receiveTimeout: timeout,
        responseType: ResponseType.json,
      );
      requestOptions.contentType = null;

      final response = await _dio.fetch<Map<String, dynamic>>(requestOptions);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<Map<String, dynamic>> _send(
    String method,
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    try {
      _syncAuthHeader();
      final response = await _dio.request<Map<String, dynamic>>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          method: method,
          headers: headers,
          sendTimeout: timeout,
          receiveTimeout: timeout,
        ),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Map<String, dynamic> _handleResponse(
    Response<Map<String, dynamic>> response,
  ) {
    final code = response.statusCode ?? 0;
    final body = response.data;
    if (code >= 200 && code < 300) {
      return body ?? {};
    }
    Map<String, dynamic>? asMap;
    if (body is Map) {
      asMap = Map<String, dynamic>.from(body as Map);
    }
    throw ApiException(
      message: ApiErrorMessageUtils.parseOrDefault(body),
      statusCode: code,
      data: asMap,
    );
  }

  ApiException _mapDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiTimeoutException(
          message: 'Request timeout. Please try again.',
        );
      case DioExceptionType.badResponse:
        final code = error.response?.statusCode ?? 0;
        final body = error.response?.data;
        final message = ApiErrorMessageUtils.parseOrDefault(body);
        if (code == 401) return ApiUnauthorizedException(message: message);
        if (code == 403) return ApiForbiddenException(message: message);
        if (code == 404) return ApiNotFoundException(message: message);
        if (code >= 500) {
          return ApiServerException(message: message, statusCode: code);
        }
        return ApiException(message: message, statusCode: code);
      case DioExceptionType.cancel:
        return ApiCancelledException(message: 'Request cancelled');
      case DioExceptionType.connectionError:
        return ApiNetworkException(
          message:
              'Unable to reach the server. Check your internet or VPN, then try again.',
        );
      case DioExceptionType.badCertificate:
        return ApiCertificateException(
          message:
              'Secure connection failed. Use a trusted network or contact support.',
        );
      case DioExceptionType.unknown:
        return ApiException(
          message: error.message ?? 'Unknown error occurred',
          statusCode: 0,
        );
    }
  }
}
