import 'dart:developer';

import '../../../../core/functional/functional_export.dart';
import '../../domain/entities/pro_catalog_entity.dart';
import '../../domain/repositories/pro_repository.dart';
import '../data_sources/pro_remote_data_source.dart';
import '../mappers/pro_mapper.dart';

class ProRepositoryImpl implements ProRepository {
  ProRepositoryImpl({required this.remoteDataSource});

  final ProRemoteDataSource remoteDataSource;

  @override
  Future<Either<ErrorMsg, ProCatalogEntity>> getCatalog() async {
    try {
      final model = await remoteDataSource.getCatalog();
      return Right(ProMapper.toEntity(model));
    } catch (e) {
      log('getProCatalog repository error: $e');
      return Left(e.toString());
    }
  }
}
