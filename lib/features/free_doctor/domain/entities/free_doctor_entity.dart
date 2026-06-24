import 'package:equatable/equatable.dart';

class FreeDoctorEntity extends Equatable {
  const FreeDoctorEntity({
    required this.isSubscribed,
    required this.bulletPoints,
    required this.buttonText,
    required this.redirectUrl,
  });

  final bool isSubscribed;
  final List<String> bulletPoints;
  final String buttonText;
  final String redirectUrl;

  @override
  List<Object?> get props => [
    isSubscribed,
    bulletPoints,
    buttonText,
    redirectUrl,
  ];
}
