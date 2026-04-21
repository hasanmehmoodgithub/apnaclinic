class UserLocalModel {
  const UserLocalModel({
    this.firstName = '',
    this.lastName = '',
    this.phone = '',
    this.gender = '',
    this.email = '',
    this.address = '',
    this.dateOfBirth = '',
  });

  final String firstName;
  final String lastName;
  final String phone;
  final String gender;
  final String email;
  final String address;
  final String dateOfBirth;

  factory UserLocalModel.fromJson(Map<String, dynamic> json) {
    return UserLocalModel(
      firstName: (json['firstName'] ?? '').toString(),
      lastName: (json['lastName'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      gender: (json['gender'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      address: (json['address'] ?? '').toString(),
      dateOfBirth: (json['dateOfBirth'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'gender': gender,
      'email': email,
      'address': address,
      'dateOfBirth': dateOfBirth,
    };
  }

  UserLocalModel copyWith({
    String? firstName,
    String? lastName,
    String? phone,
    String? gender,
    String? email,
    String? address,
    String? dateOfBirth,
  }) {
    return UserLocalModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      address: address ?? this.address,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    );
  }
}
