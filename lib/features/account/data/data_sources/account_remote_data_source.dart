import '../models/account_item_model.dart';

abstract class AccountRemoteDataSource {
  Future<List<AccountItemModel>> getAccountsList();
}
