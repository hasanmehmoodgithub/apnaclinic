import 'package:flutter/material.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../../data/mock/lab_test_mock_api.dart';
import '../lab_test_route_args.dart';
import '../lab_test_view_details_data.dart';
import '../widgets/lab_test_view_details_header.dart';
import '../widgets/lab_test_view_details_note_card.dart';
import '../widgets/lab_test_view_details_order_card.dart';
import '../widgets/lab_test_view_details_result_card.dart';
import '../widgets/lab_test_view_details_shimmer.dart';

class LabTestViewDetailsScreen extends StatefulWidget {
  const LabTestViewDetailsScreen({super.key, required this.args});

  final LabTestViewDetailsArgs args;

  @override
  State<LabTestViewDetailsScreen> createState() => _LabTestViewDetailsScreenState();
}

class _LabTestViewDetailsScreenState extends State<LabTestViewDetailsScreen> {
  final LabTestMockApi _mockApi = sl<LabTestMockApi>();

  bool _isLoading = true;
  String? _errorMessage;
  LabTestViewDetailsData? _details;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final response = await _mockApi.getLabTestViewDetailsSuccessResponse();
      final data = response['data'];
      if (data is! Map<String, dynamic>) {
        throw Exception('Invalid response');
      }
      if (!mounted) return;
      setState(() {
        _details = LabTestViewDetailsData.fromMap(data);
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _errorMessage = l10n.labTestViewDetailsLoadError;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_isLoading) return const LabTestViewDetailsShimmer();

    if (_errorMessage != null || _details == null) {
      return AppScaffoldGradient(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_errorMessage ?? l10n.labTestSomethingWentWrong),
                const SizedBox(height: 10),
                FilledButton(
                  onPressed: _loadDetails,
                  child: Text(l10n.commonRetry),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final details = _details!;
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
                      style: TextStyle(
                        color: Color(0xFF202B3A),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    LabTestViewDetailsResultCard(
                      title: widget.args.testTitle,
                      labName: widget.args.labName,
                      labLogoUrl: widget.args.labLogoUrl,
                      partnerLogoUrl: widget.args.partnerLogoUrl,
                      sampleType: widget.args.sampleType,
                      status: details.status,
                      discountedFee: widget.args.discountedFee,
                      originalFee: widget.args.originalFee,
                    ),
                    const SizedBox(height: 18),
                    Text(
                      l10n.labTestViewDetailsOrderTitle,
                      style: TextStyle(
                        color: Color(0xFF202B3A),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    LabTestViewDetailsOrderCard(
                      patientName: details.patientName,
                      orderNo: details.orderNo,
                      bookingDate: details.bookingDate,
                      totalFee: widget.args.discountedFee,
                      discountCode: widget.args.discountCode,
                    ),
                    const SizedBox(height: 16),
                    LabTestViewDetailsNoteCard(note: details.note),
                  ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
