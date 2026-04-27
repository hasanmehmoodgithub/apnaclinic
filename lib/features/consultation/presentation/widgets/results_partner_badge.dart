import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../generated/assets.dart';
import '../../../lab_test/presentation/widgets/lab_test_figma_image.dart';

class ResultsPartnerBadge extends StatelessWidget {
  const ResultsPartnerBadge({
    super.key,
    required this.partner,
    required this.textTheme,
  });

  final String partner;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final isMediq = partner.trim().toLowerCase() == 'mediq';
    return Container(
      alignment: Alignment.topRight,
      padding: EdgeInsets.only(top: 1.h),
      child: isMediq
          ? LabTestFigmaImage(
              url: Assets.labTestMedIQLogo,
              width: 60.w,
              height: 30.h,
              fit: BoxFit.contain,
            )
          : Text(
              partner,
              style: textTheme.bodySmall?.copyWith(
                color: const Color(0xFF6D49B9),
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
    );
  }
}
