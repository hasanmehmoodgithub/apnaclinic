import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../data/models/doctor_consultation_checkout_model.dart';

class DoctorConsultationCheckoutBillingSectionWidget extends StatelessWidget {
  const DoctorConsultationCheckoutBillingSectionWidget({
    super.key,
    required this.data,
  });

  final DoctorConsultationCheckoutModel data;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.bookingsBillingTitle,
          style: textTheme.titleMedium?.copyWith(
            color: const Color(0xFF061E40),
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          l10n.consultationVideoConsultationLabel,
          style: textTheme.bodySmall?.copyWith(color: const Color(0xFF98A4B5)),
        ),
        SizedBox(height: 8.h),
        const Divider(color: Color(0xFFD1D6DD), height: 1),
        SizedBox(height: 10.h),
        _row(textTheme, l10n.consultationConsultationFeesLabel, 'Rs.${data.consultationFee}'),
        SizedBox(height: 8.h),
        _row(textTheme, l10n.consultationDiscountLabel, '${data.discount}'),
        SizedBox(height: 8.h),
        const Divider(color: Color(0xFFD1D6DD), height: 1),
        SizedBox(height: 8.h),
        _row(
          textTheme,
          l10n.consultationTotalChargesLabel,
          'Rs ${data.total}',
          isTotal: true,
        ),
      ],
    );
  }

  Widget _row(
    TextTheme textTheme,
    String title,
    String value, {
    bool isTotal = false,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF7C8797),
            fontWeight: isTotal ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: textTheme.titleMedium?.copyWith(
            color: const Color(0xFF061E40),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
