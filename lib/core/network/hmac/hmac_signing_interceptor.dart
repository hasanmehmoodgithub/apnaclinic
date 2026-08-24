import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import 'hmac_dev_log.dart';
import 'hmac_headers.dart';
import 'hmac_secret_store.dart';
import 'hmac_signer.dart';
import 'hmac_uuid.dart';

/// Signs aggregator and user-auth requests with HMAC-SHA256 v1 headers.
///
/// Runs after auth/device headers. Always recomputes nonce/timestamp so 401
/// retries are not rejected as nonce replays.
class HmacSigningInterceptor extends Interceptor {
  HmacSigningInterceptor({required HmacSecretStore secretStore})
    : _secretStore = secretStore;

  final HmacSecretStore _secretStore;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _signSafely(options).whenComplete(() => handler.next(options));
  }

  Future<void> _signSafely(RequestOptions options) async {
    try {
      await _sign(options);
    } catch (error) {
      hmacDevLog('Sign failed, sending unsigned: $error');
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      final headers = err.requestOptions.headers;
      final hadHmac = HmacHeaderNames.all.every(
        (name) => (headers[name]?.toString() ?? '').isNotEmpty,
      );
      hmacDevLog(
        '401 ${err.requestOptions.method} ${err.requestOptions.uri.path} '
        'hmacHeaders=${hadHmac ? 'present' : 'missing'} '
        '(generic 401 — could be JWT or HMAC; reason is server-side only)',
      );
    }
    handler.next(err);
  }

  Future<void> _sign(RequestOptions options) async {
    final uri = options.uri;
    final backend = hmacBackendFor(uri);
    if (backend == null) {
      return;
    }

    final secret = _secretStore.secretFor(backend);
    if (secret.isEmpty) {
      hmacDevLog(
        'Skip unsigned ${backend.name} ${options.method} ${hmacPathAndQuery(uri)} '
        '(secret missing — server returns missing_headers if HMAC_MODE=enforce)',
      );
      return;
    }

    final pathAndQuery = hmacPathAndQuery(uri);
    final digest = await _contentDigest(options);
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final nonce = hmacRandomUuidV4();
    final headers = HmacSigner.sign(
      keyId: _secretStore.keyId,
      secret: secret,
      method: options.method,
      pathAndQuery: pathAndQuery,
      timestamp: timestamp,
      nonce: nonce,
      contentDigest: digest,
    );

    headers.forEach((key, value) => options.headers[key] = value);

    final canonical = HmacSigner.canonicalString(
      method: options.method,
      pathAndQuery: pathAndQuery,
      timestamp: timestamp,
      nonce: nonce,
      contentDigest: digest,
    );
    hmacDevLog(
      'Signed ${backend.name} ${options.method} $pathAndQuery\n'
      'keyId=${_secretStore.keyId} nonce=$nonce timestamp=$timestamp\n'
      'digest=$digest\n'
      'canonical:\n$canonical',
    );
  }

  Future<String> _contentDigest(RequestOptions options) async {
    final data = options.data;
    if (data == null) {
      return HmacSigner.emptyBodyDigest;
    }
    if (data is FormData) {
      return _multipartDigest(data);
    }

    final bodyBytes = _jsonBodyBytes(options, data);
    return HmacSigner.contentDigestHex(bodyBytes);
  }

  /// Freeze Map/List as a JSON string so Dio cannot re-serialize a different body.
  List<int> _jsonBodyBytes(RequestOptions options, dynamic data) {
    if (data is Uint8List) {
      return data;
    }
    if (data is String) {
      return utf8.encode(data);
    }

    final json = jsonEncode(data);
    options.data = json;
    return utf8.encode(json);
  }

  Future<String> _multipartDigest(FormData form) async {
    final files = <MapEntry<String, List<int>>>[];
    for (final entry in form.files) {
      files.add(MapEntry(entry.key, await _multipartFileBytes(entry.value)));
    }
    return HmacSigner.multipartContentDigest(fields: form.fields, files: files);
  }

  /// Clone before reading — finalize() consumes the stream used for upload.
  Future<List<int>> _multipartFileBytes(MultipartFile file) async {
    final clone = file.clone();
    final builder = BytesBuilder(copy: false);
    await for (final chunk in clone.finalize()) {
      builder.add(chunk);
    }
    return builder.takeBytes();
  }
}
