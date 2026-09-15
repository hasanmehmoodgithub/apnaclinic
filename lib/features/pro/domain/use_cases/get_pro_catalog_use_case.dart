import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/pro_catalog_entity.dart';
import '../repositories/pro_repository.dart';

class GetProCatalogUseCase implements UseCaseNoParams<ProCatalogEntity> {
  GetProCatalogUseCase({required this.repository});

  final ProRepository repository;

  @override
  Future<Either<ErrorMsg, ProCatalogEntity>> call() {
    return repository.getCatalog();
  }
}
