import '../models/our_service_model.dart';

abstract class DashboardRemoteDataSource {
  Future<OurServicesModel> getOurServices();
}

