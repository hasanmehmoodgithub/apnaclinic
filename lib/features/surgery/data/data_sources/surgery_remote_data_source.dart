import '../../domain/entities/surgery_booking_request_entity.dart';
import '../models/surgery_content_model.dart';
import '../models/surgery_doctor_model.dart';
import '../models/surgery_patient_form_model.dart';

abstract class SurgeryRemoteDataSource {
  Future<SurgeryContentModel> getSurgeryContent();
  Future<SurgeryDoctorsResponseModel> getSurgeryDoctors({
    required String surgeryId,
    required String procedureName,
    required String city,
  });
  Future<SurgeryPatientFormModel> getSurgeryPatientForm({
    required String doctorId,
  });
  Future<void> submitSurgeryBooking(SurgeryBookingRequestEntity request);
}
