import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../repositories/instant_doctor_repository.dart';
import 'log_instant_doctor_session_params.dart';

class LogInstantDoctorSessionUseCase
    implements UseCaseVoid<LogInstantDoctorSessionParams> {
  LogInstantDoctorSessionUseCase({required this.repository});

  final InstantDoctorRepository repository;

  @override
  Future<Either<ErrorMsg, void>> call(LogInstantDoctorSessionParams params) {
    return repository.logSession(params);
  }
}
