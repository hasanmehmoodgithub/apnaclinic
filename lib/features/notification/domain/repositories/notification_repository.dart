import '../../../../core/functional/functional_export.dart';
import '../entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<Either<ErrorMsg, List<NotificationEntity>>> getNotifications();
}
