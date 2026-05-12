import 'dart:async';

import 'package:dio/dio.dart';

import '../preference/app_pref.dart';
import 'app_urls.dart';

/// Handles automatic access token refresh on 401 responses.
///
/// Uses single-flight refresh so concurrent 401 responses trigger only one
/// refresh request, then all failed requests are retried with the new token.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required Dio dio,
    required AppPref appPref,
  }) : _dio = dio,
       _appPref = appPref;

  final Dio _dio;
  final AppPref _appPref;
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
    final isRefreshCall = options.path == AppUrls.refreshToken;
    if (alreadyRetried || isRefreshCall) {
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
      final retryOptions = Options(
        method: options.method,
        headers: <String, dynamic>{
          ...options.headers,
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
        data: options.data,
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

      final response = await refreshDio.post<Map<String, dynamic>>(
        AppUrls.refreshToken,
        data: <String, dynamic>{'refreshToken': refreshToken},
      );

      final payload = response.data ?? <String, dynamic>{};
      final data = payload['data'];
      final dataMap = data is Map<String, dynamic> ? data : <String, dynamic>{};
      final access = dataMap['accessToken'];
      final refresh = dataMap['refreshToken'];
      final accessMap = access is Map<String, dynamic> ? access : <String, dynamic>{};
      final refreshMap = refresh is Map<String, dynamic> ? refresh : <String, dynamic>{};

      final newAccessToken = (accessMap['token'] ?? dataMap['token'] ?? '').toString();
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

      final accessExpiresIn = accessMap['expiresIn'];
      if (accessExpiresIn is int) {
        await _appPref.setAccessTokenExpiresIn(accessExpiresIn);
      }
      final refreshExpiresIn = refreshMap['expiresIn'];
      if (refreshExpiresIn is int) {
        await _appPref.setRefreshTokenExpiresIn(refreshExpiresIn);
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
}
