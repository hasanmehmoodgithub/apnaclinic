import 'dart:typed_data';

abstract class InvoiceRemoteDataSource {
  Future<({Uint8List bytes, String? contentDisposition})> downloadInvoice({
    required String moduleType,
    required String orderId,
  });
}
