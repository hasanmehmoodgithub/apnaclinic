import 'package:dio/dio.dart';
import 'package:chucker_flutter/chucker_flutter.dart';
import '../di/dependency_injection.dart';
import '../preference/app_pref.dart';
import '../flavor/flavor_config.dart';
import '../utils/chucker_guard.dart';
import 'api_config.dart';
import 'api_logger_interceptor.dart';

/// Simple API Service with automatic token injection and logging
/// Base URL is automatically retrieved from FlavorConfig
class ApiService {
  final Dio _dio;
  final AppPref _appPref;

  ApiService({
    String? baseUrl,
    Duration? timeout,
    bool? enableLogging,
  }) : _appPref = sl<AppPref>(),
       _dio = Dio(
         BaseOptions(
           baseUrl: baseUrl ?? ApiConfig.baseUrl,
           connectTimeout: timeout ?? const Duration(seconds: 60),
           receiveTimeout: timeout ?? const Duration(seconds: 60),
           sendTimeout: timeout ?? const Duration(seconds: 60),
           headers: {
             'Content-Type': 'application/json',
             'Accept': 'application/json',
           },
         ),
       ) {
    // Add logger interceptor if enabled
    final shouldLog = enableLogging ?? FlavorConfig.enableLogging;
    if (shouldLog) {
      _dio.interceptors.add(ApiLoggerInterceptor());
    }
    if (ChuckerGuard.isEnabled) {
      _dio.interceptors.add(ChuckerDioInterceptor());
    }

    // Automatically load and set auth token
    _loadAndSetToken();
  }

  /// Load token from AppPref and set in headers
  void _loadAndSetToken() {
    try {
      final token = _appPref.getToken();
      if (token.isNotEmpty) {
        _dio.options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      // AppPref not initialized yet, skip
    }
  }

  /// Refresh token from AppPref (call after login/token update)
  void refreshToken() {
    _loadAndSetToken();
  }

  /// Remove token (call on logout)
  void removeToken() {
    _dio.options.headers.remove('Authorization');
  }

  /// GET request
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    try {
      // Refresh token for each request
      _loadAndSetToken();

      final response = await _dio.get<Map<String, dynamic>>(
        endpoint,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
          sendTimeout: timeout,
          receiveTimeout: timeout,
        ),
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// POST request
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    try {
      // Refresh token for each request
      _loadAndSetToken();

      final response = await _dio.post<Map<String, dynamic>>(
        endpoint,
        data: data,
        options: Options(
          headers: headers,
          sendTimeout: timeout,
          receiveTimeout: timeout,
        ),
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// PUT request
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    try {
      _loadAndSetToken();

      final response = await _dio.put<Map<String, dynamic>>(
        endpoint,
        data: data,
        options: Options(
          headers: headers,
          sendTimeout: timeout,
          receiveTimeout: timeout,
        ),
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// DELETE request
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    try {
      _loadAndSetToken();

      final response = await _dio.delete<Map<String, dynamic>>(
        endpoint,
        data: data,
        options: Options(
          headers: headers,
          sendTimeout: timeout,
          receiveTimeout: timeout,
        ),
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Handle response
  Map<String, dynamic> _handleResponse(
    Response<Map<String, dynamic>> response,
  ) {
    final statusCode = response.statusCode ?? 0;
    final responseData = response.data;

    // Success (200-299)
    if (statusCode >= 200 && statusCode < 300) {
      return responseData ?? {};
    }

    // Error response
    final errorMessage = _extractErrorMessage(responseData);
    throw ApiException(
      message: errorMessage,
      statusCode: statusCode,
      data: responseData,
    );
  }

  /// Extract error message from response
  String _extractErrorMessage(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      return responseData['message'] as String? ??
          responseData['error'] as String? ??
          'Request failed';
    }
    if (responseData is String) {
      return responseData;
    }
    return 'Request failed';
  }

  /// Handle DioException and convert to ApiException
  ApiException _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiTimeoutException(
          message: 'Request timeout. Please try again.',
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 0;
        final errorData = error.response?.data;
        final message = _extractErrorMessage(errorData);

        if (statusCode == 401) {
          return ApiUnauthorizedException(message: message);
        } else if (statusCode == 403) {
          return ApiForbiddenException(message: message);
        } else if (statusCode == 404) {
          return ApiNotFoundException(message: message);
        } else if (statusCode >= 500) {
          return ApiServerException(message: message, statusCode: statusCode);
        }

        return ApiException(message: message, statusCode: statusCode);
      case DioExceptionType.cancel:
        return ApiCancelledException(message: 'Request cancelled');
      case DioExceptionType.connectionError:
        return ApiNetworkException(
          message: 'No internet connection. Please check your network.',
        );
      case DioExceptionType.badCertificate:
        return ApiCertificateException(
          message: 'Certificate error. Please check your connection.',
        );
      case DioExceptionType.unknown:
        return ApiException(
          message: error.message ?? 'Unknown error occurred',
          statusCode: 0,
        );
    }
  }
}

/// Base API exception
class ApiException implements Exception {
  final String message;
  final int statusCode;
  final Map<String, dynamic>? data;

  ApiException({
    required this.message,
    required this.statusCode,
    this.data,
  });

  @override
  String toString() => message;
}

/// Network connection exception
class ApiNetworkException extends ApiException {
  ApiNetworkException({required super.message}) : super(statusCode: 0);
}

/// Timeout exception
class ApiTimeoutException extends ApiException {
  ApiTimeoutException({required super.message}) : super(statusCode: 0);
}

/// Unauthorized exception (401)
class ApiUnauthorizedException extends ApiException {
  ApiUnauthorizedException({required super.message}) : super(statusCode: 401);
}

/// Forbidden exception (403)
class ApiForbiddenException extends ApiException {
  ApiForbiddenException({required super.message}) : super(statusCode: 403);
}

/// Not found exception (404)
class ApiNotFoundException extends ApiException {
  ApiNotFoundException({required super.message}) : super(statusCode: 404);
}

/// Server exception (5xx)
class ApiServerException extends ApiException {
  ApiServerException({
    required super.message,
    required super.statusCode,
  });
}

/// Request cancelled exception
class ApiCancelledException extends ApiException {
  ApiCancelledException({required super.message}) : super(statusCode: 0);
}

/// Certificate exception
class ApiCertificateException extends ApiException {
  ApiCertificateException({required super.message}) : super(statusCode: 0);
}
