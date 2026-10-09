import '../../domain/use_cases/subscribe_pro_params.dart';
import '../../domain/use_cases/unsubscribe_pro_params.dart';
import '../models/pro_catalog_model.dart';
import '../models/pro_subscribe_response_model.dart';
import '../models/pro_unsubscribe_response_model.dart';

abstract class ProRemoteDataSource {
  Future<ProCatalogModel> getCatalog();

  Future<ProSubscribeResponseModel> subscribe(SubscribeProParams params);

  Future<ProUnsubscribeResponseModel> unsubscribe(UnsubscribeProParams params);
}
