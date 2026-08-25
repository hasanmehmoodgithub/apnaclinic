import '../../../../core/functional/functional_export.dart';
import '../use_cases/download_invoice_use_case.dart';

abstract class InvoiceRepository {
  Future<Either<ErrorMsg, String>> downloadInvoice(
    DownloadInvoiceParams params,
  );
}
