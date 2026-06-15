import '../../../../core/functional/functional_export.dart';
import '../entities/account_item_entity.dart';

abstract class AccountRepository {
  Future<Either<ErrorMsg, List<AccountItemEntity>>> getAccountsList();

  Future<Either<ErrorMsg, void>> addUserPhone({required String phone});

  Future<Either<ErrorMsg, void>> deleteUserPhone({required String phone});
}
