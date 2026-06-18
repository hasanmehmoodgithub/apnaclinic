import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../generated/assets.dart';
import '../constants/dashboard_ui_config.dart';

/// Non-editable home search affordance — tap opens the search screen.
class HomeHeaderSearchField extends StatelessWidget {
  const HomeHeaderSearchField({
    super.key,
    required this.hintText,
    required this.onTap,
    this.onVoiceTap,
  });

  final String hintText;
  final VoidCallback onTap;
  final VoidCallback? onVoiceTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final height = DashboardUiConfig.homeHeaderSearchHeight.h;
    final radius = height / 2;

    return Material(
      color: AppColors.clrWhite,
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          height: height,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            children: [
              SizedBox(
                width: 48.w,
                child: Center(
                  child: Icon(
                    Icons.search_rounded,
                    color: AppColors.clr52A898,
                    size: 28.r,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  hintText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.clr6B7280,
                    fontWeight: FontWeight.w400,
                    fontSize: 13.sp,
                  ),
                ),
              ),
              IconButton(
                onPressed: onVoiceTap ?? onTap,
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(
                  minWidth: 44.w,
                  minHeight: height,
                ),
                icon: SvgPicture.asset(
                  Assets.svgIcSearchMic,
                  width: 28.r,
                  height: 28.r,
                  colorFilter: const ColorFilter.mode(
                    AppColors.clr09,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
