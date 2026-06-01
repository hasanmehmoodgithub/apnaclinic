import 'package:dio/dio.dart';

import '../flavor/flavor_config.dart';
import 'dio_ssl_config_stub.dart'
    if (dart.library.io) 'dio_ssl_config_io.dart';

/// TLS/cleartext fixes for Jazz OpenShift hosts (corporate certs, HTTP auth API).
void configureDioForAppNetwork(Dio dio) {
  configureDioSslForDev(
    dio,
    enabled: FlavorConfig.enableDebugFeatures,
  );
}
