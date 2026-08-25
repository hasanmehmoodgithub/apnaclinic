import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/consultation_categories_page_entity.dart';
import '../repositories/consultation_repository.dart';

class GetConsultationCategoriesUseCase
    implements UseCaseNoParams<ConsultationCategoriesPageEntity> {
  final ConsultationRepository repository;

  GetConsultationCategoriesUseCase({required this.repository});

  @override
  Future<Either<ErrorMsg, ConsultationCategoriesPageEntity>> call() {
    return repository.getCategories();
  }
}
