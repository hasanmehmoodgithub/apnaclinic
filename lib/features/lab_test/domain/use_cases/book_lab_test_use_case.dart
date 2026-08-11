import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../../../payment/domain/entities/payment_initiation_result.dart';
import '../repositories/lab_test_repository.dart';

class BookLabTestPatientParams {
  const BookLabTestPatientParams({
    required this.name,
    required this.age,
    required this.gender,
    required this.phoneNumber,
  });

  final String name;
  final String age;
  final String gender;
  final String phoneNumber;
}

class BookLabTestParams {
  const BookLabTestParams({
    required this.partnerId,
    required this.labId,
    required this.cityName,
    required this.homeSample,
    required this.paymentMethod,
    required this.msisdn,
    required this.patient,
    required this.testIds,
  });

  final String partnerId;
  final String labId;
  final String cityName;
  final bool homeSample;
  final String paymentMethod;
  final String msisdn;
  final BookLabTestPatientParams patient;
  final List<int> testIds;
}

class BookLabTestUseCase
    implements UseCase<PaymentInitiationResult, BookLabTestParams> {
  BookLabTestUseCase({required this.repository});

  final LabTestRepository repository;

  @override
  Future<Either<ErrorMsg, PaymentInitiationResult>> call(
    BookLabTestParams params,
  ) {
    return repository.bookLabTest(params);
  }
}
