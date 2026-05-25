import 'dart:async';

import 'package:dio/dio.dart';

import '../preference/app_pref.dart';
import 'app_urls.dart';
import 'device_headers_provider.dart';
import 'dio_app_network_config.dart';

/// Handles automatic access token refresh on 401 responses.
///
/// Uses single-flight refresh so concurrent 401 responses trigger only one
/// refresh request, then all failed requests are retried with the new token.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required Dio dio,
    required AppPref appPref,
    required DeviceHeadersProvider deviceHeadersProvider,
  }) : _dio = dio,
       _appPref = appPref,
       _deviceHeadersProvider = deviceHeadersProvider;

  final Dio _dio;
  final AppPref _appPref;
  final DeviceHeadersProvider _deviceHeadersProvider;
  Completer<bool>? _refreshCompleter;

  static const _retryKey = 'auth_retry';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _appPref.getToken();
    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    } else {
      options.headers.remove('Authorization');
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;
    if (statusCode != 401) {
      handler.next(err);
      return;
    }

    final options = err.requestOptions;
    final alreadyRetried = options.extra[_retryKey] == true;
    final isRefreshCall =
        options.path == AppUrls.refreshToken ||
        options.uri.path.contains('/auth/token/refresh');
    final isLogoutCall = options.path.contains('/user-auth/auth/logout/');
    if (alreadyRetried || isRefreshCall || isLogoutCall) {
      handler.next(err);
      return;
    }

    final refreshed = await _refreshAccessTokenSingleFlight();
    if (!refreshed) {
      handler.next(err);
      return;
    }

    try {
      final accessToken = _appPref.getToken();
      final retryData = _retryData(options.data);
      final retryOptions = Options(
        method: options.method,
        headers: <String, dynamic>{
          ..._retryHeaders(options.headers),
          if (accessToken.isNotEmpty) 'Authorization': 'Bearer $accessToken',
        },
        sendTimeout: options.sendTimeout,
        receiveTimeout: options.receiveTimeout,
        extra: <String, dynamic>{...options.extra, _retryKey: true},
        contentType: options.contentType,
        responseType: options.responseType,
      );

      final response = await _dio.request<dynamic>(
        options.path,
        data: retryData,
        queryParameters: options.queryParameters,
        options: retryOptions,
        cancelToken: options.cancelToken,
        onReceiveProgress: options.onReceiveProgress,
        onSendProgress: options.onSendProgress,
      );

      handler.resolve(response);
    } catch (e) {
      if (e is DioException) {
        handler.next(e);
        return;
      }
      handler.next(err);
    }
  }

  dynamic _retryData(dynamic data) {
    if (data is FormData) {
      return data.clone();
    }
    return data;
  }

  Map<String, dynamic> _retryHeaders(Map<String, dynamic> headers) {
    return Map<String, dynamic>.from(headers)
      ..removeWhere((key, _) => key.toLowerCase() == 'content-length');
  }

  Future<bool> _refreshAccessTokenSingleFlight() async {
    final inFlight = _refreshCompleter;
    if (inFlight != null) {
      return inFlight.future;
    }

    final completer = Completer<bool>();
    _refreshCompleter = completer;
    try {
      final refreshToken = _appPref.getRefreshToken();
      if (refreshToken.isEmpty) {
        await _clearSession();
        completer.complete(false);
        return false;
      }

      final refreshDio = Dio(
        BaseOptions(
          connectTimeout: _dio.options.connectTimeout,
          receiveTimeout: _dio.options.receiveTimeout,
          sendTimeout: _dio.options.sendTimeout,
          headers: const {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      configureDioForAppNetwork(refreshDio);
      final deviceHeaders = await _deviceHeadersProvider.headers();

      final response = await refreshDio.post<Map<String, dynamic>>(
        AppUrls.refreshToken,
        data: <String, dynamic>{'refreshToken': refreshToken},
        options: Options(headers: deviceHeaders),
      );

      final payload = response.data ?? <String, dynamic>{};
      if (payload['success'] != true) {
        await _clearSession();
        completer.complete(false);
        return false;
      }

      final data = payload['data'];
      final dataMap = data is Map<String, dynamic> ? data : <String, dynamic>{};
      final access = dataMap['accessToken'];
      final refresh = dataMap['refreshToken'];
      final accessMap = access is Map<String, dynamic>
          ? access
          : <String, dynamic>{};
      final refreshMap = refresh is Map<String, dynamic>
          ? refresh
          : <String, dynamic>{};

      final newAccessToken = (accessMap['token'] ?? dataMap['token'] ?? '')
          .toString();
      // Backend may return only a new access token; keep existing refresh token.
      final newRefreshToken =
          (refreshMap['token'] ?? dataMap['refreshToken'] ?? '').toString();

      if (newAccessToken.isEmpty) {
        await _clearSession();
        completer.complete(false);
        return false;
      }

      await _appPref.setToken(newAccessToken);
      if (newRefreshToken.isNotEmpty) {
        await _appPref.setRefreshToken(newRefreshToken);
      }

      final accessExpiresMs = _toPositiveInt(accessMap['expiresIn']);
      if (accessExpiresMs != null) {
        await _appPref.setAccessTokenExpiresIn(accessExpiresMs);
      }
      final refreshExpiresMs = _toPositiveInt(refreshMap['expiresIn']);
      if (refreshExpiresMs != null) {
        await _appPref.setRefreshTokenExpiresIn(refreshExpiresMs);
      }

      completer.complete(true);
      return true;
    } catch (_) {
      await _clearSession();
      completer.complete(false);
      return false;
    } finally {
      _refreshCompleter = null;
    }
  }

  Future<void> _clearSession() async {
    await _appPref.setToken('');
    await _appPref.setRefreshToken('');
    await _appPref.setAccessTokenExpiresIn(0);
    await _appPref.setRefreshTokenExpiresIn(0);
    await _appPref.setLoginStatus(false);
  }

  static int? _toPositiveInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value > 0 ? value : null;
    if (value is num) {
      final i = value.toInt();
      return i > 0 ? i : null;
    }
    if (value is String) {
      final parsed = int.tryParse(value);
      if (parsed == null || parsed <= 0) return null;
      return parsed;
    }
    return null;
  }
}
