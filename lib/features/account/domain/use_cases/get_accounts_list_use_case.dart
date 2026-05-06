import '../entities/account_item_entity.dart';
import '../repositories/account_repository.dart';

class GetAccountsListUseCase {
  GetAccountsListUseCase({required this.repository});

  final AccountRepository repository;

  Future<List<AccountItemEntity>> call() {
    return repository.getAccountsList();
  }
}
