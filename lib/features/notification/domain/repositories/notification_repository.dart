import '../../../../core/functional/functional_export.dart';
import '../entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<Either<ErrorMsg, List<NotificationEntity>>> getNotifications({
    int page = 1,
    int limit = 20,
  });

  Future<Either<ErrorMsg, void>> markNotificationRead({
    required String publicId,
  });
}
