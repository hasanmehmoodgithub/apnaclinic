class AuthResponseModel {
  const AuthResponseModel({
    required this.success,
    required this.message,
    required this.isOnboardingCompleted,
    this.token,
    this.userId,
    this.firstName,
    this.lastName,
    this.gender,
    this.email,
    this.address,
    this.dateOfBirth,
  });

  final bool success;
  final String message;
  final bool isOnboardingCompleted;
  final String? token;
  final String? userId;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final String? email;
  final String? address;
  final String? dateOfBirth;

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final dataMap = data is Map<String, dynamic> ? data : <String, dynamic>{};
    final user = dataMap['user'];
    final userMap = user is Map<String, dynamic> ? user : <String, dynamic>{};
    return AuthResponseModel(
      success: json['success'] == true,
      message: (json['message'] ?? '').toString(),
      isOnboardingCompleted:
          (dataMap['isOnboardingCompleted'] ?? json['isOnboardingCompleted']) ==
          true,
      token: (dataMap['token'] ?? json['token'])?.toString(),
      userId: (dataMap['userId'] ?? json['userId'])?.toString(),
      firstName: (userMap['firstName'] ?? dataMap['firstName'])?.toString(),
      lastName: (userMap['lastName'] ?? dataMap['lastName'])?.toString(),
      gender: (userMap['gender'] ?? dataMap['gender'])?.toString(),
      email: (userMap['email'] ?? dataMap['email'])?.toString(),
      address: (userMap['address'] ?? dataMap['address'])?.toString(),
      dateOfBirth: (userMap['dateOfBirth'] ?? dataMap['dateOfBirth'])
          ?.toString(),
    );
  }
}
