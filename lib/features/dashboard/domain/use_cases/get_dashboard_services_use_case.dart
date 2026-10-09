import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/home_panel_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetOurServicesUseCase implements UseCaseNoParams<HomePanelEntity> {
  GetOurServicesUseCase({required this.repository});

  final DashboardRepository repository;

  @override
  Future<Either<ErrorMsg, HomePanelEntity>> call() async {
    return await repository.getOurServices();
  }
}

