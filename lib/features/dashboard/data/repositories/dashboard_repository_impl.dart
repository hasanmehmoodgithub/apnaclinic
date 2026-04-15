import 'dart:developer';

import '../../../../core/failure/exceptions.dart';
import '../../../../core/functional/functional_export.dart';
import '../../domain/entities/promotional_banner_entity.dart';
import '../../domain/entities/our_service_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../data_sources/dashboard_remote_data_source.dart';
import '../mappers/our_promotional_banner_mapper.dart';
import '../mappers/our_services_mapper.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl({required this.remoteDataSource});

  final DashboardRemoteDataSource remoteDataSource;

  @override
  Future<Either<ErrorMsg, List<OurServiceEntity>>> getOurServices() async {
    try {
      final model = await remoteDataSource.getOurServices();
      final entities = DashboardServicesMapper.toEntityList(model);
      log('Mapped dashboard services count: ${entities.length}');
      return Right(entities);
    } catch (e) {
      log('getDashboardServices repository error: $e');
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, PromotionalBannerEntity>> getPromotionalBanner() async {
    try {
      final model = await remoteDataSource.getPromotionalBanner();
      final entity = PromotionalBannerMapper.toEntity(model);
      return Right(entity);
    } catch (e) {
      log('getPromotionalBanner repository error: $e');
      return Left(e.toString());
    }
  }
}

