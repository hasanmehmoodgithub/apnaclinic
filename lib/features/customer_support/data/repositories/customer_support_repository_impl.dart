import 'dart:developer';

import '../../../../core/functional/functional_export.dart';
import '../../../../core/preference/app_pref.dart';
import '../../domain/entities/customer_support_entity.dart';
import '../../domain/repositories/customer_support_repository.dart';
import '../data_sources/customer_support_remote_data_source.dart';
import '../mappers/customer_support_mapper.dart';

class CustomerSupportRepositoryImpl implements CustomerSupportRepository {
  CustomerSupportRepositoryImpl({
    required this.remoteDataSource,
    required this.appPref,
  });

  final CustomerSupportRemoteDataSource remoteDataSource;
  final AppPref appPref;

  Future<Either<ErrorMsg, CustomerSupportEntity>>? _inFlight;

  @override
  CustomerSupportEntity? getCachedCustomerSupportContent() {
    final cached = appPref.getSupportSettings();
    if (cached == null) return null;
    return CustomerSupportMapper.fromSettings(cached);
  }

  @override
  Future<Either<ErrorMsg, CustomerSupportEntity>>
  getCustomerSupportContent() {
    return _inFlight ??= _fetchAndCache().whenComplete(() => _inFlight = null);
  }

  Future<Either<ErrorMsg, CustomerSupportEntity>> _fetchAndCache() async {
    try {
      final model = await remoteDataSource.getSupportSettings();
      await appPref.setSupportSettings(model.data);
      final entity = CustomerSupportMapper.toEntity(model);
      log(
        'Mapped customer support: phone=${entity.contacts.isNotEmpty && entity.contacts.first.hasPhone}, '
        'email=${entity.contacts.isNotEmpty && entity.contacts.first.hasEmail}',
      );
      return Right(entity);
    } catch (e) {
      log('getCustomerSupportContent repository error: $e');
      final cached = getCachedCustomerSupportContent();
      if (cached != null) return Right(cached);
      return Left(e.toString());
    }
  }
}
