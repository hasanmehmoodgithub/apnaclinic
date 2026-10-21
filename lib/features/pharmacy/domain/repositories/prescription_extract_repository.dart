import '../../../../core/functional/functional_export.dart';
import '../entities/prescription_extract_entity.dart';
import '../use_cases/extract_prescription_params.dart';

abstract class PrescriptionExtractRepository {
  Future<Either<ErrorMsg, PrescriptionExtractEntity>> extract(
    ExtractPrescriptionParams params,
  );
}
