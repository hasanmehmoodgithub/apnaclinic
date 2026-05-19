import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import '../constants/app_strings.dart';
import '../network/api_service.dart';
import 'api_error_message_utils.dart';

class ErrorHandler {
  /// Handles exceptions and returns user-friendly messages.
  static String handleExceptions(
    dynamic error, {
    String? endpoint,
    Map<String, dynamic>? requestData,
  }) {
    String errorMessage = AppStrings.genericErrorMessage;

    try {
      if (error is ErrorMsgException) {
        errorMessage = error.message;
      } else if (error is SocketException) {
        errorMessage =
            'Your internet connection seems unstable. Please try again.';
      } else if (error is TimeoutException) {
        errorMessage = 'Connection timed out. Please check your internet and try again.';
      } else if (error is FormatException) {
        errorMessage = 'Received an invalid response. Please try again.';
      } else if (error is HandshakeException) {
        errorMessage = 'A secure connection could not be established.';
      } else if (error is DioException) {
        errorMessage = _handleDioError(error);
      } else if (error is ApiException) {
        errorMessage = error.message.isEmpty
            ? AppStrings.genericErrorMessage
            : error.message;
      } else if (error is String && error.trim().isNotEmpty) {
        errorMessage = error.trim();
      } else if (error is Exception) {
        final msg = error.toString().replaceFirst('Exception: ', '').trim();
        if (msg.isNotEmpty) {
          errorMessage = msg;
        }
      }
    } catch (_) {}

    return errorMessage;
  }

  /// Handles Dio-specific errors
  static String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.cancel:
        return 'Request was cancelled. Please try again.';
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
        return 'Connection timed out. Please check your internet and try again.';
      case DioExceptionType.receiveTimeout:
        return 'Server took too long to respond. Please try again.';
      case DioExceptionType.badResponse:
        return _handleResponseError(error.response);
      case DioExceptionType.connectionError:
        return 'Unable to connect. Please check your internet connection.';
      case DioExceptionType.badCertificate:
        return 'Could not verify secure connection.';
      case DioExceptionType.unknown:
        final message = error.message?.trim();
        return (message == null || message.isEmpty)
            ? AppStrings.genericErrorMessage
            : message;
    }
  }

  /// Handles HTTP response errors
  static String _handleResponseError(Response? response) {
    final bodyMessage = _extractBodyMessage(response?.data);
    if (bodyMessage != null && bodyMessage.isNotEmpty) {
      return bodyMessage;
    }

    final statusCode = response?.statusCode;
    switch (statusCode) {
      case 400:
        return 'Invalid request. Please check and try again.';
      case 401:
        return 'Session expired. Please log in again.';
      case 403:
        return 'Access denied. Please log in with proper access.';
      case 404:
        return 'Requested resource not found.';
      case 409:
        return 'This request conflicts with current data.';
      case 422:
        return 'Provided information is not valid.';
      case 429:
        return 'Too many requests. Please try again shortly.';
      case 500:
      case 502:
      case 503:
      case 504:
        return 'Server error. Please try again later.';
      default:
        return 'Unexpected server response. Please try again.';
    }
  }

  static String? _extractBodyMessage(dynamic data) {
    final parsed = ApiErrorMessageUtils.tryParse(data);
    if (parsed != null && parsed.isNotEmpty) {
      return parsed;
    }
    return null;
  }
}

/// Wrap clean, user-friendly messages for direct consumption.
class ErrorMsgException implements Exception {
  const ErrorMsgException(this.message);

  final String message;
}

