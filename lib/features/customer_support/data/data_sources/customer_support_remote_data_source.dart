import '../models/customer_support_model.dart';

abstract class CustomerSupportRemoteDataSource {
  Future<CustomerSupportResponseModel> getCustomerSupportContent();
}
