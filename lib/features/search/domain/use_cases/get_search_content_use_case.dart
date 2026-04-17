import '../../../../core/failure/exceptions.dart';
import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/search_entity.dart';
import '../repositories/search_repository.dart';

class GetSearchContentParams {
  const GetSearchContentParams({
    required this.query,
    required this.listening,
    required this.submitted,
  });

  final String query;
  final bool listening;
  final bool submitted;
}

class GetSearchContentUseCase
    implements UseCase<SearchContentEntity, GetSearchContentParams> {
  GetSearchContentUseCase({required this.repository});

  final SearchRepository repository;

  @override
  Future<Either<ErrorMsg, SearchContentEntity>> call(
    GetSearchContentParams params,
  ) async {
    return await repository.getSearchContent(
      query: params.query,
      listening: params.listening,
      submitted: params.submitted,
    );
  }
}
