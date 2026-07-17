import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../repositories/notification_repository.dart';

class MarkNotificationReadParams {
  const MarkNotificationReadParams({required this.publicId});

  final String publicId;
}

class MarkNotificationReadUseCase
    implements UseCase<void, MarkNotificationReadParams> {
  MarkNotificationReadUseCase({required this.repository});

  final NotificationRepository repository;

  @override
  Future<Either<ErrorMsg, void>> call(MarkNotificationReadParams params) {
    return repository.markNotificationRead(publicId: params.publicId);
  }
}
