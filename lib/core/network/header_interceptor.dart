import 'package:dio/dio.dart';

import '../preference/app_pref.dart';
import '../utils/jwt_utils.dart';
import 'app_urls.dart';
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
    if (!_isMobileBackendUri(uri)) {
      return;
    }

    final apiKey = AppUrls.mobileApiKey.trim();
    if (apiKey.isNotEmpty) {
      options.headers['x-api-key'] = apiKey;
    }

    final token = _appPref.getToken();
    final tenantId = JwtUtils.claim<dynamic>(token, 'tenant_id');
    if (tenantId != null) {
      options.headers['x-tenant-id'] = tenantId.toString();
    }
  }

  bool _isMobileBackendUri(String uri) {
    final cmsHost = Uri.tryParse(AppUrls.baseUrl)?.host ?? '';
    final aggregatorHost = Uri.tryParse(AppUrls.baseUrl)?.host ?? '';
    if (cmsHost.isNotEmpty && uri.contains(cmsHost)) return true;
    if (aggregatorHost.isNotEmpty && uri.contains(aggregatorHost)) return true;
    return uri.contains('apnaclinic-cmsbackend') ||
        uri.contains('apnaclinic-aggregator');
  }
}
