import '../../../../core/functional/functional_export.dart';
import '../entities/surgery_booking_request_entity.dart';
import '../entities/surgery_doctor_entity.dart';
import '../entities/surgery_patient_form_entity.dart';
import '../entities/surgery_procedure_entity.dart';

abstract class SurgeryRepository {
  Future<Either<ErrorMsg, SurgeryContentEntity>> getSurgeryContent();
  Future<Either<ErrorMsg, SurgeryDoctorsEntity>> getSurgeryDoctors({
    required String procedureName,
    required String city,
  });
  Future<Either<ErrorMsg, SurgeryPatientFormEntity>> getSurgeryPatientForm({
    required String doctorId,
  });
  Future<Either<ErrorMsg, void>> submitSurgeryBooking(
    SurgeryBookingRequestEntity request,
  );
}
