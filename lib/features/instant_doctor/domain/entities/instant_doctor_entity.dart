import 'package:equatable/equatable.dart';

class InstantDoctorEntity extends Equatable {
  const InstantDoctorEntity({
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
