import 'package:equatable/equatable.dart';

import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../repositories/auth_repository.dart';

class UpdateFcmDeviceTokenUseCase
    implements UseCaseVoid<UpdateFcmDeviceTokenParams> {
  UpdateFcmDeviceTokenUseCase({required this.repository});

  final AuthRepository repository;

  @override
  Future<Either<ErrorMsg, void>> call(UpdateFcmDeviceTokenParams params) {
    return repository.updateFcmDeviceToken(params);
  }
}

class UpdateFcmDeviceTokenParams extends Equatable {
  const UpdateFcmDeviceTokenParams({required this.fcmToken});

  final String fcmToken;

  @override
  List<Object?> get props => [fcmToken];
}
