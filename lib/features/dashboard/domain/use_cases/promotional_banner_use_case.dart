import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/promotional_banner_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetPromotionalBannerUseCase
    implements UseCaseNoParams<List<PromotionalBannerEntity>> {
  GetPromotionalBannerUseCase({required this.repository});

  final DashboardRepository repository;

  @override
  Future<Either<ErrorMsg, List<PromotionalBannerEntity>>> call() async {
    return await repository.getPromotionalBanner();
  }
}
