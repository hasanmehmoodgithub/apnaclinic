import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

class GetNotificationsParams {
  const GetNotificationsParams();
}

class GetNotificationsUseCase
    implements UseCase<List<NotificationEntity>, GetNotificationsParams> {
  GetNotificationsUseCase({required this.repository});

  final NotificationRepository repository;

  @override
  Future<Either<ErrorMsg, List<NotificationEntity>>> call(
    GetNotificationsParams params,
  ) async {
    return await repository.getNotifications();
  }
}
