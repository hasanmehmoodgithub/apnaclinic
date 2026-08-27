import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../generated/assets.dart';
import '../../data/utils/consultation_booking_utils.dart';
import 'doctor_consultation_summary_card_shell_widget.dart';

class DoctorConsultationSummaryPaymentCardWidget extends StatelessWidget {
  const DoctorConsultationSummaryPaymentCardWidget({
    super.key,
    required this.paymentMethodCode,
    required this.paymentMethodName,
    this.paymentMethodIconUrl = '',
    required this.accountNumber,
  });

  final String paymentMethodCode;
  final String paymentMethodName;
  final String paymentMethodIconUrl;
  final String accountNumber;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final isJazzCash = ConsultationBookingUtils.isJazzCashPayment(
      paymentMethodCode,
      name: paymentMethodName,
    );
    final iconAsset =
        isJazzCash ? Assets.iconsJazzCash : Assets.iconsDebitCard;

    return DoctorConsultationSummaryCardShell(
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 30.w,
                    height: 30.w,
                    child: _PaymentMethodIcon(
                      iconUrl: paymentMethodIconUrl,
                      fallbackAsset: iconAsset,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.consultationPaymentMethodTitle,
                          style: textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF667B99),
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          paymentMethodName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleMedium?.copyWith(
                            color: const Color(0xFF061E40),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (isJazzCash) ...[
              Container(
                width: 0.5,
                margin: EdgeInsets.symmetric(horizontal: 12.w),
                color: const Color(0xFF9BA6A7),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.consultationSummaryAccountNoLabel,
                      style: textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF667B99),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      accountNumber,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium?.copyWith(
                        color: const Color(0xFF061E40),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PaymentMethodIcon extends StatelessWidget {
  const _PaymentMethodIcon({
    required this.iconUrl,
    required this.fallbackAsset,
  });

  final String iconUrl;
  final String fallbackAsset;

  @override
  Widget build(BuildContext context) {
    final url = iconUrl.trim();
    if (url.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.contain,
        placeholder: (_, _) =>
            SvgPicture.asset(fallbackAsset, fit: BoxFit.contain),
        errorWidget: (_, _, _) =>
            SvgPicture.asset(fallbackAsset, fit: BoxFit.contain),
      );
    }
    return SvgPicture.asset(fallbackAsset, fit: BoxFit.contain);
  }
}
