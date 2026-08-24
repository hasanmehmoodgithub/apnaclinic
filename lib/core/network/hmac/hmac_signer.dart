import 'dart:convert';

import 'package:crypto/crypto.dart';

/// HMAC-SHA256 v1 request signer (pure functions — no I/O).
///
/// Canonical string is six newline-joined parts, no trailing newline:
/// `v1`, METHOD, path+query, timestamp, nonce, content-digest.
class HmacSigner {
  HmacSigner._();

  static const schemeVersion = 'v1';

  /// SHA-256 of empty bytes — used for GET / no body.
  static const emptyBodyDigest =
      'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855';

  static String sha256Hex(List<int> bytes) => sha256.convert(bytes).toString();

  static String hmacSha256Hex(String secret, String canonical) {
    final hmac = Hmac(sha256, utf8.encode(secret));
    return hmac.convert(utf8.encode(canonical)).toString();
  }

  static String canonicalString({
    required String method,
    required String pathAndQuery,
    required String timestamp,
    required String nonce,
    required String contentDigest,
  }) {
    return [
      schemeVersion,
      method.toUpperCase(),
      pathAndQuery,
      timestamp,
      nonce,
      contentDigest,
    ].join('\n');
  }

  static String contentDigestHex(List<int> bodyBytes) => sha256Hex(bodyBytes);

  /// Multipart digest payload: sorted `name=value` fields, then file SHA-256
  /// hex lines grouped by field name (sorted), order preserved within a field.
  /// Hash *this string*, not the multipart wire bytes (boundary is random).
  static String multipartDigestSource({
    required List<MapEntry<String, String>> fields,
    required List<MapEntry<String, List<int>>> files,
  }) {
    final fieldLines = fields.map((e) => '${e.key}=${e.value}').toList()
      ..sort();

    final filesByField = <String, List<List<int>>>{};
    for (final entry in files) {
      filesByField.putIfAbsent(entry.key, () => []).add(entry.value);
    }

    final fileHashLines = <String>[];
    final fieldNames = filesByField.keys.toList()..sort();
    for (final name in fieldNames) {
      for (final bytes in filesByField[name]!) {
        fileHashLines.add(sha256Hex(bytes));
      }
    }

    return [...fieldLines, ...fileHashLines].join('\n');
  }

  static String multipartContentDigest({
    required List<MapEntry<String, String>> fields,
    required List<MapEntry<String, List<int>>> files,
  }) {
    return sha256Hex(
      utf8.encode(multipartDigestSource(fields: fields, files: files)),
    );
  }

  static Map<String, String> sign({
    required String keyId,
    required String secret,
    required String method,
    required String pathAndQuery,
    required String timestamp,
    required String nonce,
    required String contentDigest,
  }) {
    final canonical = canonicalString(
      method: method,
      pathAndQuery: pathAndQuery,
      timestamp: timestamp,
      nonce: nonce,
      contentDigest: contentDigest,
    );
    final signature = hmacSha256Hex(secret, canonical);
    return {
      'x-key-id': keyId,
      'x-timestamp': timestamp,
      'x-nonce': nonce,
      'x-content-digest': contentDigest,
      'x-signature': signature,
    };
  }
}

/// Path + query exactly as Dio will send them (no scheme/host, encoded query).
String hmacPathAndQuery(Uri uri) {
  if (uri.hasScheme && uri.host.isNotEmpty) {
    final origin = '${uri.scheme}://${uri.authority}';
    final full = uri.toString();
    if (full.startsWith(origin)) {
      var rest = full.substring(origin.length);
      final hash = rest.indexOf('#');
      if (hash >= 0) rest = rest.substring(0, hash);
      return rest.isEmpty ? '/' : rest;
    }
  }
  final path = uri.path.isEmpty ? '/' : uri.path;
  if (!uri.hasQuery) return path;
  return '$path?${uri.query}';
}
