import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../data/models/surgery_details_item.dart';

class SurgeryBookingPatientDetailsCardWidget extends StatelessWidget {
  const SurgeryBookingPatientDetailsCardWidget({
    super.key,
    required this.item,
  });

  final SurgeryDetailsItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F053453),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.labTestPatientDetailsTitle,
            style: textTheme.titleMedium?.copyWith(
              color: const Color(0xFF061E40),
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 12.h),
          _kvRow(textTheme, l10n.labTestPatientNameLabel, item.patientName),
          _divider(),
          _kvRow(textTheme, l10n.labTestAgeLabel, '${item.age}'),
          _divider(),
          _kvRow(textTheme, l10n.labTestContactNumberLabel, item.contactNumber),
          _divider(),
          _kvRow(
            textTheme,
            l10n.labTestEmergencyContactTitle,
            item.emergencyContact,
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(
        height: 0.6,
        margin: EdgeInsets.symmetric(vertical: 6.h),
        color: const Color(0xFFE2E8EE),
      );

  Widget _kvRow(TextTheme textTheme, String key, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            key,
            style: textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF8593A8),
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Text(
          value,
          style: textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF061E40),
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
