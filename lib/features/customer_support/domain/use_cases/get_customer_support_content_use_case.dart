import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/customer_support_entity.dart';
import '../repositories/customer_support_repository.dart';

class GetCustomerSupportContentUseCase
    implements UseCaseNoParams<CustomerSupportEntity> {
  GetCustomerSupportContentUseCase({required this.repository});

  final CustomerSupportRepository repository;

  CustomerSupportEntity? cachedContent() {
    return repository.getCachedCustomerSupportContent();
  }

  @override
  Future<Either<ErrorMsg, CustomerSupportEntity>> call() async {
    return await repository.getCustomerSupportContent();
  }
}
