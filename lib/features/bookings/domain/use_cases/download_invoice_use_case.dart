import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/invoice_module_type.dart';
import '../repositories/invoice_repository.dart';

class DownloadInvoiceParams {
  const DownloadInvoiceParams({
    required this.moduleType,
    required this.orderId,
  });

  final InvoiceModuleType moduleType;
  final String orderId;
}

class DownloadInvoiceUseCase implements UseCase<String, DownloadInvoiceParams> {
  DownloadInvoiceUseCase({required this.repository});

  final InvoiceRepository repository;

  @override
  Future<Either<ErrorMsg, String>> call(DownloadInvoiceParams params) {
    return repository.downloadInvoice(params);
  }
}
