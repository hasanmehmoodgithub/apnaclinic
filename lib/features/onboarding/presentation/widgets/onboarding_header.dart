import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({
    super.key,
    required this.scale,
    required this.onSkip,
  });

  final double scale;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 58 * scale,
          right: 26 * scale,
          child: TextButton(
            onPressed: onSkip,
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              textStyle: TextStyle(
                fontSize: 20 * scale,
                fontWeight: FontWeight.w400,
              ),
              padding: EdgeInsets.zero,
              minimumSize: Size(37 * scale, 20 * scale),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('Skip'),
          ),
        ),
        Positioned(
          left: 103.71 * scale,
          top: 119.84 * scale,
          child: SvgPicture.asset(
            'assets/svg/brand_apna_clinic.svg',
            width: 222.58 * scale,
          ),
        ),
      ],
    );
  }
}
