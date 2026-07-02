import '../../../../core/functional/functional_export.dart';
import '../entities/surgery_booking_request_entity.dart';
import '../entities/surgery_doctor_entity.dart';
import '../entities/surgery_patient_form_entity.dart';
import '../entities/surgery_procedure_entity.dart';
import '../entities/surgery_provider_details_entity.dart';

abstract class SurgeryRepository {
  Future<Either<ErrorMsg, SurgeryContentEntity>> getSurgeryContent({
    String? city,
  });
  Future<Either<ErrorMsg, SurgeryDoctorsEntity>> getSurgeryDoctors({
    required String surgeryId,
    required String procedureName,
    required String city,
  });
  Future<Either<ErrorMsg, SurgeryProviderDetailsEntity>> getSurgeryProviderDetails({
    required String surgeryId,
    required String cityId,
    required String doctorId,
  });
  Future<Either<ErrorMsg, SurgeryPatientFormEntity>> getSurgeryPatientForm({
    required String doctorId,
  });
  Future<Either<ErrorMsg, void>> submitSurgeryBooking(
    SurgeryBookingRequestEntity request,
  );
}
