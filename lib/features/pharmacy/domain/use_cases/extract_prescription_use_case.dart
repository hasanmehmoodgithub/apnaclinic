import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/prescription_extract_entity.dart';
import '../repositories/prescription_extract_repository.dart';
import 'extract_prescription_params.dart';

class ExtractPrescriptionUseCase
    implements UseCase<PrescriptionExtractEntity, ExtractPrescriptionParams> {
  ExtractPrescriptionUseCase({required this.repository});

  final PrescriptionExtractRepository repository;

  @override
  Future<Either<ErrorMsg, PrescriptionExtractEntity>> call(
    ExtractPrescriptionParams params,
  ) {
    return repository.extract(params);
  }
}
