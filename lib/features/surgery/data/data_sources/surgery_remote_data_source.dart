import '../../domain/entities/surgery_booking_request_entity.dart';
import '../models/surgery_content_model.dart';
import '../models/surgery_doctor_model.dart';
import '../models/surgery_lead_model.dart';
import '../models/surgery_patient_form_model.dart';
import '../models/surgery_provider_details_model.dart';

abstract class SurgeryRemoteDataSource {
  Future<SurgeryContentModel> getSurgeryContent({String? cityId});
  Future<SurgeryDoctorsResponseModel> getSurgeryDoctors({
    required String surgeryId,
    required String procedureName,
    required String city,
    required String cityId,
  });
  Future<SurgeryProviderDetailsModel> getSurgeryProviderDetails({
    required String surgeryId,
    required String cityId,
    required String doctorId,
  });
  Future<SurgeryPatientFormModel> getSurgeryPatientForm({
    required String doctorId,
  });
  Future<SurgeryLeadsPageModel> getSurgeryLeads({
    int page = 1,
    int limit = 20,
  });
  Future<void> submitSurgeryBooking(SurgeryBookingRequestEntity request);
  Future<void> bookSurgery({
    required int leadId,
    required String paymentMethod,
    required String msisdn,
  });
}
