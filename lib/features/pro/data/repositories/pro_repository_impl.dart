import 'dart:developer';

import '../../../../core/functional/functional_export.dart';
import '../../domain/entities/pro_catalog_entity.dart';
import '../../domain/entities/pro_subscribe_result_entity.dart';
import '../../domain/entities/pro_unsubscribe_result_entity.dart';
import '../../domain/repositories/pro_repository.dart';
import '../../domain/use_cases/subscribe_pro_params.dart';
import '../../domain/use_cases/unsubscribe_pro_params.dart';
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

  @override
  Future<Either<ErrorMsg, ProSubscribeResultEntity>> subscribe(
    SubscribeProParams params,
  ) async {
    try {
      final model = await remoteDataSource.subscribe(params);
      return Right(model.toEntity());
    } catch (e) {
      log('subscribePro repository error: $e');
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, ProUnsubscribeResultEntity>> unsubscribe(
    UnsubscribeProParams params,
  ) async {
    try {
      final model = await remoteDataSource.unsubscribe(params);
      return Right(model.toEntity());
    } catch (e) {
      log('unsubscribePro repository error: $e');
      return Left(e.toString());
    }
  }
}
