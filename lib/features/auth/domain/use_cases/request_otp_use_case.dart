import 'package:equatable/equatable.dart';

import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

class RequestOtpUseCase implements UseCase<AuthEntity, RequestOtpParams> {
  RequestOtpUseCase({required this.repository});

  final AuthRepository repository;

  @override
  Future<Either<ErrorMsg, AuthEntity>> call(RequestOtpParams params) async {
    return await repository.requestOtp(params);
  }
}

class RequestOtpParams extends Equatable {
  const RequestOtpParams({
    required this.phoneNumber,
    required this.channel,
  });

  final String phoneNumber;
  final String channel;

  @override
  List<Object?> get props => [phoneNumber, channel];
}
