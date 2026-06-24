import '../models/instant_doctor_model.dart';

abstract class InstantDoctorRemoteDataSource {
  Future<InstantDoctorResponseModel> getInstantDoctorContent({
    required String msisdn,
  });
}
