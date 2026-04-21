import '../../../../core/functional/functional_export.dart';
import '../../domain/entities/lab_test_catalog_entity.dart';
import '../../domain/repositories/lab_test_repository.dart';
import '../data_sources/lab_test_remote_data_source.dart';
import '../mappers/lab_test_catalog_mapper.dart';

class LabTestRepositoryImpl implements LabTestRepository {
  LabTestRepositoryImpl({required this.remoteDataSource});

  final LabTestRemoteDataSource remoteDataSource;

  @override
  Future<Either<ErrorMsg, LabTestCatalogEntity>> getLabTestCatalog() async {
    try {
      final model = await remoteDataSource.getLabTestCatalog();
      final entity = LabTestCatalogMapper.toEntity(model);
      return Right(entity);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
