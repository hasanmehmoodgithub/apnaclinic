import '../../domain/entities/account_item_entity.dart';
import '../../domain/repositories/account_repository.dart';
import '../data_sources/account_remote_data_source.dart';

class AccountRepositoryImpl implements AccountRepository {
  AccountRepositoryImpl({required this.remoteDataSource});

  final AccountRemoteDataSource remoteDataSource;

  @override
  Future<List<AccountItemEntity>> getAccountsList() {
    return remoteDataSource.getAccountsList();
  }
}
