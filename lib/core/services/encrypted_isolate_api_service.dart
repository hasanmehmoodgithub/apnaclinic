import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import '../isolate/isolate_api_service.dart';
import '../network/device_headers_provider.dart';
import 'encryption_service.dart';

/// Service for making encrypted API calls in isolates
///
/// This service:
/// - Encrypts request data before sending
/// - Decrypts response data after receiving
/// - Runs all operations in isolates to keep UI responsive
class EncryptedIsolateApiService {
  final EncryptionService encryptionService;
  final String baseUrl;
  final DeviceHeadersProvider deviceHeadersProvider;

  EncryptedIsolateApiService({
    required this.encryptionService,
    required this.baseUrl,
    DeviceHeadersProvider? deviceHeadersProvider,
  }) : deviceHeadersProvider = deviceHeadersProvider ?? DeviceHeadersProvider();

  Future<Map<String, dynamic>> _headersWithDevice(
    Map<String, dynamic>? headers,
  ) async {
    return <String, dynamic>{
      ...await deviceHeadersProvider.headers(),
      ...?headers,
    };
  }

  /// Make encrypted GET request in isolate
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    Duration? timeout,
  }) async {
    try {
      if (kDebugMode) {
        developer.log(
          '🔐 Making encrypted GET request to: $endpoint',
          name: 'EncryptedIsolateApiService',
        );
      }

      // Make request in isolate (no encryption for GET query params)
      final result = await IsolateApiService.get(
        '$baseUrl$endpoint',
        headers: await _headersWithDevice(headers),
        queryParameters: queryParameters,
        timeout: timeout,
      );

      if (!result['success']) {
        return result;
      }

      // Decrypt response data
      final encryptedData = result['data'];
      if (encryptedData is String) {
        final decryptedJson = encryptionService.decryptJson(encryptedData);
        return {
          'success': true,
          'data': decryptedJson,
          'statusCode': result['statusCode'],
          'headers': result['headers'],
        };
      } else if (encryptedData is Map<String, dynamic>) {
        // Check if response contains encrypted field
        if (encryptedData.containsKey('encrypted')) {
          final decryptedJson = encryptionService.decryptJson(
            encryptedData['encrypted'] as String,
          );
          return {
            'success': true,
            'data': decryptedJson,
            'statusCode': result['statusCode'],
            'headers': result['headers'],
          };
        }
        // Response is already decrypted
        return result;
      }

      return result;
    } catch (e) {
      if (kDebugMode) {
        developer.log(
          '❌ Error in encrypted GET request: $e',
          name: 'EncryptedIsolateApiService',
          error: e,
        );
      }
      return {
        'success': false,
        'error': 'Encryption error: ${e.toString()}',
        'statusCode': 500,
      };
    }
  }

  /// Make encrypted POST request in isolate
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    Duration? timeout,
  }) async {
    try {
      if (kDebugMode) {
        developer.log(
          '🔐 Making encrypted POST request to: $endpoint',
          name: 'EncryptedIsolateApiService',
        );
      }

      // Encrypt request data
      String encryptedData;
      if (data != null) {
        encryptedData = encryptionService.encryptJson(data);
        if (kDebugMode) {
          developer.log(
            '✅ Request data encrypted (length: ${encryptedData.length})',
            name: 'EncryptedIsolateApiService',
          );
        }
      } else {
        encryptedData = encryptionService.encryptJson({});
      }

      // Prepare encrypted payload
      final encryptedPayload = {'encrypted': encryptedData};

      // Make request in isolate with encrypted payload
      final result = await IsolateApiService.post(
        '$baseUrl$endpoint',
        data: encryptedPayload,
        headers: {
          ...await _headersWithDevice(headers),
          'Content-Type': 'application/json',
        },
        queryParameters: queryParameters,
        timeout: timeout,
      );

      if (!result['success']) {
        return result;
      }

      // Decrypt response data
      final responseData = result['data'];
      if (responseData is String) {
        final decryptedJson = encryptionService.decryptJson(responseData);
        return {
          'success': true,
          'data': decryptedJson,
          'statusCode': result['statusCode'],
          'headers': result['headers'],
        };
      } else if (responseData is Map<String, dynamic>) {
        // Check if response contains encrypted field
        if (responseData.containsKey('encrypted')) {
          final decryptedJson = encryptionService.decryptJson(
            responseData['encrypted'] as String,
          );
          if (kDebugMode) {
            developer.log(
              '✅ Response data decrypted',
              name: 'EncryptedIsolateApiService',
            );
          }
          return {
            'success': true,
            'data': decryptedJson,
            'statusCode': result['statusCode'],
            'headers': result['headers'],
          };
        }
        // Response is already decrypted
        return result;
      }

      return result;
    } catch (e) {
      if (kDebugMode) {
        developer.log(
          '❌ Error in encrypted POST request: $e',
          name: 'EncryptedIsolateApiService',
          error: e,
        );
      }
      return {
        'success': false,
        'error': 'Encryption error: ${e.toString()}',
        'statusCode': 500,
      };
    }
  }

  /// Make encrypted PUT request in isolate
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    Duration? timeout,
  }) async {
    try {
      if (kDebugMode) {
        developer.log(
          '🔐 Making encrypted PUT request to: $endpoint',
          name: 'EncryptedIsolateApiService',
        );
      }

      // Encrypt request data
      String encryptedData;
      if (data != null) {
        encryptedData = encryptionService.encryptJson(data);
      } else {
        encryptedData = encryptionService.encryptJson({});
      }

      // Prepare encrypted payload
      final encryptedPayload = {'encrypted': encryptedData};

      // Make request in isolate with encrypted payload
      final result = await IsolateApiService.put(
        '$baseUrl$endpoint',
        data: encryptedPayload,
        headers: {
          ...await _headersWithDevice(headers),
          'Content-Type': 'application/json',
        },
        queryParameters: queryParameters,
        timeout: timeout,
      );

      if (!result['success']) {
        return result;
      }

      // Decrypt response data
      final responseData = result['data'];
      if (responseData is String) {
        final decryptedJson = encryptionService.decryptJson(responseData);
        return {
          'success': true,
          'data': decryptedJson,
          'statusCode': result['statusCode'],
          'headers': result['headers'],
        };
      } else if (responseData is Map<String, dynamic>) {
        if (responseData.containsKey('encrypted')) {
          final decryptedJson = encryptionService.decryptJson(
            responseData['encrypted'] as String,
          );
          return {
            'success': true,
            'data': decryptedJson,
            'statusCode': result['statusCode'],
            'headers': result['headers'],
          };
        }
        return result;
      }

      return result;
    } catch (e) {
      if (kDebugMode) {
        developer.log(
          '❌ Error in encrypted PUT request: $e',
          name: 'EncryptedIsolateApiService',
          error: e,
        );
      }
      return {
        'success': false,
        'error': 'Encryption error: ${e.toString()}',
        'statusCode': 500,
      };
    }
  }

  /// Make encrypted DELETE request in isolate
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    Duration? timeout,
  }) async {
    try {
      if (kDebugMode) {
        developer.log(
          '🔐 Making encrypted DELETE request to: $endpoint',
          name: 'EncryptedIsolateApiService',
        );
      }

      // Encrypt request data if provided
      Map<String, dynamic>? encryptedPayload;
      if (data != null) {
        final encryptedData = encryptionService.encryptJson(data);
        encryptedPayload = {'encrypted': encryptedData};
      }

      // Make request in isolate
      final result = await IsolateApiService.delete(
        '$baseUrl$endpoint',
        data: encryptedPayload,
        headers: {
          ...await _headersWithDevice(headers),
          'Content-Type': 'application/json',
        },
        queryParameters: queryParameters,
        timeout: timeout,
      );

      if (!result['success']) {
        return result;
      }

      // Decrypt response data if present
      final responseData = result['data'];
      if (responseData is String) {
        final decryptedJson = encryptionService.decryptJson(responseData);
        return {
          'success': true,
          'data': decryptedJson,
          'statusCode': result['statusCode'],
          'headers': result['headers'],
        };
      } else if (responseData is Map<String, dynamic>) {
        if (responseData.containsKey('encrypted')) {
          final decryptedJson = encryptionService.decryptJson(
            responseData['encrypted'] as String,
          );
          return {
            'success': true,
            'data': decryptedJson,
            'statusCode': result['statusCode'],
            'headers': result['headers'],
          };
        }
        return result;
      }

      return result;
    } catch (e) {
      if (kDebugMode) {
        developer.log(
          '❌ Error in encrypted DELETE request: $e',
          name: 'EncryptedIsolateApiService',
          error: e,
        );
      }
      return {
        'success': false,
        'error': 'Encryption error: ${e.toString()}',
        'statusCode': 500,
      };
    }
  }
}
