import '../../core/di/dependency_injection.dart';
import '../../core/network/api_service.dart';
import 'data/data_sources/notification_remote_data_source.dart';
import 'data/data_sources/notification_remote_data_source_impl.dart';
import 'data/mock/notification_mock_api.dart';
import 'data/repositories/notification_repository_impl.dart';
import 'domain/repositories/notification_repository.dart';
import 'domain/use_cases/get_notifications_use_case.dart';
import 'domain/use_cases/mark_notification_read_use_case.dart';
import 'presentation/cubit/notification_cubit.dart';

void initNotificationInjector() {
  sl.registerLazySingleton<NotificationMockApi>(() => NotificationMockApi());

  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(
      apiService: sl<ApiService>(),
      mockApi: sl<NotificationMockApi>(),
    ),
  );

  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(
      remoteDataSource: sl<NotificationRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<GetNotificationsUseCase>(
    () => GetNotificationsUseCase(
      repository: sl<NotificationRepository>(),
    ),
  );

  sl.registerLazySingleton<MarkNotificationReadUseCase>(
    () => MarkNotificationReadUseCase(
      repository: sl<NotificationRepository>(),
    ),
  );

  sl.registerFactory<NotificationCubit>(
    () => NotificationCubit(
      getNotificationsUseCase: sl<GetNotificationsUseCase>(),
      markNotificationReadUseCase: sl<MarkNotificationReadUseCase>(),
    ),
  );
}
