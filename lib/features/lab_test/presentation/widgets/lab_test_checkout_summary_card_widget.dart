import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../lab_test_route_args.dart';
import 'lab_test_figma_image.dart';

class LabTestCheckoutSummaryCardWidget extends StatelessWidget {
  const LabTestCheckoutSummaryCardWidget({super.key, required this.args});

  final LabTestCheckoutArgs args;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDDE3EA), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 112,
            height: 112,
            decoration: BoxDecoration(
              color: const Color(0xFFF4F4F4),
              borderRadius: BorderRadius.circular(9),
            ),
            alignment: Alignment.center,
            child: LabTestFigmaImage(
              url: args.labLogoUrl,
              width: 72,
              height: 72,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  args.testTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF061E40),
                    fontSize: 16.sp,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  args.labDisplayName,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF667B99),
                    fontSize: 12.sp,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _pill(context, '${l10n.labTestSampleTypeLabel}: ${args.sampleType}'),
                    _pill(
                      context,
                      args.bookingMethodIsHomeSample
                          ? l10n.labTestBookingMethodHomeSample
                          : l10n.labTestBookingMethodWalkInCompact,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pill(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFE7E7E7)),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: const Color(0xFF667B99),
              fontSize: 12.sp,
            ),
      ),
    );
  }
}
