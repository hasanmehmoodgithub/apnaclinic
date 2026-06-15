import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../repositories/account_repository.dart';

class DeleteUserPhoneParams {
  const DeleteUserPhoneParams({required this.phoneId});

  final String phoneId;
}

class DeleteUserPhoneUseCase implements UseCase<void, DeleteUserPhoneParams> {
  DeleteUserPhoneUseCase({required this.repository});

  final AccountRepository repository;

  @override
  Future<Either<ErrorMsg, void>> call(DeleteUserPhoneParams params) {
    return repository.deleteUserPhone(phoneId: params.phoneId);
  }
}
