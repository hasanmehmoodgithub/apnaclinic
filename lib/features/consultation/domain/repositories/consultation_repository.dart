import '../../../../core/functional/functional_export.dart';
import '../../../payment/domain/entities/payment_initiation_result.dart';
import '../entities/consultation_doctors_page_entity.dart';
import '../entities/consultation_booking_list_entity.dart';
import '../entities/consultation_categories_page_entity.dart';
import '../entities/consultation_doctor_detail_entity.dart';
import '../entities/consultation_doctor_slots_entity.dart';
import '../entities/payment_provider_entity.dart';
import '../use_cases/abandon_consultation_booking_use_case.dart';
import '../use_cases/record_ai_assistant_interaction_use_case.dart';
import '../use_cases/submit_consultation_booking_use_case.dart';
import '../use_cases/submit_consultation_feedback_use_case.dart';

abstract class ConsultationRepository {
  Future<Either<ErrorMsg, ConsultationCategoriesPageEntity>> getCategories();
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
  Future<Either<ErrorMsg, ConsultationDoctorDetailEntity>> getDoctorDetail({
    required String doctorId,
  });
  Future<Either<ErrorMsg, List<PaymentProviderEntity>>> getPaymentProviders({
    required String module,
  });
  Future<Either<ErrorMsg, ConsultationBookingsPageEntity>> getBookings({
    int page = 1,
    int limit = 20,
  });
  Future<Either<ErrorMsg, ConsultationBookingListItemEntity>> getBooking({
    required int appointmentId,
  });
  Future<Either<ErrorMsg, PaymentInitiationResult>> submitBooking(
    SubmitConsultationBookingParams params,
  );
  Future<Either<ErrorMsg, bool>> abandonBooking(
    AbandonConsultationBookingParams params,
  );
  Future<Either<ErrorMsg, void>> submitFeedback(
    SubmitConsultationFeedbackParams params,
  );
  Future<Either<ErrorMsg, void>> recordAiAssistantInteraction(
    RecordAiAssistantInteractionParams params,
  );
}
