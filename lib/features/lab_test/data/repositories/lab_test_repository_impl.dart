import '../../../../core/cities/domain/repositories/cities_repository.dart';
import '../../../../core/functional/functional_export.dart';
import '../../domain/entities/lab_test_catalog_entity.dart';
import '../../domain/repositories/lab_test_repository.dart';
import '../data_sources/lab_test_remote_data_source.dart';
import '../mappers/lab_test_catalog_mapper.dart';

class LabTestRepositoryImpl implements LabTestRepository {
  LabTestRepositoryImpl({
    required this.remoteDataSource,
    required this.citiesRepository,
  });

  final LabTestRemoteDataSource remoteDataSource;
  final CitiesRepository citiesRepository;

  @override
  Future<Either<ErrorMsg, LabTestCatalogEntity>> getLabTestCatalog() async {
    try {
      final model = await remoteDataSource.getLabTestCatalog();
      final entity = LabTestCatalogMapper.toEntity(model);
      await citiesRepository.loadCities();
      final cityNames = citiesRepository.cityNames;
      return Right(
        LabTestCatalogEntity(
          cities: cityNames.isNotEmpty ? cityNames : entity.cities,
          items: entity.items,
          requirementLines: entity.requirementLines,
          partners: entity.partners,
          vendors: entity.vendors,
          pricing: entity.pricing,
        ),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }
}
