import 'dart:convert';

import 'package:apnaclinic/core/network/hmac/hmac_headers.dart';
import 'package:apnaclinic/core/network/hmac/hmac_signer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HmacSigner', () {
    test('empty body digest matches SHA-256 of no bytes', () {
      expect(
        HmacSigner.contentDigestHex(utf8.encode('')),
        HmacSigner.emptyBodyDigest,
      );
      expect(
        HmacSigner.emptyBodyDigest,
        'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
      );
    });

    test('canonical string matches v1 worked example shape', () {
      final canonical = HmacSigner.canonicalString(
        method: 'get',
        pathAndQuery: '/mobile/cities',
        timestamp: '1755878400000',
        nonce: 'e6a1f8b2-9c3d-4a11-8e2f-6b7c9d0a1234',
        contentDigest: HmacSigner.emptyBodyDigest,
      );

      expect(
        canonical,
        'v1\n'
        'GET\n'
        '/mobile/cities\n'
        '1755878400000\n'
        'e6a1f8b2-9c3d-4a11-8e2f-6b7c9d0a1234\n'
        'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
      );
      expect(canonical.endsWith('\n'), isFalse);
    });

    test('HMAC-SHA256 matches RFC 4231-style known vector', () {
      expect(
        HmacSigner.hmacSha256Hex(
          'key',
          'The quick brown fox jumps over the lazy dog',
        ),
        'f7bc83f430538424b13298e6aa6fb143ef4d59a14946175997479dbc2d1a3cd8',
      );
    });

    test('sign is deterministic for fixed timestamp and nonce', () {
      final headers = HmacSigner.sign(
        keyId: 'android',
        secret: 'test-secret',
        method: 'GET',
        pathAndQuery: '/mobile/cities',
        timestamp: '1755878400000',
        nonce: 'e6a1f8b2-9c3d-4a11-8e2f-6b7c9d0a1234',
        contentDigest: HmacSigner.emptyBodyDigest,
      );

      final canonical = HmacSigner.canonicalString(
        method: 'GET',
        pathAndQuery: '/mobile/cities',
        timestamp: '1755878400000',
        nonce: 'e6a1f8b2-9c3d-4a11-8e2f-6b7c9d0a1234',
        contentDigest: HmacSigner.emptyBodyDigest,
      );

      expect(headers['x-key-id'], 'android');
      expect(headers['x-timestamp'], '1755878400000');
      expect(headers['x-nonce'], 'e6a1f8b2-9c3d-4a11-8e2f-6b7c9d0a1234');
      expect(headers['x-content-digest'], HmacSigner.emptyBodyDigest);
      expect(
        headers['x-signature'],
        HmacSigner.hmacSha256Hex('test-secret', canonical),
      );
    });

    test('multipart digest sorts fields and groups files by field name', () {
      final source = HmacSigner.multipartDigestSource(
        fields: const [MapEntry('b', '2'), MapEntry('a', '1')],
        files: [
          MapEntry('z', utf8.encode('file-z')),
          MapEntry('a', utf8.encode('file-a1')),
          MapEntry('a', utf8.encode('file-a2')),
        ],
      );

      final hashA1 = HmacSigner.sha256Hex(utf8.encode('file-a1'));
      final hashA2 = HmacSigner.sha256Hex(utf8.encode('file-a2'));
      final hashZ = HmacSigner.sha256Hex(utf8.encode('file-z'));

      expect(source, 'a=1\nb=2\n$hashA1\n$hashA2\n$hashZ');
    });
  });

  group('hmacPathAndQuery', () {
    test('strips scheme and host, keeps encoded query', () {
      final uri = Uri.parse(
        'https://api.example.com/acs-aggregator/api/v1/mobile/lab/tests?cityId=1&page=2',
      );
      expect(
        hmacPathAndQuery(uri),
        '/acs-aggregator/api/v1/mobile/lab/tests?cityId=1&page=2',
      );
    });

    test('keeps percent-encoding on the query', () {
      final uri = Uri.parse(
        'https://api.example.com/mobile/search?q=foo%20bar',
      );
      expect(hmacPathAndQuery(uri), '/mobile/search?q=foo%20bar');
    });
  });

  group('hmacBackendFor', () {
    test('detects aggregator and user-auth, skips cms', () {
      expect(
        hmacBackendFor(
          Uri.parse('https://h/acs-aggregator/api/v1/mobile/cities'),
        ),
        HmacBackend.aggregator,
      );
      expect(
        hmacBackendFor(
          Uri.parse('https://h/acs-auth/api/v1/auth/otp/generate'),
        ),
        HmacBackend.userAuth,
      );
      expect(
        hmacBackendFor(Uri.parse('https://h/acs-cmsbe/api/v1/mobile/banners')),
        isNull,
      );
    });
  });
}
