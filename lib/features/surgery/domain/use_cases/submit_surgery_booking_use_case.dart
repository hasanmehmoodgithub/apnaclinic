import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/surgery_booking_request_entity.dart';
import '../repositories/surgery_repository.dart';

class SubmitSurgeryBookingParams {
  const SubmitSurgeryBookingParams({
    required this.doctorId,
    required this.surgeryId,
    required this.packageId,
    required this.cityId,
    required this.patientName,
    required this.age,
    required this.gender,
    required this.phone,
    required this.emergencyPhone,
  });

  final String doctorId;

  /// Procedure id from surgery list.
  final String surgeryId;

  /// Selected package id from provider-details.
  final String packageId;
  final String cityId;
  final String patientName;
  final String age;
  final String gender;
  final String phone;
  final String emergencyPhone;

  SurgeryBookingRequestEntity toEntity() {
    return SurgeryBookingRequestEntity(
      doctorId: doctorId,
      surgeryId: surgeryId,
      packageId: packageId,
      cityId: cityId,
      patientName: patientName,
      age: age,
      gender: gender,
      phone: phone,
      emergencyPhone: emergencyPhone,
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
