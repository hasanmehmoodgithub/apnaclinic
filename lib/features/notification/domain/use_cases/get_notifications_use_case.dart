import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

class GetNotificationsParams {
  const GetNotificationsParams({
    this.page = 1,
    this.limit = 20,
  });

  final int page;
  final int limit;
}

class GetNotificationsUseCase
    implements UseCase<List<NotificationEntity>, GetNotificationsParams> {
  GetNotificationsUseCase({required this.repository});

  final NotificationRepository repository;

  @override
  Future<Either<ErrorMsg, List<NotificationEntity>>> call(
    GetNotificationsParams params,
  ) {
    return repository.getNotifications(
      page: params.page,
      limit: params.limit,
    );
  }
}
