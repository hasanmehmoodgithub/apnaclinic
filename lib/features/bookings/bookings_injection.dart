import '../../core/di/dependency_injection.dart';
import '../../core/network/api_service.dart';
import 'data/data_sources/invoice_remote_data_source.dart';
import 'data/data_sources/invoice_remote_data_source_impl.dart';
import 'data/repositories/invoice_repository_impl.dart';
import 'domain/repositories/invoice_repository.dart';
import 'domain/use_cases/download_invoice_use_case.dart';

void initBookingsInjector() {
  sl.registerLazySingleton<InvoiceRemoteDataSource>(
    () => InvoiceRemoteDataSourceImpl(apiService: sl<ApiService>()),
  );
  sl.registerLazySingleton<InvoiceRepository>(
    () =>
        InvoiceRepositoryImpl(remoteDataSource: sl<InvoiceRemoteDataSource>()),
  );
  sl.registerLazySingleton<DownloadInvoiceUseCase>(
    () => DownloadInvoiceUseCase(repository: sl<InvoiceRepository>()),
  );
}
