import 'package:dio/dio.dart';

import '../preference/app_pref.dart';
import '../utils/jwt_utils.dart';
import 'device_headers_provider.dart';

class HeaderInterceptor extends Interceptor {
  HeaderInterceptor({
    required DeviceHeadersProvider deviceHeadersProvider,
    required AppPref appPref,
  })  : _deviceHeadersProvider = deviceHeadersProvider,
        _appPref = appPref;

  final DeviceHeadersProvider _deviceHeadersProvider;
  final AppPref _appPref;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _addHeaders(options)
        .then((_) => handler.next(options))
        .catchError((_) => handler.next(options));
  }

  Future<void> _addHeaders(RequestOptions options) async {
    final headers = await _deviceHeadersProvider.headers();
    options.headers.addAll(headers);

    final uri = options.uri.toString();
    if (!uri.contains('apnaclinic-cmsbackend')) return;

    final token = _appPref.getToken();
    final tenantId = JwtUtils.claim<dynamic>(token, 'tenant_id');
    if (tenantId != null) {
      options.headers['x-tenant-id'] = tenantId.toString();
    }
  }
}
