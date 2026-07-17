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
  Future<Either<ErrorMsg, List<NotificationEntity>>> getNotifications({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final model = await remoteDataSource.getNotifications(
        page: page,
        limit: limit,
      );
      final entities = NotificationMapper.toEntityList(model);
      log('Mapped notifications count: ${entities.length}');
      return Right(entities);
    } catch (e) {
      log('getNotifications repository error: $e');
      if (e is String && e.trim().isNotEmpty) {
        return Left(e.trim());
      }
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, void>> markNotificationRead({
    required String publicId,
  }) async {
    try {
      await remoteDataSource.markNotificationRead(publicId: publicId);
      return const Right(null);
    } catch (e) {
      log('markNotificationRead repository error: $e');
      if (e is String && e.trim().isNotEmpty) {
        return Left(e.trim());
      }
      return const Left('Unable to update notification right now.');
    }
  }
}
