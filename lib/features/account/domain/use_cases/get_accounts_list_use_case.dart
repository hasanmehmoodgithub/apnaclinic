import '../../../../core/functional/functional_export.dart';
import '../entities/account_item_entity.dart';
import '../repositories/account_repository.dart';

class GetAccountsListUseCase {
  GetAccountsListUseCase({required this.repository});

  final AccountRepository repository;

  Future<Either<ErrorMsg, List<AccountItemEntity>>> call() {
    return repository.getAccountsList();
  }
}
