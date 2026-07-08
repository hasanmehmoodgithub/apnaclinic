import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';

class InstantDoctorProviderOptionsMenuWidget extends StatelessWidget {
  const InstantDoctorProviderOptionsMenuWidget({
    super.key,
    required this.onCancelSubscription,
    this.size,
    this.borderRadius,
  });

  final VoidCallback onCancelSubscription;
  final double? size;
  final double? borderRadius;

  static const String _cancelSubscriptionValue = 'cancel_subscription';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final menuSize = size ?? 48.h;
    final radius = borderRadius ?? 12.r;

    return Material(
      color: AppColors.clrF4F6F8,
      borderRadius: BorderRadius.circular(radius),
      child: PopupMenuButton<String>(
        offset: Offset(-4.w, menuSize + 4.h),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        color: AppColors.clrWhite,
        elevation: 8,
        onSelected: (value) {
          if (value == _cancelSubscriptionValue) {
            onCancelSubscription();
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem<String>(
            value: _cancelSubscriptionValue,
            height: 48.h,
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Row(
              children: [
                Container(
                  width: 22.r,
                  height: 22.r,
                  decoration: BoxDecoration(
                    color: AppColors.clrFCE9F0,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    size: 14.r,
                    color: AppColors.clrE01F26,
                  ),
                ),
                SizedBox(width: 10.w),
                Text(
                  l10n.instantDoctorCancelSubscription,
                  style: TextStyle(
                    color: AppColors.clrE01F26,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
        child: SizedBox(
          width: menuSize,
          height: menuSize,
          child: Icon(
            Icons.more_vert_rounded,
            color: AppColors.clr303D4F,
            size: 22.r,
          ),
        ),
      ),
    );
  }
}
