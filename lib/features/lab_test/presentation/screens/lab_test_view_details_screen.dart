import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../lab_test_route_args.dart';
import '../widgets/lab_test_view_details_header.dart';
import '../widgets/lab_test_view_details_invoice_card.dart';
import '../widgets/lab_test_view_details_note_card.dart';
import '../widgets/lab_test_view_details_order_card.dart';
import '../widgets/lab_test_view_details_result_card.dart';

class LabTestViewDetailsScreen extends StatelessWidget {
  const LabTestViewDetailsScreen({super.key, required this.args});

  final LabTestViewDetailsArgs args;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final a = args;
    final invoiceUrl = a.invoiceUrl?.trim() ?? '';

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
                  if (invoiceUrl.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    LabTestViewDetailsInvoiceCard(invoiceUrl: invoiceUrl),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
