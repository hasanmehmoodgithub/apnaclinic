import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../components/widgets/app_button.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../generated/assets.dart';

class PharmacyOrderPlacedDialog extends StatelessWidget {
  const PharmacyOrderPlacedDialog({
    super.key,
    required this.orderNo,
    required this.onViewOrders,
  });

  final String orderNo;
  final VoidCallback onViewOrders;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final displayOrderNo = orderNo.trim().isEmpty ? '—' : orderNo.trim();

    return Dialog(
      backgroundColor: AppColors.clrWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding: EdgeInsets.fromLTRB(22.w, 22.h, 22.w, 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 60.r,
              height: 60.r,
              child: SvgPicture.asset(Assets.iconsTick),
            ),
            SizedBox(height: 12.h),
            Text(
              l10n.pharmacyOrderPlacedTitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                color: AppColors.clr102A56,
                fontWeight: FontWeight.w700,
                fontSize: 20.sp,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              l10n.pharmacyOrderPlacedMessage(displayOrderNo),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.clr6B7C96,
                fontSize: 14.sp,
                height: 1.4,
              ),
            ),
            SizedBox(height: 22.h),
            SizedBox(
              width: double.infinity,
              child: AppButton.primary(
                text: l10n.pharmacyOrderPlacedViewOrdersCta,
                onPressed: onViewOrders,
                backgroundColor: AppColors.clr27B3A6,
                foregroundColor: AppColors.clrWhite,
                height: 52.h,
                borderRadius: 14.r,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showPharmacyOrderPlacedDialog(
  BuildContext context, {
  required String orderNo,
  required VoidCallback onViewOrders,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierColor: AppColors.clrBlack.withValues(alpha: 0.38),
    builder: (dialogContext) => PharmacyOrderPlacedDialog(
      orderNo: orderNo,
      onViewOrders: () {
        if (dialogContext.canPop()) dialogContext.pop();
        onViewOrders();
      },
    ),
  );
}
