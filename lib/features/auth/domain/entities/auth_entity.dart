import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  const AuthEntity({
    required this.success,
    required this.message,
    this.token,
    this.userId,
  });

  final bool success;
  final String message;
  final String? token;
  final String? userId;

  @override
  List<Object?> get props => [success, message, token, userId];
}
