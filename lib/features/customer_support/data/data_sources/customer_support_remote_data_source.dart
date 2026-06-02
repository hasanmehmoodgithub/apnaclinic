import '../models/support_settings_model.dart';

abstract class CustomerSupportRemoteDataSource {
  Future<SupportSettingsResponseModel> getSupportSettings();
}
