import '../../core/di/dependency_injection.dart';
import '../../core/network/api_service.dart';
import '../../core/preference/app_pref.dart';
import 'data/data_sources/account_remote_data_source.dart';
import 'data/data_sources/account_remote_data_source_impl.dart';
import 'data/mock/account_mock_api.dart';
import 'data/repositories/account_repository_impl.dart';
import 'domain/repositories/account_repository.dart';
import 'domain/use_cases/add_user_phone_use_case.dart';
import 'domain/use_cases/delete_user_phone_use_case.dart';
import 'domain/use_cases/get_accounts_list_use_case.dart';

void initAccountInjector() {
  if (!sl.isRegistered<AccountMockApi>()) {
    sl.registerLazySingleton<AccountMockApi>(() => AccountMockApi());
  }

  if (!sl.isRegistered<AccountRemoteDataSource>()) {
    sl.registerLazySingleton<AccountRemoteDataSource>(
      () => AccountRemoteDataSourceImpl(
        apiService: sl<ApiService>(),
        mockApi: sl<AccountMockApi>(),
        appPref: sl<AppPref>(),
      ),
    );
  }

  if (!sl.isRegistered<AccountRepository>()) {
    sl.registerLazySingleton<AccountRepository>(
      () => AccountRepositoryImpl(remoteDataSource: sl<AccountRemoteDataSource>()),
    );
  }

  if (!sl.isRegistered<GetAccountsListUseCase>()) {
    sl.registerLazySingleton<GetAccountsListUseCase>(
      () => GetAccountsListUseCase(repository: sl<AccountRepository>()),
    );
  }

  if (!sl.isRegistered<AddUserPhoneUseCase>()) {
    sl.registerLazySingleton<AddUserPhoneUseCase>(
      () => AddUserPhoneUseCase(repository: sl<AccountRepository>()),
    );
  }

  if (!sl.isRegistered<DeleteUserPhoneUseCase>()) {
    sl.registerLazySingleton<DeleteUserPhoneUseCase>(
      () => DeleteUserPhoneUseCase(repository: sl<AccountRepository>()),
    );
  }
}
