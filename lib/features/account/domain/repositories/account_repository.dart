import '../entities/account_item_entity.dart';

abstract class AccountRepository {
  Future<List<AccountItemEntity>> getAccountsList();
}
