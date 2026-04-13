import '../../../../core/functional/functional_export.dart';
import '../../domain/entities/consultation_category_entity.dart';
import '../../domain/repositories/consultation_repository.dart';
import '../data_sources/consultation_local_data_source.dart';

class ConsultationRepositoryImpl implements ConsultationRepository {
  final ConsultationLocalDataSource localDataSource;

  ConsultationRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<ErrorMsg, List<ConsultationCategoryEntity>>>
  getCategories() async {
    try {
      final categories = await localDataSource.getCategories();
      return Right(categories);
    } catch (e) {
      return Left('Unable to load consultation categories.');
    }
  }
}
