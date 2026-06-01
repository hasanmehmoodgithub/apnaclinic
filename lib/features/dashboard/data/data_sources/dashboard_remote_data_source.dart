import '../models/our_service_model.dart';
import '../models/promotional_banner_model.dart';
import '../models/support_settings_model.dart';

abstract class DashboardRemoteDataSource {
  Future<OurServicesModel> getOurServices();
  Future<PromotionalBannerResponseModel> getPromotionalBanner();
  Future<SupportSettingsResponseModel> getSupportSettings();
}

