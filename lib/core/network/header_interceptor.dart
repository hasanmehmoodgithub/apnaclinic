import 'package:dio/dio.dart';

import 'device_headers_provider.dart';

class HeaderInterceptor extends Interceptor {
  HeaderInterceptor({required DeviceHeadersProvider deviceHeadersProvider})
    : _deviceHeadersProvider = deviceHeadersProvider;

  final DeviceHeadersProvider _deviceHeadersProvider;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _addHeaders(options)
        .then((_) => handler.next(options))
        .catchError((_) => handler.next(options));
  }

  Future<void> _addHeaders(RequestOptions options) async {
    final headers = await _deviceHeadersProvider.headers();
    options.headers.addAll(headers);
  }
}
