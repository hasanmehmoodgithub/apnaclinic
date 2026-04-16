import 'dart:developer';

import '../../../../core/functional/functional_export.dart';
import '../../domain/entities/customer_support_entity.dart';
import '../../domain/repositories/customer_support_repository.dart';
import '../data_sources/customer_support_remote_data_source.dart';
import '../mappers/customer_support_mapper.dart';

class CustomerSupportRepositoryImpl implements CustomerSupportRepository {
  CustomerSupportRepositoryImpl({required this.remoteDataSource});

  final CustomerSupportRemoteDataSource remoteDataSource;

  @override
  Future<Either<ErrorMsg, CustomerSupportEntity>>
      getCustomerSupportContent() async {
    try {
      final model = await remoteDataSource.getCustomerSupportContent();
      final entity = CustomerSupportMapper.toEntity(model);
      log('Mapped customer support: ${entity.contacts.length} contacts');
      return Right(entity);
    } catch (e) {
      log('getCustomerSupportContent repository error: $e');
      return Left(e.toString());
    }
  }
}
