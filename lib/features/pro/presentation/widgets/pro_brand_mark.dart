import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../generated/assets.dart';

/// Laurels + crown badge + “apna clinic” + [Assets.proProBadge] from `assets/img/pro/`.
class ProBrandMark extends StatelessWidget {
  const ProBrandMark({
    super.key,
    this.height = 72,
    this.showWordmark = true,
  });

  final double height;
  final bool showWordmark;

  @override
  Widget build(BuildContext context) {
    final laurelH = height * 0.9;
    final crownH = height * 0.28;
    final proH = height * 0.2;

    return SizedBox(
      height: height.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            Assets.proLeftLeave,
            height: laurelH.h,
            fit: BoxFit.contain,
          ),
          SizedBox(width: 4.w),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                Assets.proBadgeCrown,
                height: crownH.h,
                fit: BoxFit.contain,
              ),
              if (showWordmark) ...[
                SizedBox(height: 2.h),
                Text(
                  'apna clinic',
                  style: TextStyle(
                    color: AppColors.clr111827,
                    fontWeight: FontWeight.w700,
                    fontSize: (height * 0.17).sp,
                    height: 1.05,
                  ),
                ),
              ],
              SizedBox(height: 4.h),
              SvgPicture.asset(
                Assets.proProBadge,
                height: proH.h,
                fit: BoxFit.contain,
              ),
            ],
          ),
          SizedBox(width: 4.w),
          Image.asset(
            Assets.proRight,
            height: laurelH.h,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}

/// Teal check badge ([Assets.proBadge]) used in benefit rows.
class ProCheckBadgeIcon extends StatelessWidget {
  const ProCheckBadgeIcon({super.key, this.size = 18});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      Assets.proBadge,
      width: size.w,
      height: size.w,
      fit: BoxFit.contain,
    );
  }
}

/// Small “pro” pill ([Assets.proProBadge]).
class ProPillBadge extends StatelessWidget {
  const ProPillBadge({super.key, this.height = 16});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      Assets.proProBadge,
      height: height.h,
      fit: BoxFit.contain,
    );
  }
}
