import '../models/free_doctor_model.dart';

abstract class FreeDoctorRemoteDataSource {
  Future<FreeDoctorResponseModel> getFreeDoctorContent({
    required String msisdn,
  });
}
