import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  const AuthEntity({
    required this.success,
    required this.message,
    required this.isOnboardingCompleted,
    this.msisdn,
    this.expiresInSeconds,
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
    this.imageUrl,
  });

  final bool success;
  final String message;
  final bool isOnboardingCompleted;
  final String? msisdn;
  final int? expiresInSeconds;
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
  final String? imageUrl;

  @override
  List<Object?> get props => [
    success,
    message,
    isOnboardingCompleted,
    msisdn,
    expiresInSeconds,
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
    imageUrl,
  ];
}
