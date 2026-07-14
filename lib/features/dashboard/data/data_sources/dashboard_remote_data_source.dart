import '../models/app_version_model.dart';
import '../models/our_service_model.dart';
import '../models/promotional_banner_model.dart';

abstract class DashboardRemoteDataSource {
  Future<OurServicesModel> getOurServices();
  Future<PromotionalBannerResponseModel> getPromotionalBanner();
  Future<AppVersionResponseModel> getAppVersion({required String platform});
}

