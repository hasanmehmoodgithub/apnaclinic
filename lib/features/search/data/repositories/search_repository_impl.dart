import '../../../../core/failure/exceptions.dart';
import '../../../../core/functional/functional_export.dart';
import '../../domain/entities/search_entity.dart';
import '../../domain/repositories/search_repository.dart';
import '../data_sources/search_remote_data_source.dart';
import '../mappers/search_mapper.dart';

class SearchRepositoryImpl implements SearchRepository {
  SearchRepositoryImpl({required this.remoteDataSource});

  final SearchRemoteDataSource remoteDataSource;

  @override
  Future<Either<ErrorMsg, SearchContentEntity>> getSearchContent({
    required String query,
    required bool listening,
    required bool submitted,
  }) async {
    try {
      final model = await remoteDataSource.getSearchContent(
        query: query,
        listening: listening,
        submitted: submitted,
      );
      return Right(SearchMapper.toEntity(model));
    } catch (e) {
      return Left(e.toString());
    }
  }
}
