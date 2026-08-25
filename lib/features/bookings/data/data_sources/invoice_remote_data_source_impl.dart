import 'dart:typed_data';

import '../../../../core/network/api_service.dart';
import '../../../../core/network/app_urls.dart';
import '../../../../core/utils/error_handler.dart';
import 'invoice_remote_data_source.dart';

class InvoiceRemoteDataSourceImpl implements InvoiceRemoteDataSource {
  InvoiceRemoteDataSourceImpl({required this.apiService});

  final ApiService apiService;

  @override
  Future<({Uint8List bytes, String? contentDisposition})> downloadInvoice({
    required String moduleType,
    required String orderId,
  }) async {
    try {
      final file = await apiService.download(
        AppUrls.mobileInvoice(moduleType: moduleType, orderId: orderId),
      );
      return (bytes: file.bytes, contentDisposition: file.contentDisposition);
    } catch (e) {
      return Future.error(
        ErrorHandler.handleExceptions(
          e,
          endpoint: AppUrls.mobileInvoice(
            moduleType: moduleType,
            orderId: orderId,
          ),
        ),
      );
    }
  }
}
