import '../../../../core/functional/functional_export.dart';
import '../entities/customer_support_entity.dart';

abstract class CustomerSupportRepository {
  Future<Either<ErrorMsg, CustomerSupportEntity>> getCustomerSupportContent();
}
