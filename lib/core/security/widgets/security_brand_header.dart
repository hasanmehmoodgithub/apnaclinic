import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../generated/assets.dart';
import '../../constants/app_text_styles.dart';
import '../../extensions/screen_util_extensions.dart';
import '../../flavor/flavor_config.dart';

/// Brand lockup used on the SecurityGate blocked screen.
class SecurityBrandHeader extends StatelessWidget {
  const SecurityBrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          Assets.svgBrandApnaClinic,
          width: 220.w,
          fit: BoxFit.contain,
        ),
        SizedBox(height: 8.h),
      ],
    );
  }
}
