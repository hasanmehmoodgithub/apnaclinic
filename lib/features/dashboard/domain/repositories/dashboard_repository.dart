import '../../../../core/functional/functional_export.dart';
import '../entities/app_version_info_entity.dart';
import '../entities/home_panel_entity.dart';
import '../entities/promotional_banner_entity.dart';

abstract class DashboardRepository {
  Future<Either<ErrorMsg, HomePanelEntity>> getOurServices();
  Future<Either<ErrorMsg, List<PromotionalBannerEntity>>> getPromotionalBanner();
  Future<Either<ErrorMsg, AppVersionInfoEntity?>> getAppVersion({
    required String platform,
  });
}
