import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/prescription_extract_entity.dart';
import '../repositories/pharmacy_repository.dart';
import 'extract_prescription_params.dart';

class ExtractPrescriptionUseCase
    implements UseCase<PrescriptionExtractEntity, ExtractPrescriptionParams> {
  ExtractPrescriptionUseCase({required this.repository});

  final PharmacyRepository repository;

  @override
  Future<Either<ErrorMsg, PrescriptionExtractEntity>> call(
    ExtractPrescriptionParams params,
  ) {
    return repository.extractPrescription(params);
  }
}
