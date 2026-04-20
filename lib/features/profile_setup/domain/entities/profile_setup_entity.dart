class ProfileSetupEntity {
  const ProfileSetupEntity({
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.email,
    required this.address,
    this.dateOfBirth,
  });

  final String firstName;
  final String lastName;
  final String gender;
  final String email;
  final String address;
  final DateTime? dateOfBirth;

  ProfileSetupEntity copyWith({
    String? firstName,
    String? lastName,
    String? gender,
    String? email,
    String? address,
    DateTime? dateOfBirth,
  }) {
    return ProfileSetupEntity(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      address: address ?? this.address,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    );
  }
}
