import '../../domain/use_cases/get_instant_doctor_bookings_params.dart';
import '../models/instant_doctor_booking_model.dart';
import '../models/instant_doctor_model.dart';

abstract class InstantDoctorRemoteDataSource {
  Future<InstantDoctorResponseModel> getInstantDoctorContent({
    required String msisdn,
  });

  Future<InstantDoctorBookingsPageModel> getBookings(
    GetInstantDoctorBookingsParams params,
  );

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

  Future<void> logSession({
    required String startTime,
    required String endTime,
    required String instantDocLog,
    required String providerName,
  });
}
