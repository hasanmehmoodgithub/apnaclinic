import '../../domain/models/profile_setup_data.dart';

class ProfileSetupModel {
  const ProfileSetupModel({
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.email,
    required this.address,
    required this.dateOfBirth,
  });

  final String firstName;
  final String lastName;
  final String gender;
  final String email;
  final String address;
  final String dateOfBirth;

  factory ProfileSetupModel.fromJson(Map<String, dynamic> json) {
    return ProfileSetupModel(
      firstName: (json['firstName'] ?? '').toString(),
      lastName: (json['lastName'] ?? '').toString(),
      gender: (json['gender'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      address: (json['address'] ?? '').toString(),
      dateOfBirth: (json['dateOfBirth'] ?? '').toString(),
    );
  }
}

class ProfileSetupResponseModel {
  const ProfileSetupResponseModel({
    required this.success,
    required this.message,
    required this.content,
  });

  final bool success;
  final String message;
  final ProfileSetupModel content;

  factory ProfileSetupResponseModel.fromJson(Map<String, dynamic> json) {
    final payload = _contentMap(json);
    return ProfileSetupResponseModel(
      success: json['success'] == true,
      message: (json['message'] ?? '').toString(),
      content: ProfileSetupModel.fromJson(payload),
    );
  }

  static Map<String, dynamic> _contentMap(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is Map<String, dynamic>) {
      final nestedUser = data['user'];
      if (nestedUser is Map<String, dynamic>) return nestedUser;
      return data;
    }
    final user = json['user'];
    if (user is Map<String, dynamic>) {
      return user;
    }
    final copy = Map<String, dynamic>.from(json)
      ..remove('success')
      ..remove('message');
    return copy;
  }
}

Map<String, dynamic> profileSetupSavePayload(ProfileSetupData data) {
  return {
    'firstName': data.firstName,
    'lastName': data.lastName,
    'gender': data.gender,
    'email': data.email,
    'address': data.address,
    'dateOfBirth': data.dateOfBirth.toIso8601String(),
  };
}
