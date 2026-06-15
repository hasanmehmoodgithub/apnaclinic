import '../models/account_item_model.dart';

abstract class AccountRemoteDataSource {
  Future<List<AccountItemModel>> getAccountsList();

  Future<void> addUserPhone({required String phone});

  Future<void> deleteUserPhone({required String phone});
}
