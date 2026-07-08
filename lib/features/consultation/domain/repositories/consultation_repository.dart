import '../../../../core/functional/functional_export.dart';
import '../../presentation/widgets/results_doctor_item.dart';
import '../entities/consultation_category_entity.dart';
import '../entities/consultation_doctor_slots_entity.dart';
import '../entities/payment_provider_entity.dart';
import '../use_cases/submit_consultation_booking_use_case.dart';

abstract class ConsultationRepository {
  Future<Either<ErrorMsg, List<ConsultationCategoryEntity>>> getCategories();
  Future<Either<ErrorMsg, List<ResultsDoctorItem>>> getDoctors({
    required String mainCategoryId,
  });
  Future<Either<ErrorMsg, ConsultationDoctorSlotsEntity>> getDoctorSlots({
    required String doctorId,
    String? hospitalId,
  });
  Future<Either<ErrorMsg, List<PaymentProviderEntity>>> getPaymentProviders();
  Future<Either<ErrorMsg, void>> submitBooking(
    SubmitConsultationBookingParams params,
  );
}
