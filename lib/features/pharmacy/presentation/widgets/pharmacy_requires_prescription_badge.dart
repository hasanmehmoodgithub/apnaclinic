import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../generated/assets.dart';

class PharmacyRequiresPrescriptionBadge extends StatelessWidget {
  const PharmacyRequiresPrescriptionBadge({
    super.key,
    this.compact = false,
  });

  /// Smaller padding/text for medicine grid cards.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final iconSize = compact ? 12.r : 16.r;
    final fontSize = compact ? 8.sp : 11.sp;
    final hPad = compact ? 8.w : 12.w;
    final vPad = compact ? 4.h : 6.h;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
      decoration: BoxDecoration(
        color: AppColors.clrFFF4E5,
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: AppColors.clrFFE9C3, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            Assets.iconsWarningTriangle,
            width: iconSize,
            height: iconSize,
          ),
          SizedBox(width: compact ? 4.w : 6.w),
          Text(
            l10n.pharmacyRequiresPrescription,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.clrC85600,
              fontWeight: FontWeight.w700,
              fontSize: fontSize,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
