class AuthResponseModel {
  const AuthResponseModel({
    required this.success,
    required this.message,
    this.token,
    this.userId,
  });

  final bool success;
  final String message;
  final String? token;
  final String? userId;

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final dataMap = data is Map<String, dynamic> ? data : <String, dynamic>{};
    return AuthResponseModel(
      success: json['success'] == true,
      message: (json['message'] ?? '').toString(),
      token: (dataMap['token'] ?? json['token'])?.toString(),
      userId: (dataMap['userId'] ?? json['userId'])?.toString(),
    );
  }
}
