import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../lab_test_route_args.dart';
import '../widgets/lab_test_pdf_viewer_actions_widget.dart';
import '../widgets/lab_test_view_details_header.dart';

class LabTestReportViewerScreen extends StatefulWidget {
  const LabTestReportViewerScreen({super.key, required this.args});

  final LabTestReportViewerArgs args;

  @override
  State<LabTestReportViewerScreen> createState() =>
      _LabTestReportViewerScreenState();
}

class _LabTestReportViewerScreenState extends State<LabTestReportViewerScreen> {
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final filePath = widget.args.filePath;

    return AppScaffoldGradient(
      child: Column(
        children: [
          LabTestViewDetailsHeader(
            title: (widget.args.title?.trim().isNotEmpty ?? false)
                ? widget.args.title!.trim()
                : l10n.labTestBookingCardSubtitle,
          ),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: _hasError
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              l10n.labTestDownloadReportFailed,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.clr060),
                            ),
                          ),
                        )
                      : ColoredBox(
                          color: AppColors.clrWhite,
                          child: PDFView(
                            filePath: filePath,
                            enableSwipe: true,
                            autoSpacing: true,
                            pageFling: true,
                            backgroundColor: AppColors.clrWhite,
                            onError: (_) {
                              if (mounted) setState(() => _hasError = true);
                            },
                            onPageError: (page, error) {
                              if (mounted) setState(() => _hasError = true);
                            },
                          ),
                        ),
                ),
                if (!_hasError)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: LabTestPdfViewerActionsWidget(filePath: filePath),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
