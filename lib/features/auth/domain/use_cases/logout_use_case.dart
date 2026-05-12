import 'package:equatable/equatable.dart';

import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../repositories/auth_repository.dart';

class LogoutUseCase implements UseCaseVoid<LogoutParams> {
  LogoutUseCase({required this.repository});

  final AuthRepository repository;

  @override
  Future<Either<ErrorMsg, void>> call(LogoutParams params) async {
    return repository.logout(params.userId);
  }
}

class LogoutParams extends Equatable {
  const LogoutParams({required this.userId});

  final String userId;

  @override
  List<Object?> get props => [userId];
}
