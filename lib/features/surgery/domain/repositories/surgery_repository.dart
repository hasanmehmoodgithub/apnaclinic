import '../../../../core/functional/functional_export.dart';
import '../entities/surgery_booking_request_entity.dart';
import '../entities/surgery_procedure_entity.dart';

abstract class SurgeryRepository {
  Future<Either<ErrorMsg, SurgeryContentEntity>> getSurgeryContent();
  Future<Either<ErrorMsg, void>> submitSurgeryBooking(
    SurgeryBookingRequestEntity request,
  );
}
