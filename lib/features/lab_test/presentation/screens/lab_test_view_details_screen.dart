import 'package:flutter/material.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../../../bookings/data/mappers/lab_test_booking_list_mapper.dart';
import '../../../bookings/presentation/widgets/empty_booking_widget.dart';
import '../../domain/use_cases/get_lab_order_detail_use_case.dart';
import '../lab_test_route_args.dart';
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
  bool _isLoading = true;
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
      },
    );
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
            LabTestViewDetailsHeader(title: l10n.labTestScreenTitle),
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
          LabTestViewDetailsHeader(title: l10n.labTestScreenTitle),
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
                  LabTestViewDetailsResultCard(
                    title: a.testTitle,
                    labName: a.labName,
                    labLogoUrl: a.labLogoUrl,
                    partnerLogoUrl: a.partnerLogoUrl,
                    sampleType: a.sampleType,
                    status: a.statusLabel,
                    discountedFee: a.discountedFee,
                    originalFee: a.originalFee,
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
