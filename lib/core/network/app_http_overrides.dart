import 'dart:io';

import 'package:flutter/foundation.dart';

/// Global HTTP overrides for POC/mitm: auto-detect local proxy + trust proxy certs.
class AppHttpOverrides extends HttpOverrides {
  static const List<String> candidateProxies = [
    // '192.168.100.77:8080',
    // '10.124.74.71:8080',
    // '192.168.13.1:8080',
    // '192.168.19.1:9000',
  ];

  static String? activeProxy;

  /// Tests proxies **in list order** and keeps the first that accepts a TCP connect.
  static Future<void> detectActiveProxy() async {
    activeProxy = null;

    for (final proxy in candidateProxies) {
      final parts = proxy.split(':');
      if (parts.length != 2) continue;
      final host = parts[0].trim();
      final port = int.tryParse(parts[1].trim());
      if (host.isEmpty || port == null) continue;

      try {
        final socket = await Socket.connect(
          host,
          port,
          timeout: const Duration(seconds: 1),
        );
        socket.destroy();
        activeProxy = proxy;
        debugPrint('[Proxy] Active: $proxy');
        return;
      } catch (e) {
        debugPrint('[Proxy] Unreachable $proxy ($e)');
      }
    }

    debugPrint(
      '[Proxy] None reachable among ${candidateProxies.length} candidates — using DIRECT',
    );
  }

  static String findProxyForUri(Uri uri) {
    final proxy = activeProxy;
    if (proxy != null && proxy.isNotEmpty) {
      return 'PROXY $proxy; DIRECT';
    }
    return 'DIRECT';
  }

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    client.findProxy = findProxyForUri;
    // Required for HTTPS through Charles/mitm when using an interceptor proxy.
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return client;
  }
}
