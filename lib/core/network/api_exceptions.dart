/// Base type for HTTP / client failures from [ApiService].
class ApiException implements Exception {
  ApiException({
    required this.message,
    required this.statusCode,
    this.data,
  });

  final String message;
  final int statusCode;
  final Map<String, dynamic>? data;

  @override
  String toString() => message;
}

class ApiNetworkException extends ApiException {
  ApiNetworkException({required super.message}) : super(statusCode: 0);
}

class ApiTimeoutException extends ApiException {
  ApiTimeoutException({required super.message}) : super(statusCode: 0);
}

class ApiUnauthorizedException extends ApiException {
  ApiUnauthorizedException({required super.message, super.data})
      : super(statusCode: 401);
}

class ApiForbiddenException extends ApiException {
  ApiForbiddenException({required super.message, super.data})
      : super(statusCode: 403);
}

class ApiNotFoundException extends ApiException {
  ApiNotFoundException({required super.message, super.data})
      : super(statusCode: 404);
}

class ApiServerException extends ApiException {
  ApiServerException({
    required super.message,
    required super.statusCode,
    super.data,
  });
}

class ApiCancelledException extends ApiException {
  ApiCancelledException({required super.message}) : super(statusCode: 0);
}

class ApiCertificateException extends ApiException {
  ApiCertificateException({required super.message}) : super(statusCode: 0);
}
