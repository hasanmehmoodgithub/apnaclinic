class ProfileSetupEntity {
  const ProfileSetupEntity({
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.email,
    required this.address,
    this.dateOfBirth,
    this.imageUrl,
  });

  final String firstName;
  final String lastName;
  final String gender;
  final String email;
  final String address;
  final DateTime? dateOfBirth;
  final String? imageUrl;

  ProfileSetupEntity copyWith({
    String? firstName,
    String? lastName,
    String? gender,
    String? email,
    String? address,
    DateTime? dateOfBirth,
    String? imageUrl,
  }) {
    return ProfileSetupEntity(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      address: address ?? this.address,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
