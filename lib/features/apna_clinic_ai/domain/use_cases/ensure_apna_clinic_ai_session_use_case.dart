import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/apna_clinic_ai_session_entity.dart';
import '../repositories/apna_clinic_ai_repository.dart';
import 'init_apna_clinic_ai_session_params.dart';

class EnsureApnaClinicAiSessionUseCase
    implements UseCase<ApnaClinicAiSessionEntity, InitApnaClinicAiSessionParams> {
  EnsureApnaClinicAiSessionUseCase({required this.repository});

  final ApnaClinicAiRepository repository;

  @override
  Future<Either<ErrorMsg, ApnaClinicAiSessionEntity>> call(
    InitApnaClinicAiSessionParams params,
  ) {
    return repository.ensureSession(params);
  }
}
