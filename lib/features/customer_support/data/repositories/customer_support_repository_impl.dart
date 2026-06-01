import 'dart:developer';

import '../../../../core/functional/functional_export.dart';
import '../../../dashboard/domain/repositories/dashboard_repository.dart';
import '../../domain/entities/customer_support_entity.dart';
import '../../domain/repositories/customer_support_repository.dart';
import '../mappers/customer_support_mapper.dart';

class CustomerSupportRepositoryImpl implements CustomerSupportRepository {
  CustomerSupportRepositoryImpl({required this.dashboardRepository});

  final DashboardRepository dashboardRepository;

  @override
  Future<Either<ErrorMsg, CustomerSupportEntity>>
  getCustomerSupportContent() async {
    final result = await dashboardRepository.getSupportSettings();
    return result.fold(
      Left.new,
      (settings) {
        final entity = CustomerSupportMapper.fromSupportSettings(settings);
        log(
          'Mapped customer support from CMS: phone=${settings.phone.isNotEmpty}, '
          'email=${settings.hasEmail}',
        );
        return Right(entity);
      },
    );
  }
}
