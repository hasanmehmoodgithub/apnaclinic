import 'package:equatable/equatable.dart';

class SupportSettingsEntity extends Equatable {
  const SupportSettingsEntity({
    required this.phone,
    required this.email,
    required this.description,
    required this.buttonText,
  });

  final String phone;
  final String email;
  final String description;
  final String buttonText;

  bool get hasEmail => email.isNotEmpty;

  bool get hasPhone => phone.isNotEmpty;

  @override
  List<Object?> get props => [phone, email, description, buttonText];
}
