import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/pro_subscribe_result_entity.dart';
import '../repositories/pro_repository.dart';
import 'subscribe_pro_params.dart';

class SubscribeProUseCase
    implements UseCase<ProSubscribeResultEntity, SubscribeProParams> {
  SubscribeProUseCase({required this.repository});

  final ProRepository repository;

  @override
  Future<Either<ErrorMsg, ProSubscribeResultEntity>> call(
    SubscribeProParams params,
  ) {
    return repository.subscribe(params);
  }
}
