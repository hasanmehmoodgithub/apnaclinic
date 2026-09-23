import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/analytics/analytics_event_keys.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../../../../core/widgets/heart_loader_widget.dart';
import '../../../bookings/data/mappers/lab_test_booking_list_mapper.dart';
import '../../../bookings/domain/entities/invoice_module_type.dart';
import '../../../bookings/presentation/bookings_analytics.dart';
import '../../../bookings/presentation/invoice_download.dart';
import '../../../bookings/presentation/widgets/booking_invoice_tile_widget.dart';
import '../../../bookings/presentation/widgets/empty_booking_widget.dart';
import '../../domain/use_cases/download_lab_report_use_case.dart';
import '../../domain/use_cases/get_lab_order_detail_use_case.dart';
import '../lab_test_route_args.dart';
import '../widgets/lab_test_view_details_download_report_chip.dart';
import '../widgets/lab_test_view_details_header.dart';
import '../widgets/lab_test_view_details_note_card.dart';
import '../widgets/lab_test_view_details_order_card.dart';
import '../widgets/lab_test_view_details_result_card.dart';
import '../widgets/lab_test_view_details_shimmer.dart';

class LabTestViewDetailsScreen extends StatefulWidget {
  const LabTestViewDetailsScreen({super.key, required this.args});

  final LabTestViewDetailsArgs args;

  @override
  State<LabTestViewDetailsScreen> createState() =>
      _LabTestViewDetailsScreenState();
}

class _LabTestViewDetailsScreenState extends State<LabTestViewDetailsScreen> {
  static const _downloadLoaderId = 'lab_report_download';

  bool _isLoading = true;
  bool _isDownloading = false;
  String? _errorMessage;
  LabTestViewDetailsContent? _content;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await sl<GetLabOrderDetailUseCase>()(
      GetLabOrderDetailParams(orderId: widget.args.orderId),
    );
    if (!mounted) return;

    result.fold(
      (error) {
        setState(() {
          _isLoading = false;
          _errorMessage = error;
          _content = null;
        });
      },
      (order) {
        final l10n = AppLocalizations.of(context)!;
        setState(() {
          _isLoading = false;
          _errorMessage = null;
          _content = LabTestBookingListMapper.toViewDetailsContent(order, l10n);
        });
        BookingsAnalytics.logBookingViewed(AnalyticsBookingTypeKeys.lab);
      },
    );
  }

  Future<void> _downloadReports(List<String> urls) async {
    if (_isDownloading || urls.isEmpty) return;

    final l10n = AppLocalizations.of(context)!;
    setState(() => _isDownloading = true);
    showHeartLoaderDialog(context, id: _downloadLoaderId, size: 120);

    String? savedPath;
    var failed = false;
    try {
      for (var i = 0; i < urls.length; i++) {
        final result = await sl<DownloadLabReportUseCase>()(
          DownloadLabReportParams.fromUrl(
            url: urls[i],
            orderId: widget.args.orderId,
            index: i,
          ),
        );
        if (!mounted) return;
        final path = result.fold<String?>((_) => null, (value) => value);
        if (path == null) {
          failed = true;
          break;
        }
        savedPath ??= path;
      }
    } catch (_) {
      failed = true;
    } finally {
      HeartLoaderDialogController.close(_downloadLoaderId);
      if (mounted) setState(() => _isDownloading = false);
    }

    if (!mounted) return;
    if (failed || savedPath == null) {
      _showDownloadFailed(l10n);
      return;
    }

    context.pushNamed(
      AppRoutes.labTestReportViewer,
      extra: LabTestReportViewerArgs(filePath: savedPath),
    );
  }

  void _showDownloadFailed(AppLocalizations l10n) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.labTestDownloadReportFailed)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) return const LabTestViewDetailsShimmer();

    if (_errorMessage != null || _content == null) {
      final message = (_errorMessage?.trim().isNotEmpty ?? false)
          ? _errorMessage!.trim()
          : l10n.labTestViewDetailsLoadError;
      return AppScaffoldGradient(
        child: Column(
          children: [
            LabTestViewDetailsHeader(title: l10n.labTestViewDetailsTitle),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 150, 20, 20),
                child: EmptyBookingWidget(
                  description: message,
                  buttonText: l10n.commonRetry,
                  backgroundColor: Colors.transparent,
                  onTap: _loadDetail,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final a = _content!;

    return AppScaffoldGradient(
      child: Column(
        children: [
          LabTestViewDetailsHeader(title: l10n.labTestViewDetailsTitle),
          AppScaffoldGradientPanel(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.labTestViewDetailsResultsTitle,
                    style: const TextStyle(
                      color: Color(0xFF202B3A),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...List<Widget>.generate(a.tests.length, (index) {
                    final test = a.tests[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index == a.tests.length - 1 ? 0 : 10,
                      ),
                      child: LabTestViewDetailsResultCard(
                        title: test.name,
                        labName: a.labName,
                        labLogoUrl: a.labLogoUrl,
                        partnerLogoUrl: a.partnerLogoUrl,
                        sampleType: a.sampleType,
                        orderTypeLabel: a.orderTypeLabel,
                        status: test.status,
                        discountedFee: test.fee,
                        originalFee: test.fee,
                      ),
                    );
                  }),
                  const SizedBox(height: 12),
                  LabTestViewDetailsDownloadReportChip(
                    onDownload: a.canDownloadReport
                        ? () => _downloadReports(a.reportUrls)
                        : null,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    l10n.labTestViewDetailsOrderTitle,
                    style: const TextStyle(
                      color: Color(0xFF202B3A),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  LabTestViewDetailsOrderCard(
                    patientName: a.patientName,
                    orderNo: a.orderNo,
                    bookingDate: a.bookingDate,
                    totalFee: a.discountedFee,
                    discountCode: a.discountCode,
                  ),
                  const SizedBox(height: 16),
                  if (!a.isFailed) ...[
                    BookingInvoiceTileWidget(
                      onDownload: () => InvoiceDownload.downloadAndView(
                        context,
                        moduleType: InvoiceModuleType.lab,
                        orderId: a.orderId,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  LabTestViewDetailsNoteCard(note: a.note),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
