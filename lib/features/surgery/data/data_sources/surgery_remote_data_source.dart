import '../models/surgery_content_model.dart';
import '../../domain/entities/surgery_booking_request_entity.dart';

abstract class SurgeryRemoteDataSource {
  Future<SurgeryContentModel> getSurgeryContent();
  Future<void> submitSurgeryBooking(SurgeryBookingRequestEntity request);
}
