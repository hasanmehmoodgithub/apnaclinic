import '../../../../core/functional/functional_export.dart';
import '../../../../core/failure/exceptions.dart';
import '../../model/your_mvvm_model.dart';
import '../data_sources/your_mvvm_local_data_source.dart';
import '../data_sources/your_mvvm_remote_data_source.dart';

/// Repository implementation - Example for MVVM
/// Simple example: GET list and POST create
class YourMvvmRepository {
  final YourMvvmRemoteDataSource remoteDataSource;
  final YourMvvmLocalDataSource localDataSource;

  YourMvvmRepository({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  /// GET: Get all items
  /// Tries remote first, falls back to local
  Future<Either<ErrorMsg, List<YourMvvmModel>>> getItems() async {
    try {
      // Try remote first
      final remoteItems = await remoteDataSource.getItems();

      // Save to local preference
      await localDataSource.saveItems(remoteItems);

      return Right(remoteItems);
    } catch (e) {
      // Fallback to local preference
      try {
        final localItems = await localDataSource.getItems();
        return Right(localItems);
      } catch (localError) {
        return Left('Failed to load items: ${localError.toString()}');
      }
    }
  }

  /// POST: Create a new item
  Future<Either<ErrorMsg, YourMvvmModel>> createItem({
    required String title,
    required String description,
  }) async {
    try {
      // POST: Create via API
      final item = await remoteDataSource.createItem(
        title: title,
        description: description,
      );

      // Save to local preference
      await localDataSource.saveItem(item);

      return Right(item);
    } catch (e) {
      return Left('Failed to create item: ${e.toString()}');
    }
  }
}
