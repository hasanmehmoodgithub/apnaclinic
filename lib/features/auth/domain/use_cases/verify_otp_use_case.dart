import 'package:equatable/equatable.dart';

import '../../../../core/failure/exceptions.dart';
import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpUseCase implements UseCase<AuthEntity, VerifyOtpParams> {
  VerifyOtpUseCase({required this.repository});

  final AuthRepository repository;

  @override
  Future<Either<ErrorMsg, AuthEntity>> call(VerifyOtpParams params) async {
    return await repository.verifyOtp(params);
  }
}

class VerifyOtpParams extends Equatable {
  const VerifyOtpParams({
    required this.phoneNumber,
    required this.otp,
  });

  final String phoneNumber;

  final String otp;

  @override
  List<Object?> get props => [phoneNumber, otp];
}
