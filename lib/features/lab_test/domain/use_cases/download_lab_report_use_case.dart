import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../repositories/lab_test_repository.dart';

class DownloadLabReportParams {
  const DownloadLabReportParams({
    required this.url,
    required this.fileName,
  });

  final String url;
  final String fileName;

  factory DownloadLabReportParams.fromUrl({
    required String url,
    required String orderId,
    int index = 0,
  }) {
    return DownloadLabReportParams(
      url: url.trim(),
      fileName: _fileNameFor(url: url, orderId: orderId, index: index),
    );
  }

  static String _fileNameFor({
    required String url,
    required String orderId,
    required int index,
  }) {
    final uri = Uri.tryParse(url.trim());
    final segments = uri?.pathSegments
            .where((segment) => segment.trim().isNotEmpty)
            .toList() ??
        const <String>[];
    final lastSegment = segments.isEmpty ? '' : segments.last;
    final fromUrl = lastSegment.split('?').first.trim();
    final suffix = index > 0 ? '-${index + 1}' : '';
    final fallback = 'lab-report-${orderId.trim()}$suffix.pdf';
    final raw = fromUrl.toLowerCase().endsWith('.pdf') ? fromUrl : fallback;
    final safe = raw.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
    return safe.isEmpty ? fallback : safe;
  }
}

class DownloadLabReportUseCase
    implements UseCase<String, DownloadLabReportParams> {
  DownloadLabReportUseCase({required this.repository});

  final LabTestRepository repository;

  @override
  Future<Either<ErrorMsg, String>> call(DownloadLabReportParams params) {
    return repository.downloadLabReport(params);
  }
}
