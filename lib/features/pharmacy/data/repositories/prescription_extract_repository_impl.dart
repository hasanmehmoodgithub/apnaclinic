import '../../../../core/functional/functional_export.dart';
import '../../domain/entities/prescription_extract_entity.dart';
import '../../domain/prescription_scan_error_codes.dart';
import '../../domain/repositories/prescription_extract_repository.dart';
import '../../domain/use_cases/extract_prescription_params.dart';
import '../data_sources/prescription_extract_remote_data_source.dart';

class PrescriptionExtractRepositoryImpl
    implements PrescriptionExtractRepository {
  PrescriptionExtractRepositoryImpl({required this.remoteDataSource});

  final PrescriptionExtractRemoteDataSource remoteDataSource;

  @override
  Future<Either<ErrorMsg, PrescriptionExtractEntity>> extract(
    ExtractPrescriptionParams params,
  ) async {
    try {
      final entity = await remoteDataSource.extract(filePath: params.filePath);
      return Right(entity);
    } on PrescriptionExtractException catch (error) {
      final detail = error.detail?.trim() ?? '';
      return Left(detail.isEmpty ? error.code : detail);
    } catch (_) {
      return const Left(PrescriptionScanErrorCodes.extractFailed);
    }
  }
}
