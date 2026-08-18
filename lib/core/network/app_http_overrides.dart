import 'dart:io';

import 'package:flutter/foundation.dart';

/// Global HTTP overrides for POC/mitm: auto-detect local proxy + trust proxy certs.
///
/// Candidates come from `--dart-define=HTTP_PROXIES=host:port,host:port`.
/// Empty / omitted → no probe, traffic is DIRECT.
class AppHttpOverrides extends HttpOverrides {
  static const String _proxiesRaw = String.fromEnvironment(
    'HTTP_PROXIES',
    defaultValue: '',
  );

  static List<String> get candidateProxies => _proxiesRaw
      .split(',')
      .map((s) => s.trim())
      .where((s) => s.isNotEmpty)
      .toList();

  static String? activeProxy;

  /// Tests proxies **in list order** and keeps the first that accepts a TCP connect.
  static Future<void> detectActiveProxy() async {
    activeProxy = null;
    final candidates = candidateProxies;
    if (candidates.isEmpty) {
      debugPrint('[Proxy] HTTP_PROXIES empty — using DIRECT');
      return;
    }

    for (final proxy in candidates) {
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
      '[Proxy] None reachable among ${candidates.length} candidates — using DIRECT',
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
