import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/surgery_booking_request_entity.dart';
import '../repositories/surgery_repository.dart';

class SubmitSurgeryBookingParams {
  const SubmitSurgeryBookingParams({
    required this.patientName,
    required this.age,
    required this.contactNumber,
    required this.emergencyContact,
    required this.surgeryName,
    required this.doctorName,
    required this.hospitalName,
    required this.gender,
  });

  final String patientName;
  final String age;
  final String contactNumber;
  final String emergencyContact;
  final String surgeryName;
  final String doctorName;
  final String hospitalName;
  final String gender;

  SurgeryBookingRequestEntity toEntity() {
    return SurgeryBookingRequestEntity(
      patientName: patientName,
      age: age,
      contactNumber: contactNumber,
      emergencyContact: emergencyContact,
      surgeryName: surgeryName,
      doctorName: doctorName,
      hospitalName: hospitalName,
      gender: gender,
    );
  }
}

class SubmitSurgeryBookingUseCase
    implements UseCaseVoid<SubmitSurgeryBookingParams> {
  SubmitSurgeryBookingUseCase({required this.repository});

  final SurgeryRepository repository;

  @override
  Future<Either<ErrorMsg, void>> call(SubmitSurgeryBookingParams params) async {
    return await repository.submitSurgeryBooking(params.toEntity());
  }
}
