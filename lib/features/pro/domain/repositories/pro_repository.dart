import '../../../../core/functional/functional_export.dart';
import '../entities/pro_catalog_entity.dart';
import '../entities/pro_subscribe_result_entity.dart';
import '../entities/pro_unsubscribe_result_entity.dart';
import '../use_cases/subscribe_pro_params.dart';
import '../use_cases/unsubscribe_pro_params.dart';

abstract class ProRepository {
  Future<Either<ErrorMsg, ProCatalogEntity>> getCatalog();

  Future<Either<ErrorMsg, ProSubscribeResultEntity>> subscribe(
    SubscribeProParams params,
  );

  Future<Either<ErrorMsg, ProUnsubscribeResultEntity>> unsubscribe(
    UnsubscribeProParams params,
  );
}
