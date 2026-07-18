import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
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
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        constraints: BoxConstraints(minHeight: 92.h),
        padding: EdgeInsets.fromLTRB(16.w, 22.h, 16.w, 22.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE8ECF1)),
              ),
              padding: EdgeInsets.all(9.r),
              child: option.iconUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: option.iconUrl,
                      fit: BoxFit.contain,
                      placeholder: (_, _) => const SizedBox.shrink(),
                      errorWidget: (_, _, _) => Icon(
                        Icons.payment_rounded,
                        size: 22.r,
                        color: const Color(0xFF7B8798),
                      ),
                    )
                  : Icon(
                      Icons.payment_rounded,
                      size: 22.r,
                      color: const Color(0xFF7B8798),
                    ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                option.name,
                style: textTheme.titleMedium?.copyWith(
                  color: const Color(0xFF061E40),
                  fontWeight: FontWeight.w600,
                  fontSize: 15.sp,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              width: 18.w,
              height: 18.h,
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
                        width: 8.w,
                        height: 8.h,
                        decoration: const BoxDecoration(
                          color: Color(0xFF0E3D66),
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
