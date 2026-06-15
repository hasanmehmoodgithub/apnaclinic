import 'dart:developer';

import '../../../../core/functional/functional_export.dart';
import '../../domain/entities/account_item_entity.dart';
import '../../domain/repositories/account_repository.dart';
import '../data_sources/account_remote_data_source.dart';

class AccountRepositoryImpl implements AccountRepository {
  AccountRepositoryImpl({required this.remoteDataSource});

  final AccountRemoteDataSource remoteDataSource;

  @override
  Future<Either<ErrorMsg, List<AccountItemEntity>>> getAccountsList() async {
    try {
      final items = await remoteDataSource.getAccountsList();
      return Right(items);
    } catch (e) {
      log('getAccountsList repository error: $e');
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, void>> addUserPhone({required String phone}) async {
    try {
      await remoteDataSource.addUserPhone(phone: phone);
      return const Right(null);
    } catch (e) {
      log('addUserPhone repository error: $e');
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, void>> deleteUserPhone({required String phone}) async {
    try {
      await remoteDataSource.deleteUserPhone(phone: phone);
      return const Right(null);
    } catch (e) {
      log('deleteUserPhone repository error: $e');
      return Left(e.toString());
    }
  }
}
