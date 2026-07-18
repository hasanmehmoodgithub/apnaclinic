import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
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
    final discountLabel = data.discount <= 0
        ? l10n.consultationDiscountNotAvailable
        : '${data.discount}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.bookingsBillingTitle,
          style: textTheme.titleMedium?.copyWith(
            color: AppColors.clr061E40,
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          l10n.consultationVideoConsultationLabel,
          style: textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF98A4B5),
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 12.h),
        const Divider(color: Color(0xFFD1D6DD), thickness: 1, height: 1),
        SizedBox(height: 16.h),
        _StackedAmount(
          label: l10n.consultationConsultationFeesLabel,
          amount: data.consultationFee,
        ),
        SizedBox(height: 14.h),
        _StackedAmount(
          label: l10n.consultationDiscountLabel,
          plainValue: discountLabel,
          isMuted: true,
        ),
        SizedBox(height: 16.h),
        const Divider(color: Color(0xFFD1D6DD), thickness: 1, height: 1),
        SizedBox(height: 16.h),
        _StackedAmount(
          label: l10n.consultationTotalChargesLabel,
          amount: data.total,
        ),
      ],
    );
  }
}

class _StackedAmount extends StatelessWidget {
  const _StackedAmount({
    required this.label,
    this.amount,
    this.plainValue,
    this.isMuted = false,
  });

  final String label;
  final int? amount;
  final String? plainValue;
  final bool isMuted;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final valueColor =
        isMuted ? const Color(0xFF7C8797) : AppColors.clr061E40;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF7C8797),
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 4.h),
        if (amount != null)
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Rs. ',
                  style: textTheme.titleMedium?.copyWith(
                    color: AppColors.clr667B99,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                  ),
                ),
                TextSpan(
                  text: '$amount',
                  style: textTheme.titleMedium?.copyWith(
                    color: valueColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          )
        else
          Text(
            plainValue ?? '',
            style: textTheme.titleMedium?.copyWith(
              color: valueColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w400,
              height: 1.1,
            ),
          ),
      ],
    );
  }
}
