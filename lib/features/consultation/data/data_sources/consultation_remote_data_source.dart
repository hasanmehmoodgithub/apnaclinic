import '../../domain/use_cases/submit_consultation_booking_use_case.dart';
import '../../domain/use_cases/submit_consultation_feedback_use_case.dart';
import '../models/consultation_booking_list_model.dart';
import '../models/consultation_category_model.dart';
import '../models/consultation_doctor_model.dart';
import '../models/consultation_doctor_slots_model.dart';
import '../models/payment_provider_model.dart';

abstract class ConsultationRemoteDataSource {
  Future<List<ConsultationCategoryModel>> getCategories();
  Future<ConsultationDoctorsResponseModel> getDoctors({
    required String mainCategoryId,
    String? partnerId,
    String? search,
    int page = 1,
    int limit = 20,
  });
  Future<ConsultationDoctorSlotsModel> getDoctorSlots({
    required String doctorId,
    String? hospitalId,
  });
  Future<List<PaymentProviderModel>> getPaymentProviders();
  Future<ConsultationBookingsPageModel> getBookings({
    int page = 1,
    int limit = 20,
  });
  Future<ConsultationBookingListItemModel> getBooking({
    required int appointmentId,
  });
  Future<void> submitBooking(SubmitConsultationBookingParams params);
  Future<void> submitFeedback(SubmitConsultationFeedbackParams params);
}
