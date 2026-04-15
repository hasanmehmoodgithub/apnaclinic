import '../../../../core/failure/exceptions.dart';
import '../../../../core/functional/functional_export.dart';
import '../entities/promotional_banner_entity.dart';
import '../entities/our_service_entity.dart';

abstract class DashboardRepository {
  Future<Either<ErrorMsg, List<OurServiceEntity>>> getOurServices();
  Future<Either<ErrorMsg, PromotionalBannerEntity>> getPromotionalBanner();
}

