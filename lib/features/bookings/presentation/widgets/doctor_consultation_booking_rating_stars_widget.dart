import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../generated/assets.dart';

class DoctorConsultationBookingRatingStarsWidget extends StatelessWidget {
  const DoctorConsultationBookingRatingStarsWidget({
    super.key,
    required this.rating,
    this.size,
    this.spacing,
    this.onStarTap,
  });

  final double rating;
  final double? size;
  final double? spacing;
  final ValueChanged<double>? onStarTap;

  @override
  Widget build(BuildContext context) {
    final starSize = size ?? 28.r;
    final gap = spacing ?? 4.w;
    final filledCount = rating.floor().clamp(0, 5);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 1; i <= 5; i++)
          Padding(
            padding: EdgeInsets.only(right: i == 5 ? 0 : gap),
            child: InkWell(
              onTap: onStarTap == null ? null : () => onStarTap!(i.toDouble()),
              borderRadius: BorderRadius.circular(20.r),
              child: Image.asset(
                i <= filledCount
                    ? Assets.consultationStarFilled
                    : Assets.consultationStarUnfilled,
                width: starSize,
                height: starSize,
                fit: BoxFit.contain,
                color: i <= filledCount ? null : AppColors.clrD5D5D5,
                colorBlendMode: i <= filledCount ? null : BlendMode.srcATop,
              ),
            ),
          ),
      ],
    );
  }
}
