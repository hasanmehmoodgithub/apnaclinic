import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/extensions/screen_util_extensions.dart';

class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({
    super.key,
    required this.scale,
    required this.skipLabel,
    required this.onSkip,
  });

  final double scale;
  final String skipLabel;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 58.h * scale,
          right: 26.w * scale,
          child: TextButton(
            onPressed: onSkip,
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              textStyle: TextStyle(
                fontSize: 20.sp * scale,
                fontWeight: FontWeight.w400,
              ),
              padding: EdgeInsets.zero,
              minimumSize: Size(37.w * scale, 20.h * scale),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(skipLabel),
          ),
        ),
        Positioned(
          left: 103.71.w * scale,
          top: 119.84.h * scale,
          child: SvgPicture.asset(
            'assets/svg/brand_apna_clinic.svg',
            width: 222.58.w * scale,
          ),
        ),
      ],
    );
  }
}
