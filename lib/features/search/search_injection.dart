import 'package:apnaclinic/features/search/presentation/screens/recent_search_store.dart';

import '../../core/di/dependency_injection.dart';
import '../../core/network/api_service.dart';
import 'data/data_sources/search_remote_data_source.dart';
import 'data/data_sources/search_remote_data_source_impl.dart';
import 'data/mock/search_mock_api.dart';
import 'data/repositories/search_repository_impl.dart';
import 'domain/repositories/search_repository.dart';
import 'domain/use_cases/get_search_content_use_case.dart';
import 'presentation/cubit/search_cubit.dart';

import 'package:shared_preferences/shared_preferences.dart';


void initSearchInjector() {
  sl.registerLazySingleton<SearchMockApi>(() => SearchMockApi());

  sl.registerLazySingleton<SearchRemoteDataSource>(
        () => SearchRemoteDataSourceImpl(
      apiService: sl<ApiService>(),
      mockApi: sl<SearchMockApi>(),
    ),
  );

  sl.registerLazySingleton<RecentSearchesStore>(
        () => RecentSearchesStore(sl<SharedPreferences>()),
  );

  sl.registerLazySingleton<SearchRepository>(
        () => SearchRepositoryImpl(remoteDataSource: sl<SearchRemoteDataSource>()),
  );

  sl.registerLazySingleton<GetSearchContentUseCase>(
        () => GetSearchContentUseCase(repository: sl<SearchRepository>()),
  );

  sl.registerFactory<SearchCubit>(
        () => SearchCubit(
      getSearchContentUseCase: sl<GetSearchContentUseCase>(),
      recentSearchesStore: sl<RecentSearchesStore>(),
    ),
  );
}