import '../../../../core/functional/functional_export.dart';
import '../../domain/entities/consultation_category_entity.dart';
import '../../domain/repositories/consultation_repository.dart';
import '../data_sources/consultation_remote_data_source.dart';

class ConsultationRepositoryImpl implements ConsultationRepository {
  ConsultationRepositoryImpl({required this.remoteDataSource});

  final ConsultationRemoteDataSource remoteDataSource;

  @override
  Future<Either<ErrorMsg, List<ConsultationCategoryEntity>>>
  getCategories() async {
    try {
      final categories = await remoteDataSource.getCategories();
      return Right(categories);
    } catch (e) {
      if (e is String && e.trim().isNotEmpty) {
        return Left(e.trim());
      }
      return const Left('Unable to load consultation categories.');
    }
  }
}
