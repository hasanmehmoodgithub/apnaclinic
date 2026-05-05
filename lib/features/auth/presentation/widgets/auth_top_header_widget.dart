import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../generated/assets.dart';

class AuthTopHeaderWidget extends StatelessWidget {
  const AuthTopHeaderWidget({
    super.key,
    required this.onBackTap,
  });

  final VoidCallback onBackTap;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    return Container(
      width: double.infinity,
      height: 65.h + topInset,
      decoration: const BoxDecoration(
        color: AppColors.clrWhite,
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              Assets.svgAppbarbackground,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          Positioned(
            top: topInset + 6.h,
            left: 12.w,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20.r),
                onTap: onBackTap,
                child: SizedBox(
                  width: 40.r,
                  height: 40.r,
                  child: Center(
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: AppColors.clr060,
                      size: 22.r,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.8),
            child: SvgPicture.asset(
              Assets.svgBrandApnaClinic,
              width: 230.w,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
