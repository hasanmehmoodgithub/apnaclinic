# 🔄 Isolate API Guide

Complete guide for calling APIs in Dart isolates to keep UI responsive.

---

## 📖 What are Isolates?

**Isolates** are separate execution threads that run independently. They're perfect for:
- ✅ Heavy API calls
- ✅ Data processing
- ✅ Background tasks
- ✅ Keeping UI responsive

**Key Points:**
- Isolates don't share memory (communicate via messages)
- Each isolate has its own event loop
- Perfect for CPU-intensive or blocking operations

---

## 🚀 Quick Start

### Basic Isolate API Call

```dart
import 'dart:isolate';
import 'package:dio/dio.dart';

// API call function (runs in isolate)
static Future<Map<String, dynamic>> _apiCallInIsolate(Map<String, dynamic> params) async {
  final dio = Dio();
  final url = params['url'] as String;
  final headers = params['headers'] as Map<String, dynamic>?;
  
  try {
    final response = await dio.get(
      url,
      options: Options(headers: headers),
    );
    return {'success': true, 'data': response.data};
  } catch (e) {
    return {'success': false, 'error': e.toString()};
  }
}

// Call API in isolate
Future<Map<String, dynamic>> callApiInIsolate(String url) async {
  final receivePort = ReceivePort();
  
  await Isolate.spawn(
    _apiCallInIsolate,
    {
      'url': url,
      'headers': {'Content-Type': 'application/json'},
      'sendPort': receivePort.sendPort,
    },
  );
  
  final result = await receivePort.first as Map<String, dynamic>;
  return result;
}
```

---

## 📝 Complete Examples

### Example 1: Simple API Call in Isolate

```dart
import 'dart:isolate';
import 'package:dio/dio.dart';

class IsolateApiService {
  /// Call API in isolate
  static Future<Map<String, dynamic>> callApi(String url) async {
    final receivePort = ReceivePort();
    
    await Isolate.spawn(
      _apiCall,
      {
        'url': url,
        'sendPort': receivePort.sendPort,
      },
    );
    
    final result = await receivePort.first as Map<String, dynamic>;
    receivePort.close();
    
    return result;
  }
  
  /// API call function (runs in isolate)
  static Future<void> _apiCall(Map<String, dynamic> params) async {
    final sendPort = params['sendPort'] as SendPort;
    final url = params['url'] as String;
    
    try {
      final dio = Dio();
      final response = await dio.get(url);
      
      sendPort.send({
        'success': true,
        'data': response.data,
        'statusCode': response.statusCode,
      });
    } catch (e) {
      sendPort.send({
        'success': false,
        'error': e.toString(),
      });
    }
  }
}

// Usage
final result = await IsolateApiService.callApi('https://api.example.com/data');
if (result['success']) {
  print('Data: ${result['data']}');
} else {
  print('Error: ${result['error']}');
}
```

---

### Example 2: POST Request with Body

```dart
import 'dart:isolate';
import 'package:dio/dio.dart';

class IsolateApiService {
  /// POST request in isolate
  static Future<Map<String, dynamic>> postApi(
    String url,
    Map<String, dynamic> body,
  ) async {
    final receivePort = ReceivePort();
    
    await Isolate.spawn(
      _postApiCall,
      {
        'url': url,
        'body': body,
        'sendPort': receivePort.sendPort,
      },
    );
    
    final result = await receivePort.first as Map<String, dynamic>;
    receivePort.close();
    
    return result;
  }
  
  /// POST API call function
  static Future<void> _postApiCall(Map<String, dynamic> params) async {
    final sendPort = params['sendPort'] as SendPort;
    final url = params['url'] as String;
    final body = params['body'] as Map<String, dynamic>;
    
    try {
      final dio = Dio();
      final response = await dio.post(
        url,
        data: body,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );
      
      sendPort.send({
        'success': true,
        'data': response.data,
        'statusCode': response.statusCode,
      });
    } catch (e) {
      sendPort.send({
        'success': false,
        'error': e.toString(),
      });
    }
  }
}

// Usage
final result = await IsolateApiService.postApi(
  'https://api.example.com/users',
  {'name': 'John', 'email': 'john@example.com'},
);
```

---

### Example 3: Multiple API Calls in Parallel

```dart
import 'dart:isolate';
import 'package:dio/dio.dart';

class IsolateApiService {
  /// Call multiple APIs in parallel isolates
  static Future<List<Map<String, dynamic>>> callMultipleApis(
    List<String> urls,
  ) async {
    final futures = urls.map((url) => callApi(url)).toList();
    final results = await Future.wait(futures);
    return results;
  }
  
  /// Single API call
  static Future<Map<String, dynamic>> callApi(String url) async {
    final receivePort = ReceivePort();
    
    await Isolate.spawn(
      _apiCall,
      {
        'url': url,
        'sendPort': receivePort.sendPort,
      },
    );
    
    final result = await receivePort.first as Map<String, dynamic>;
    receivePort.close();
    
    return result;
  }
  
  /// API call function
  static Future<void> _apiCall(Map<String, dynamic> params) async {
    final sendPort = params['sendPort'] as SendPort;
    final url = params['url'] as String;
    
    try {
      final dio = Dio();
      final response = await dio.get(url);
      
      sendPort.send({
        'success': true,
        'data': response.data,
        'url': url,
      });
    } catch (e) {
      sendPort.send({
        'success': false,
        'error': e.toString(),
        'url': url,
      });
    }
  }
}

// Usage
final urls = [
  'https://api.example.com/users',
  'https://api.example.com/posts',
  'https://api.example.com/comments',
];

final results = await IsolateApiService.callMultipleApis(urls);
for (final result in results) {
  if (result['success']) {
    print('${result['url']}: Success');
  } else {
    print('${result['url']}: Error');
  }
}
```

---

### Example 4: With Error Handling & Timeout

```dart
import 'dart:isolate';
import 'package:dio/dio.dart';

class IsolateApiService {
  /// API call with timeout and error handling
  static Future<Map<String, dynamic>> callApiWithTimeout(
    String url, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final receivePort = ReceivePort();
    Isolate? isolate;
    
    try {
      isolate = await Isolate.spawn(
        _apiCallWithTimeout,
        {
          'url': url,
          'timeout': timeout.inSeconds,
          'sendPort': receivePort.sendPort,
        },
      );
      
      final result = await receivePort.first
          .timeout(timeout)
          as Map<String, dynamic>;
      
      return result;
    } on TimeoutException {
      isolate?.kill(priority: Isolate.immediate);
      return {
        'success': false,
        'error': 'Request timeout',
      };
    } catch (e) {
      isolate?.kill(priority: Isolate.immediate);
      return {
        'success': false,
        'error': e.toString(),
      };
    } finally {
      receivePort.close();
    }
  }
  
  /// API call with timeout
  static Future<void> _apiCallWithTimeout(Map<String, dynamic> params) async {
    final sendPort = params['sendPort'] as SendPort;
    final url = params['url'] as String;
    final timeoutSeconds = params['timeout'] as int;
    
    try {
      final dio = Dio();
      dio.options.connectTimeout = Duration(seconds: timeoutSeconds);
      dio.options.receiveTimeout = Duration(seconds: timeoutSeconds);
      
      final response = await dio.get(url);
      
      sendPort.send({
        'success': true,
        'data': response.data,
        'statusCode': response.statusCode,
      });
    } catch (e) {
      sendPort.send({
        'success': false,
        'error': e.toString(),
      });
    }
  }
}
```

---

### Example 5: Using Compute Function (Simpler)

```dart
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

class ComputeApiService {
  /// API call using compute (simpler than isolate)
  static Future<Map<String, dynamic>> callApi(String url) async {
    return await compute(_apiCall, url);
  }
  
  /// API call function (must be top-level or static)
  static Future<Map<String, dynamic>> _apiCall(String url) async {
    try {
      final dio = Dio();
      final response = await dio.get(url);
      
      return {
        'success': true,
        'data': response.data,
        'statusCode': response.statusCode,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }
}

// Usage
final result = await ComputeApiService.callApi('https://api.example.com/data');
```

---

### Example 6: Complete Service with Dio Integration

```dart
import 'dart:isolate';
import 'package:dio/dio.dart';

class IsolateApiClient {
  final Dio _dio;
  
  IsolateApiClient({Dio? dio}) : _dio = dio ?? Dio();
  
  /// GET request in isolate
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _callInIsolate(
      'GET',
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }
  
  /// POST request in isolate
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _callInIsolate(
      'POST',
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
  
  /// PUT request in isolate
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _callInIsolate(
      'PUT',
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
  
  /// DELETE request in isolate
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _callInIsolate(
      'DELETE',
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
  
  /// Call API in isolate
  Future<Response> _callInIsolate(
    String method,
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final receivePort = ReceivePort();
    
    await Isolate.spawn(
      _apiCall,
      {
        'method': method,
        'path': path,
        'data': data,
        'queryParameters': queryParameters,
        'options': options?.headers,
        'baseUrl': _dio.options.baseUrl,
        'sendPort': receivePort.sendPort,
      },
    );
    
    final result = await receivePort.first as Map<String, dynamic>;
    receivePort.close();
    
    if (result['success']) {
      return Response(
        data: result['data'],
        statusCode: result['statusCode'],
        requestOptions: RequestOptions(path: path),
      );
    } else {
      throw DioException(
        requestOptions: RequestOptions(path: path),
        error: result['error'],
      );
    }
  }
  
  /// API call function (runs in isolate)
  static Future<void> _apiCall(Map<String, dynamic> params) async {
    final sendPort = params['sendPort'] as SendPort;
    final method = params['method'] as String;
    final path = params['path'] as String;
    final baseUrl = params['baseUrl'] as String? ?? '';
    final data = params['data'];
    final queryParameters = params['queryParameters'] as Map<String, dynamic>?;
    final headers = params['options'] as Map<String, dynamic>?;
    
    try {
      final dio = Dio(BaseOptions(baseUrl: baseUrl));
      
      Response response;
      switch (method.toUpperCase()) {
        case 'GET':
          response = await dio.get(
            path,
            queryParameters: queryParameters,
            options: Options(headers: headers),
          );
          break;
        case 'POST':
          response = await dio.post(
            path,
            data: data,
            queryParameters: queryParameters,
            options: Options(headers: headers),
          );
          break;
        case 'PUT':
          response = await dio.put(
            path,
            data: data,
            queryParameters: queryParameters,
            options: Options(headers: headers),
          );
          break;
        case 'DELETE':
          response = await dio.delete(
            path,
            data: data,
            queryParameters: queryParameters,
            options: Options(headers: headers),
          );
          break;
        default:
          throw Exception('Unsupported method: $method');
      }
      
      sendPort.send({
        'success': true,
        'data': response.data,
        'statusCode': response.statusCode,
      });
    } catch (e) {
      sendPort.send({
        'success': false,
        'error': e.toString(),
      });
    }
  }
}

// Usage
final client = IsolateApiClient(
  dio: Dio(BaseOptions(baseUrl: 'https://api.example.com')),
);

final response = await client.get('/users');
print('Data: ${response.data}');
```

---

## 🎯 When to Use Isolates

### ✅ Use Isolates For:

- Heavy API calls that might block UI
- Multiple parallel API calls
- Data processing after API response
- Background tasks
- Large file downloads

### ❌ Don't Use Isolates For:

- Simple, fast API calls
- UI updates
- State management
- Small operations

---

## ⚠️ Important Notes

### 1. Function Must Be Top-Level or Static

```dart
// ✅ Good - Static function
static Future<void> _apiCall(Map<String, dynamic> params) async {
  // ...
}

// ❌ Bad - Instance method
Future<void> _apiCall(Map<String, dynamic> params) async {
  // ...
}
```

### 2. Only Serializable Data

```dart
// ✅ Good - Primitive types, Maps, Lists
sendPort.send({'key': 'value'});

// ❌ Bad - Objects, Functions
sendPort.send(MyClass()); // Won't work
```

### 3. Close ReceivePort

```dart
// ✅ Good
final receivePort = ReceivePort();
// ... use receivePort
receivePort.close(); // Always close

// ❌ Bad - Memory leak
final receivePort = ReceivePort();
// Forgot to close
```

### 4. Error Handling

```dart
// ✅ Good - Always handle errors
try {
  final result = await receivePort.first;
} catch (e) {
  // Handle error
} finally {
  receivePort.close();
}
```

---

## 🔧 Best Practices

### 1. Use Compute for Simple Cases

```dart
// ✅ Simpler - Use compute
final result = await compute(_apiCall, url);

// More complex - Use isolate
final receivePort = ReceivePort();
await Isolate.spawn(_apiCall, params);
```

### 2. Clean Up Resources

```dart
// ✅ Always close ports
final receivePort = ReceivePort();
try {
  // Use isolate
} finally {
  receivePort.close();
}
```

### 3. Handle Timeouts

```dart
// ✅ Add timeout
final result = await receivePort.first.timeout(
  Duration(seconds: 30),
);
```

### 4. Kill Isolates on Error

```dart
// ✅ Kill isolate on timeout
Isolate? isolate;
try {
  isolate = await Isolate.spawn(_apiCall, params);
  // ...
} on TimeoutException {
  isolate?.kill(priority: Isolate.immediate);
}
```

---

## 📋 Quick Reference

### Basic Pattern

```dart
// 1. Create ReceivePort
final receivePort = ReceivePort();

// 2. Spawn isolate
await Isolate.spawn(_apiCall, {
  'sendPort': receivePort.sendPort,
  // ... other params
});

// 3. Receive result
final result = await receivePort.first;

// 4. Close port
receivePort.close();
```

### Using Compute (Simpler)

```dart
final result = await compute(_apiCall, url);
```

---

## 🎯 Summary

1. ✅ **Isolates** = Separate threads for heavy operations
2. ✅ **Use for** = Heavy API calls, parallel requests
3. ✅ **Pattern** = ReceivePort → Spawn → Receive → Close
4. ✅ **Compute** = Simpler alternative for simple cases
5. ✅ **Always** = Close ports, handle errors, add timeouts

---

That's it! Keep your UI responsive with isolates. 🔄
