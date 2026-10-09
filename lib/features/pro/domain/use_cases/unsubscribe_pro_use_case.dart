import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/pro_unsubscribe_result_entity.dart';
import '../repositories/pro_repository.dart';
import 'unsubscribe_pro_params.dart';

class UnsubscribeProUseCase
    implements UseCase<ProUnsubscribeResultEntity, UnsubscribeProParams> {
  UnsubscribeProUseCase({required this.repository});

  final ProRepository repository;

  @override
  Future<Either<ErrorMsg, ProUnsubscribeResultEntity>> call(
    UnsubscribeProParams params,
  ) {
    return repository.unsubscribe(params);
  }
}
