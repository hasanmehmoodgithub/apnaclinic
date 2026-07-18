import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../data/models/doctor_consultation_checkout_model.dart';

class DoctorConsultationCheckoutPaymentMethodTileWidget extends StatelessWidget {
  const DoctorConsultationCheckoutPaymentMethodTileWidget({
    super.key,
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final DoctorConsultationPaymentOptionModel option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final description = _description(l10n);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        constraints: BoxConstraints(minHeight: 72.h),
        padding: EdgeInsets.fromLTRB(14.w, 16.h, 14.w, 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42.w,
              height: 42.h,
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(8.r),
              child: option.iconUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: option.iconUrl,
                      fit: BoxFit.contain,
                      placeholder: (_, _) => const SizedBox.shrink(),
                      errorWidget: (_, _, _) => Icon(
                        Icons.payment_rounded,
                        size: 20.r,
                        color: const Color(0xFF7B8798),
                      ),
                    )
                  : Icon(
                      Icons.payment_rounded,
                      size: 20.r,
                      color: const Color(0xFF7B8798),
                    ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.name,
                    style: textTheme.titleMedium?.copyWith(
                      color: const Color(0xFF061E40),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (description.isNotEmpty)
                    Text(
                      description,
                      style: textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF7B8798),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(99.r),
              child: Container(
                width: 22.w,
                height: 22.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFB8C0CC),
                    width: 1.2,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 10.w,
                          height: 10.h,
                          decoration: const BoxDecoration(
                            color: Color(0xFF0E3D66),
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _description(AppLocalizations l10n) {
    switch (option.code.toUpperCase()) {
      case 'JAZZCASH':
        return l10n.consultationJazzCashChargeDescription;
      case 'CARD':
        return l10n.consultationCardChargeDescription;
      default:
        return '';
    }
  }
}
