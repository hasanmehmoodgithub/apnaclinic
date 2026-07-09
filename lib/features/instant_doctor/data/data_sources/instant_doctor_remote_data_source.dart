import '../models/instant_doctor_model.dart';

abstract class InstantDoctorRemoteDataSource {
  Future<InstantDoctorResponseModel> getInstantDoctorContent({
    required String msisdn,
  });

  Future<void> sendSubscriptionOtp({
    required String msisdn,
    required int productId,
    required String uuid,
    required String action,
  });

  Future<InstantDoctorVerifyOtpResultModel> verifySubscriptionOtp({
    required String msisdn,
    required int productId,
    required String otp,
    required String uuid,
    required String action,
  });
}
