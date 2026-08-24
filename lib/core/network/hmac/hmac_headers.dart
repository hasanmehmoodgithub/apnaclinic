/// HMAC v1 header names attached to aggregator and user-auth requests.
abstract final class HmacHeaderNames {
  static const keyId = 'x-key-id';
  static const timestamp = 'x-timestamp';
  static const nonce = 'x-nonce';
  static const contentDigest = 'x-content-digest';
  static const signature = 'x-signature';

  static const all = <String>{
    keyId,
    timestamp,
    nonce,
    contentDigest,
    signature,
  };
}

enum HmacBackend { aggregator, userAuth }

/// Which HMAC secret to use, or null if this host/path is not signed.
HmacBackend? hmacBackendFor(Uri uri) {
  final path = uri.path;
  if (path.contains('acs-aggregator')) return HmacBackend.aggregator;
  if (path.contains('acs-auth')) return HmacBackend.userAuth;
  return null;
}
