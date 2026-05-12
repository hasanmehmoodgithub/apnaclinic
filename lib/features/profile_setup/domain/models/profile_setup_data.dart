class ProfileSetupData {
  const ProfileSetupData({
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.email,
    required this.address,
    required this.dateOfBirth,
    this.profileImageBase64,
  });

  final String firstName;
  final String lastName;
  final String gender;
  final String email;
  final String address;
  final DateTime dateOfBirth;
  final String? profileImageBase64;
}
