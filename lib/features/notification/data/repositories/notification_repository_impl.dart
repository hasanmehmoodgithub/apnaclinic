import 'dart:developer';

import '../../../../core/functional/functional_export.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../data_sources/notification_remote_data_source.dart';
import '../mappers/notification_mapper.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl({required this.remoteDataSource});

  final NotificationRemoteDataSource remoteDataSource;

  @override
  Future<Either<ErrorMsg, List<NotificationEntity>>> getNotifications() async {
    try {
      final model = await remoteDataSource.getNotifications();
      final entities = NotificationMapper.toEntityList(model);
      log('Mapped notifications count: ${entities.length}');
      return Right(entities);
    } catch (e) {
      log('getNotifications repository error: $e');
      return Left(e.toString());
    }
  }
}
