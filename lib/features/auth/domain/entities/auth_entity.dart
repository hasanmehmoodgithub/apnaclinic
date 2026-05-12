import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  const AuthEntity({
    required this.success,
    required this.message,
    required this.isOnboardingCompleted,
    this.msisdn,
    this.expiresInMinutes,
    this.generationAttemptCount,
    this.token,
    this.refreshToken,
    this.accessTokenExpiresIn,
    this.refreshTokenExpiresIn,
    this.userId,
    this.firstName,
    this.lastName,
    this.gender,
    this.email,
    this.address,
    this.dateOfBirth,
  });

  final bool success;
  final String message;
  final bool isOnboardingCompleted;
  final String? msisdn;
  final int? expiresInMinutes;
  final int? generationAttemptCount;
  final String? token;
  final String? refreshToken;
  final int? accessTokenExpiresIn;
  final int? refreshTokenExpiresIn;
  final String? userId;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final String? email;
  final String? address;
  final String? dateOfBirth;

  @override
  List<Object?> get props => [
    success,
    message,
    isOnboardingCompleted,
    msisdn,
    expiresInMinutes,
    generationAttemptCount,
    token,
    refreshToken,
    accessTokenExpiresIn,
    refreshTokenExpiresIn,
    userId,
    firstName,
    lastName,
    gender,
    email,
    address,
    dateOfBirth,
  ];
}
