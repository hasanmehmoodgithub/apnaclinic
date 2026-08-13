import '../../../../core/preference/app_pref.dart';
import '../../data/mappers/profile_setup_mapper.dart';

class ProfileViewData {
  const ProfileViewData({
    required this.fullName,
    required this.phone,
    required this.gender,
    required this.dob,
    required this.email,
    this.imageUrl,
  });

  final String fullName;
  final String phone;
  final String gender;
  final String dob;
  final String email;
  final String? imageUrl;

  factory ProfileViewData.fromAppPref(AppPref appPref) {
    final user = appPref.getUserLocalModel();
    final firstName = user?.firstName.trim() ?? '';
    final lastName = user?.lastName.trim() ?? '';
    final fullName = '$firstName $lastName'.trim();
    final gender = user?.gender.trim() ?? '';
    final email = user?.email.trim() ?? '';
    final dobLabel = _formatDob(user?.dateOfBirth.trim() ?? '');
    final imageUrl = user?.imageUrl.trim();

    return ProfileViewData(
      fullName: fullName,
      phone: user?.phone.trim() ?? '',
      gender: gender.isEmpty ? '--' : gender,
      dob: dobLabel.isEmpty ? '--' : dobLabel,
      email: email.isEmpty ? '--' : email,
      imageUrl: imageUrl?.isEmpty ?? true ? null : imageUrl,
    );
  }

  static String _formatDob(String raw) {
    final dob = ProfileSetupMapper.tryParseDate(raw);
    if (dob == null) return '';

    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final month = monthNames[(dob.month - 1).clamp(0, 11)];
    return '${dob.day.toString().padLeft(2, '0')} $month ${dob.year}';
  }
}
