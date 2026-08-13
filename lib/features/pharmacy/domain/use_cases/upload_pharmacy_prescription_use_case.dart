import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../repositories/pharmacy_repository.dart';

class UploadPharmacyPrescriptionParams {
  const UploadPharmacyPrescriptionParams({
    required this.productId,
    required this.filePath,
    required this.fileName,
  });

  final String productId;
  final String filePath;
  final String fileName;
}

class UploadPharmacyPrescriptionUseCase
    implements UseCase<String, UploadPharmacyPrescriptionParams> {
  UploadPharmacyPrescriptionUseCase({required this.repository});

  final PharmacyRepository repository;

  @override
  Future<Either<ErrorMsg, String>> call(
    UploadPharmacyPrescriptionParams params,
  ) {
    return repository.uploadPrescription(
      productId: params.productId,
      filePath: params.filePath,
      fileName: params.fileName,
    );
  }
}
