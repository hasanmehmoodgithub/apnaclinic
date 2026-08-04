import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import '../../domain/models/profile_setup_data.dart';

class ProfileSetupModel {
  const ProfileSetupModel({
    required this.apiUserId,
    required this.publicId,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.email,
    required this.address,
    required this.dateOfBirth,
    required this.imageUrl,
    required this.phones,
  });

  final String apiUserId;
  final String publicId;
  final String firstName;
  final String lastName;
  final String gender;
  final String email;
  final String address;
  final String dateOfBirth;
  final String imageUrl;
  final List<ProfileUserPhoneModel> phones;

  factory ProfileSetupModel.fromJson(Map<String, dynamic> json) {
    return ProfileSetupModel(
      apiUserId: (json['id'] ?? '').toString(),
      publicId: (json['publicId'] ?? '').toString(),
      firstName: (json['firstName'] ?? '').toString(),
      lastName: (json['lastName'] ?? '').toString(),
      gender: (json['gender'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      address: (json['address'] ?? '').toString(),
      dateOfBirth: (json['dateOfBirth'] ?? json['dob'] ?? '').toString(),
      imageUrl: (json['image'] ?? json['imageUrl'] ?? '').toString(),
      phones: ProfileUserPhoneModel.parseList(json['phones']),
    );
  }

  String? get primaryMsisdn {
    for (final phone in phones) {
      if (phone.primary) return phone.msisdn;
    }
    return phones.isNotEmpty ? phones.first.msisdn : null;
  }
}

class ProfileUserPhoneModel {
  const ProfileUserPhoneModel({
    required this.id,
    required this.msisdn,
    required this.jazzCashVerified,
    required this.primary,
  });

  final String id;
  final String msisdn;
  final bool jazzCashVerified;
  final bool primary;

  factory ProfileUserPhoneModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'] ?? json['phoneId'];
    return ProfileUserPhoneModel(
      id: rawId != null ? rawId.toString() : '',
      msisdn: (json['msisdn'] ?? '').toString(),
      jazzCashVerified: json['jazzCashVerified'] == true,
      primary: json['primary'] == true,
    );
  }

  static List<ProfileUserPhoneModel> parseList(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map(
          (item) => ProfileUserPhoneModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .where((phone) => phone.msisdn.isNotEmpty)
        .toList(growable: false);
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

Future<FormData> profileSetupSaveFormData(ProfileSetupData data) async {
  final formattedDob = DateFormat('dd-MM-yyyy').format(
    DateTime(
      data.dateOfBirth.year,
      data.dateOfBirth.month,
      data.dateOfBirth.day,
    ),
  );
  final payload = <String, dynamic>{
    'firstName': data.firstName,
    'lastName': data.lastName,
    'gender': data.gender,
    'email': data.email,
    'address': data.address,
    'dob': formattedDob,
  };

  final profileImagePath = data.profileImagePath;
  if (profileImagePath != null && profileImagePath.isNotEmpty) {
    payload['image'] = await MultipartFile.fromFile(profileImagePath);
  }

  return FormData.fromMap(payload);
}
