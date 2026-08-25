import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';

import '../l10n/app_localizations.dart';

class PdfFileActions {
  PdfFileActions._();

  static Future<void> share(BuildContext context, {required String filePath}) async {
    final l10n = AppLocalizations.of(context)!;
    final path = filePath.trim();
    if (path.isEmpty || !File(path).existsSync()) {
      _snack(context, l10n.pdfViewerShareFailed);
      return;
    }

    try {
      final box = context.findRenderObject() as RenderBox?;
      final origin = box == null
          ? null
          : box.localToGlobal(Offset.zero) & box.size;
      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile(path, mimeType: 'application/pdf', name: p.basename(path)),
          ],
          sharePositionOrigin: origin,
        ),
      );
    } catch (_) {
      if (context.mounted) {
        _snack(context, l10n.pdfViewerShareFailed);
      }
    }
  }

  static Future<void> download(
    BuildContext context, {
    required String filePath,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final path = filePath.trim();
    final file = File(path);
    if (path.isEmpty || !file.existsSync()) {
      _snack(context, l10n.pdfViewerDownloadFailed);
      return;
    }

    try {
      if (Platform.isAndroid) {
        final saved = await FilePicker.saveFile(
          dialogTitle: l10n.pdfViewerDownload,
          fileName: p.basename(path),
          bytes: await file.readAsBytes(),
          type: FileType.custom,
          allowedExtensions: const ['pdf'],
        );
        if (!context.mounted || saved == null || saved.trim().isEmpty) {
          return;
        }
        _snack(context, l10n.pdfViewerSaved);
        return;
      }

      // iOS has no public Downloads folder; Save to Files is the share sheet.
      await share(context, filePath: path);
    } catch (_) {
      if (context.mounted) {
        _snack(context, l10n.pdfViewerDownloadFailed);
      }
    }
  }

  static void _snack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
