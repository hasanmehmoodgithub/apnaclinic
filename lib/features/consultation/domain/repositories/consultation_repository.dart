import '../../../../core/functional/functional_export.dart';
import '../entities/consultation_doctors_page_entity.dart';
import '../entities/consultation_booking_list_entity.dart';
import '../entities/consultation_category_entity.dart';
import '../entities/consultation_doctor_slots_entity.dart';
import '../entities/payment_provider_entity.dart';
import '../use_cases/submit_consultation_booking_use_case.dart';
import '../use_cases/submit_consultation_feedback_use_case.dart';

abstract class ConsultationRepository {
  Future<Either<ErrorMsg, List<ConsultationCategoryEntity>>> getCategories();
  Future<Either<ErrorMsg, ConsultationDoctorsPageEntity>> getDoctors({
    required String mainCategoryId,
    String? partnerId,
    String? search,
    int page = 1,
    int limit = 20,
  });
  Future<Either<ErrorMsg, ConsultationDoctorSlotsEntity>> getDoctorSlots({
    required String doctorId,
    String? hospitalId,
  });
  Future<Either<ErrorMsg, List<PaymentProviderEntity>>> getPaymentProviders();
  Future<Either<ErrorMsg, ConsultationBookingsPageEntity>> getBookings({
    int page = 1,
    int limit = 20,
  });
  Future<Either<ErrorMsg, void>> submitBooking(
    SubmitConsultationBookingParams params,
  );
  Future<Either<ErrorMsg, void>> submitFeedback(
    SubmitConsultationFeedbackParams params,
  );
}
