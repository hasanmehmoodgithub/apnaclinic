import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/dependency_injection.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/widgets/heart_loader_widget.dart';
import '../../lab_test/presentation/lab_test_route_args.dart';
import '../domain/entities/invoice_module_type.dart';
import '../domain/use_cases/download_invoice_use_case.dart';

class InvoiceDownload {
  InvoiceDownload._();

  static const _loaderId = 'invoice_download';

  static Future<void> downloadAndView(
    BuildContext context, {
    required InvoiceModuleType moduleType,
    required String orderId,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final id = orderId.trim();
    if (id.isEmpty) {
      _showError(context, l10n.bookingsInvoiceDownloadFailed);
      return;
    }

    showHeartLoaderDialog(context, id: _loaderId, size: 120);
    final result = await sl<DownloadInvoiceUseCase>()(
      DownloadInvoiceParams(moduleType: moduleType, orderId: id),
    );
    HeartLoaderDialogController.close(_loaderId);
    if (!context.mounted) return;

    result.fold(
      (error) {
        final message = error.trim().isNotEmpty
            ? error.trim()
            : l10n.bookingsInvoiceDownloadFailed;
        _showError(context, message);
      },
      (path) {
        context.pushNamed(
          AppRoutes.labTestReportViewer,
          extra: LabTestReportViewerArgs(
            filePath: path,
            title: l10n.bookingsEInvoiceLabel,
          ),
        );
      },
    );
  }

  static void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
