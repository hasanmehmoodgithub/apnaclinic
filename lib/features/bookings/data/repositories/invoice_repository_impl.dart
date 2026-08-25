import 'dart:io';
import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../../core/functional/functional_export.dart';
import '../../../../core/utils/error_handler.dart';
import '../../domain/entities/invoice_module_type.dart';
import '../../domain/repositories/invoice_repository.dart';
import '../../domain/use_cases/download_invoice_use_case.dart';
import '../data_sources/invoice_remote_data_source.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  InvoiceRepositoryImpl({required this.remoteDataSource});

  final InvoiceRemoteDataSource remoteDataSource;

  @override
  Future<Either<ErrorMsg, String>> downloadInvoice(
    DownloadInvoiceParams params,
  ) async {
    try {
      final orderId = params.orderId.trim();
      if (orderId.isEmpty) {
        return const Left('Missing invoice order id.');
      }

      final result = await remoteDataSource.downloadInvoice(
        moduleType: params.moduleType.apiValue,
        orderId: orderId,
      );

      if (!_isPdf(result.bytes)) {
        return const Left('Invoice file is not a valid PDF.');
      }

      final fileName = _fileNameFor(
        moduleType: params.moduleType,
        contentDisposition: result.contentDisposition,
      );
      final docs = await getApplicationDocumentsDirectory();
      final dir = Directory(p.join(docs.path, 'invoices'));
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      final savePath = p.join(dir.path, fileName);
      await File(savePath).writeAsBytes(result.bytes, flush: true);
      return Right(savePath);
    } catch (e) {
      return Left(ErrorHandler.handleExceptions(e));
    }
  }

  static bool _isPdf(Uint8List bytes) {
    return bytes.length >= 4 &&
        bytes[0] == 0x25 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x44 &&
        bytes[3] == 0x46;
  }

  static String _fileNameFor({
    required InvoiceModuleType moduleType,
    required String? contentDisposition,
  }) {
    final fromHeader = _fileNameFromContentDisposition(contentDisposition);
    final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final fallback = 'invoice-${moduleType.apiValue.toLowerCase()}-$date.pdf';
    final raw = (fromHeader != null && fromHeader.isNotEmpty)
        ? fromHeader
        : fallback;
    final safe = raw.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
    if (safe.isEmpty) return fallback;
    return safe.toLowerCase().endsWith('.pdf') ? safe : '$safe.pdf';
  }

  static String? _fileNameFromContentDisposition(String? header) {
    final value = header?.trim() ?? '';
    if (value.isEmpty) return null;
    final quoted = RegExp(
      r'filename="([^"]+)"',
      caseSensitive: false,
    ).firstMatch(value);
    if (quoted != null) {
      return quoted.group(1)?.trim();
    }
    final plain = RegExp(
      r'filename=([^;]+)',
      caseSensitive: false,
    ).firstMatch(value);
    return plain?.group(1)?.trim().replaceAll('"', '');
  }
}
