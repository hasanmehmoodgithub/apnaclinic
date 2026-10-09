import 'dart:developer';

import '../../../../core/functional/functional_export.dart';
import '../../domain/entities/app_version_info_entity.dart';
import '../../domain/entities/home_panel_entity.dart';
import '../../domain/entities/promotional_banner_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../data_sources/dashboard_remote_data_source.dart';
import '../mappers/app_version_mapper.dart';
import '../mappers/our_promotional_banner_mapper.dart';
import '../mappers/our_services_mapper.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl({required this.remoteDataSource});

  final DashboardRemoteDataSource remoteDataSource;

  @override
  Future<Either<ErrorMsg, HomePanelEntity>> getOurServices() async {
    try {
      final model = await remoteDataSource.getOurServices();
      final panel = DashboardServicesMapper.toEntity(model);
      log('Mapped dashboard services count: ${panel.services.length}');
      return Right(panel);
    } catch (e) {
      log('getDashboardServices repository error: $e');
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, List<PromotionalBannerEntity>>> getPromotionalBanner() async {
    try {
      final model = await remoteDataSource.getPromotionalBanner();
      final entities = PromotionalBannerMapper.toEntityList(model);
      log('Mapped promotional banners count: ${entities.length}');
      return Right(entities);
    } catch (e) {
      log('getPromotionalBanner repository error: $e');
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, AppVersionInfoEntity?>> getAppVersion({
    required String platform,
  }) async {
    try {
      final model =
          await remoteDataSource.getAppVersion(platform: platform);
      final entity = AppVersionMapper.toEntity(model);
      log(
        'Mapped app version: ${entity?.latestVersion ?? 'none'} '
        '(platform=$platform)',
      );
      return Right(entity);
    } catch (e) {
      log('getAppVersion repository error: $e');
      return Left(e.toString());
    }
  }
}
