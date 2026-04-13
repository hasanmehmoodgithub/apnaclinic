import 'package:flutter/foundation.dart';
import 'isolate_api_service.dart';

/// Example usage of IsolateApiService
class IsolateApiExample {
  /// Example: GET request
  static Future<void> exampleGet() async {
    final result = await IsolateApiService.get(
      'https://api.example.com/users',
      headers: {'Authorization': 'Bearer token123'},
      queryParameters: {'page': 1, 'limit': 10},
      timeout: const Duration(seconds: 30),
    );

    if (result['success']) {
      debugPrint('Data: ${result['data']}');
      debugPrint('Status: ${result['statusCode']}');
    } else {
      debugPrint('Error: ${result['error']}');
    }
  }

  /// Example: POST request
  static Future<void> examplePost() async {
    final result = await IsolateApiService.post(
      'https://api.example.com/users',
      data: {
        'name': 'John Doe',
        'email': 'john@example.com',
      },
      headers: {'Content-Type': 'application/json'},
    );

    if (result['success']) {
      debugPrint('Created: ${result['data']}');
    } else {
      debugPrint('Error: ${result['error']}');
    }
  }

  /// Example: PUT request
  static Future<void> examplePut() async {
    final result = await IsolateApiService.put(
      'https://api.example.com/users/123',
      data: {'name': 'Jane Doe'},
    );

    if (result['success']) {
      debugPrint('Updated: ${result['data']}');
    }
  }

  /// Example: DELETE request
  static Future<void> exampleDelete() async {
    final result = await IsolateApiService.delete(
      'https://api.example.com/users/123',
    );

    if (result['success']) {
      debugPrint('Deleted successfully');
    }
  }

  /// Example: Multiple parallel requests
  static Future<void> exampleMultipleRequests() async {
    final futures = [
      IsolateApiService.get('https://api.example.com/users'),
      IsolateApiService.get('https://api.example.com/posts'),
      IsolateApiService.get('https://api.example.com/comments'),
    ];

    final results = await Future.wait(futures);

    for (final result in results) {
      if (result['success']) {
        debugPrint('Success: ${result['data']}');
      } else {
        debugPrint('Error: ${result['error']}');
      }
    }
  }

  /// Example: In a widget
  static Future<void> exampleInWidget() async {
    // This keeps UI responsive while API call runs
    final result = await IsolateApiService.get(
      'https://api.example.com/heavy-endpoint',
    );

    // Update UI with result
    if (result['success']) {
      // Update state, show data, etc.
      debugPrint('Data loaded: ${result['data']}');
    } else {
      // Show error
      debugPrint('Failed: ${result['error']}');
    }
  }
}
