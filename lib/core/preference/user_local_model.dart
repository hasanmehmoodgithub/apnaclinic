class UserLocalModel {
  const UserLocalModel({
    this.firstName = '',
    this.lastName = '',
    this.phone = '',
    this.apiUserId = '',
    this.gender = '',
    this.email = '',
    this.address = '',
    this.dateOfBirth = '',
    this.imageUrl = '',
  });

  final String firstName;
  final String lastName;
  final String phone;
  /// Numeric user id from profile API (`data.id`), used for phone endpoints.
  final String apiUserId;
  final String gender;
  final String email;
  final String address;
  final String dateOfBirth;
  final String imageUrl;

  factory UserLocalModel.fromJson(Map<String, dynamic> json) {
    return UserLocalModel(
      firstName: (json['firstName'] ?? '').toString(),
      lastName: (json['lastName'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      apiUserId: (json['apiUserId'] ?? '').toString(),
      gender: (json['gender'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      address: (json['address'] ?? '').toString(),
      dateOfBirth: (json['dateOfBirth'] ?? '').toString(),
      imageUrl: (json['imageUrl'] ?? json['image'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'apiUserId': apiUserId,
      'gender': gender,
      'email': email,
      'address': address,
      'dateOfBirth': dateOfBirth,
      'imageUrl': imageUrl,
    };
  }

  UserLocalModel copyWith({
    String? firstName,
    String? lastName,
    String? phone,
    String? apiUserId,
    String? gender,
    String? email,
    String? address,
    String? dateOfBirth,
    String? imageUrl,
  }) {
    return UserLocalModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      apiUserId: apiUserId ?? this.apiUserId,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      address: address ?? this.address,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
