import '../../../../core/functional/functional_export.dart';
import '../../../../core/failure/exceptions.dart';
import '../../domain/entities/your_feature_entity.dart';
import '../../domain/repositories/your_feature_repository.dart';
import '../../domain/use_cases/create_feature_params.dart';
import '../data_sources/your_feature_local_data_source.dart';
import '../data_sources/your_feature_remote_data_source.dart';
import '../mappers/your_feature_mapper.dart';

/// Repository implementation - Example for Clean Architecture
/// Simple example: GET list and POST create
/// This is a sample repository for understanding Clean Architecture structure
class YourFeatureRepositoryImpl implements YourFeatureRepository {
  final YourFeatureRemoteDataSource remoteDataSource;
  final YourFeatureLocalDataSource localDataSource;

  YourFeatureRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<ErrorMsg, List<YourFeatureEntity>>> getFeatures() async {
    try {
      // GET: Try remote first, fallback to local
      final remoteFeatures = await remoteDataSource.getFeatures();

      // Save to local preference
      await localDataSource.saveFeatures(remoteFeatures);

      // Convert to entities
      final entities = remoteFeatures
          .map((model) => YourFeatureMapper.toEntity(model))
          .toList();
      return Right(entities);
    } catch (e) {
      // Fallback to local preference
      try {
        final localFeatures = await localDataSource.getFeatures();
        final entities = localFeatures
            .map((model) => YourFeatureMapper.toEntity(model))
            .toList();
        return Right(entities);
      } catch (localError) {
        return Left('Failed to load features: ${localError.toString()}');
      }
    }
  }

  @override
  Future<Either<ErrorMsg, YourFeatureEntity>> createFeature(
    CreateFeatureParams params,
  ) async {
    try {
      // POST: Pass params object through to data source
      final feature = await remoteDataSource.createFeature(params);

      // Save to local preference
      await localDataSource.saveFeature(feature);

      return Right(YourFeatureMapper.toEntity(feature));
    } catch (e) {
      return Left('Failed to create feature: ${e.toString()}');
    }
  }
}
