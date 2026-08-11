import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

import '../flavor/flavor_config.dart';
import 'app_http_overrides.dart';

/// Applies proxy (`AppHttpOverrides.activeProxy`) + TLS trust for mitm / Jazz certs.
void configureDioForAppNetwork(Dio dio) {
  final adapter = IOHttpClientAdapter();
  adapter.createHttpClient = () {
    final client = HttpClient();
    client.findProxy = AppHttpOverrides.findProxyForUri;

    final allowBadCert = AppHttpOverrides.activeProxy != null ||
        FlavorConfig.enableDebugFeatures;
    if (allowBadCert) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    }
    return client;
  };
  dio.httpClientAdapter = adapter;
}
