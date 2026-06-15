import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../repositories/account_repository.dart';

class AddUserPhoneParams {
  const AddUserPhoneParams({required this.phone});

  final String phone;
}

class AddUserPhoneUseCase implements UseCase<void, AddUserPhoneParams> {
  AddUserPhoneUseCase({required this.repository});

  final AccountRepository repository;

  @override
  Future<Either<ErrorMsg, void>> call(AddUserPhoneParams params) {
    return repository.addUserPhone(phone: params.phone);
  }
}
