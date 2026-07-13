import 'dart:developer';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/functional/functional_export.dart';
import '../../../../core/session/profile_session_sync.dart';
import '../../domain/entities/account_item_entity.dart';
import '../../domain/repositories/account_repository.dart';
import '../data_sources/account_remote_data_source.dart';

class AccountRepositoryImpl implements AccountRepository {
  AccountRepositoryImpl({
    required this.remoteDataSource,
    ProfileSessionSync? profileSessionSync,
  })  : _profileSessionSync = profileSessionSync ?? sl<ProfileSessionSync>();

  final AccountRemoteDataSource remoteDataSource;
  final ProfileSessionSync _profileSessionSync;

  @override
  Future<Either<ErrorMsg, List<AccountItemEntity>>> getAccountsList() async {
    try {
      final items = await remoteDataSource.getAccountsList();
      _profileSessionSync.markSynced(items);
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
  Future<Either<ErrorMsg, void>> deleteUserPhone({required String phoneId}) async {
    try {
      await remoteDataSource.deleteUserPhone(phoneId: phoneId);
      return const Right(null);
    } catch (e) {
      log('deleteUserPhone repository error: $e');
      return Left(e.toString());
    }
  }
}
