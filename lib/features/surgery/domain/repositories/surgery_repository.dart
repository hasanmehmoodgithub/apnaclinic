import '../../../../core/functional/functional_export.dart';
import '../entities/surgery_booking_request_entity.dart';
import '../entities/surgery_doctor_entity.dart';
import '../entities/surgery_lead_entity.dart';
import '../entities/surgery_patient_form_entity.dart';
import '../entities/surgery_procedure_entity.dart';
import '../entities/surgery_provider_details_entity.dart';
import '../use_cases/book_surgery_use_case.dart';

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
  Future<Either<ErrorMsg, SurgeryLeadsPageEntity>> getSurgeryLeads({
    int page = 1,
    int limit = 20,
  });

  Future<Either<ErrorMsg, SurgeryLeadEntity>> getSurgeryLead({
    required int leadId,
  });

  Future<Either<ErrorMsg, void>> submitSurgeryBooking(
    SurgeryBookingRequestEntity request,
  );
  Future<Either<ErrorMsg, void>> bookSurgery(BookSurgeryParams params);
}
