import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/consultation_category_entity.dart';
import '../repositories/consultation_repository.dart';

class GetConsultationCategoriesUseCase
    implements UseCaseNoParams<List<ConsultationCategoryEntity>> {
  final ConsultationRepository repository;

  GetConsultationCategoriesUseCase({required this.repository});

  @override
  Future<Either<ErrorMsg, List<ConsultationCategoryEntity>>> call() {
    return repository.getCategories();
  }
}
