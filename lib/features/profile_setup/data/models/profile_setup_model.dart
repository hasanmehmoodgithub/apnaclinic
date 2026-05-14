import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

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
      dateOfBirth: (json['dateOfBirth'] ?? json['dob'] ?? '').toString(),
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

Future<FormData> profileSetupSaveFormData(
  ProfileSetupData data,
) async {
  final payload = <String, dynamic>{
    'firstName': data.firstName,
    'lastName': data.lastName,
    'gender': data.gender,
    'email': data.email,
    'address': data.address,
    'dob': DateFormat('dd-MM-yyyy').format(
      DateTime(
        data.dateOfBirth.year,
        data.dateOfBirth.month,
        data.dateOfBirth.day,
      ),
    ),
  };

  final profileImagePath = data.profileImagePath;
  if (profileImagePath != null && profileImagePath.isNotEmpty) {
    payload['image'] = await MultipartFile.fromFile(profileImagePath);
  }

  return FormData.fromMap(payload);
}
