import '../../../../core/functional/functional_export.dart';
import '../entities/pro_catalog_entity.dart';

abstract class ProRepository {
  Future<Either<ErrorMsg, ProCatalogEntity>> getCatalog();
}
