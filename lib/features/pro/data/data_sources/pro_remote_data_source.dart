import '../models/pro_catalog_model.dart';

abstract class ProRemoteDataSource {
  Future<ProCatalogModel> getCatalog();
}
