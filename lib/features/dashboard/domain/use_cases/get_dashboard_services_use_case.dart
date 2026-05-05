import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/our_service_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetOurServicesUseCase
    implements UseCaseNoParams<List<OurServiceEntity>> {
  GetOurServicesUseCase({required this.repository});

  final DashboardRepository repository;

  @override
  Future<Either<ErrorMsg, List<OurServiceEntity>>> call() async {
    return await repository.getOurServices();
  }
}

