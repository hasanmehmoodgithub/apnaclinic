import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../constants/consultation_ui_config.dart';

class ConsultationScreenHeaderWidget extends StatelessWidget {
  const ConsultationScreenHeaderWidget({
    super.key,
    required this.title,
    required this.onBackTap,
  });

  final String title;
  final VoidCallback onBackTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(22.w, 8.h, 22.w, 8.h),
      child: Row(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onBackTap,
            child: SizedBox(
              width: 24.w,
              height: 24.h,
              child: Center(
                child: SvgPicture.asset(
                  ConsultationUiConfig.backArrowAsset,
                  width: 18.w,
                  height: 18.h,
                  fit: BoxFit.contain,
                  colorFilter: const ColorFilter.mode(
                    ConsultationUiConfig.primaryText,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.titleLarge?.copyWith(
                color: ConsultationUiConfig.primaryText,
                fontWeight: FontWeight.w700,
                fontSize: 20.sp,
              ),
            ),
          ),
          SizedBox(width: 24.w),
        ],
      ),
    );
  }
}
