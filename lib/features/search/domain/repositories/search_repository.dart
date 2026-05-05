import '../../../../core/functional/functional_export.dart';
import '../entities/search_entity.dart';

abstract class SearchRepository {
  Future<Either<ErrorMsg, SearchContentEntity>> getSearchContent({
    required String query,
    required bool listening,
    required bool submitted,
  });
}
