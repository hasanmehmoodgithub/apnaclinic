import '../../../../core/functional/functional_export.dart';
import '../entities/consultation_category_entity.dart';

abstract class ConsultationRepository {
  Future<Either<ErrorMsg, List<ConsultationCategoryEntity>>> getCategories();
}
