import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/support_settings_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetSupportSettingsUseCase
    implements UseCaseNoParams<SupportSettingsEntity> {
  GetSupportSettingsUseCase({required this.repository});

  final DashboardRepository repository;

  @override
  Future<Either<ErrorMsg, SupportSettingsEntity>> call() async {
    return repository.getSupportSettings();
  }
}
