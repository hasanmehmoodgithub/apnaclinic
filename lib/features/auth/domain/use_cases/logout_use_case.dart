import 'package:equatable/equatable.dart';

import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../repositories/auth_repository.dart';

class LogoutUseCase implements UseCaseVoid<LogoutParams> {
  LogoutUseCase({required this.repository});

  final AuthRepository repository;

  @override
  Future<Either<ErrorMsg, void>> call(LogoutParams params) async {
    return repository.logout(params);
  }
}

class LogoutParams extends Equatable {
  const LogoutParams({
    required this.userId,
    required this.refreshToken,
  });

  final String userId;
  final String refreshToken;

  @override
  List<Object?> get props => [userId, refreshToken];
}
