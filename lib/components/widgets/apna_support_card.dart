import 'package:apnaclinic/core/extensions/context_extensions.dart';
import 'package:apnaclinic/core/extensions/screen_util_extensions.dart';
import 'package:apnaclinic/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ApnaSupportCard extends StatelessWidget {
  const ApnaSupportCard({
    super.key,
    required this.title,
    required this.onTap,
    this.curveOverlayColor = const Color(0x99DDE2EE),
  });

  final String title;
  final VoidCallback onTap;
  final Color curveOverlayColor;

  static const String _supportCardArrowSvg =
      'assets/svg/ic_support_card_arrow.svg';
  static const Color _headingDark = Color(0xFF111827);
  static const double _radius = 2;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = BorderRadius.all(Radius.circular(_radius.r));
    final curveWidth = context.screenWidth * 0.7206;
    final curveHeight = 281.37.h;
    final curveLeft = context.screenWidth * 0.6290;
    return Material(
      child: Container(
        color: Colors.transparent,
        height: 96.h,
        width: 382.w,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: radius,
              border: Border.all(color: const Color(0xFFF3F4F6)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10.r,
                  offset: Offset(0, 2.h),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: radius,
              clipBehavior: Clip.antiAlias,
              child: Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  Positioned(
                    left: curveLeft,
                    top: -48.78.h,
                    child: IgnorePointer(
                      child: Container(
                        width: curveWidth,
                        height: curveHeight,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: curveOverlayColor,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 12.h,
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 60.r,
                          height: 60.r,
                          child: SvgPicture.asset(
                            Assets.svgNavHomeLogo,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: _headingDark,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 44.w,
                          height: 46.h,
                          child: SvgPicture.asset(
                            _supportCardArrowSvg,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
