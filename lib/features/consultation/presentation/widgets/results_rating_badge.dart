import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/widgets/app_rounded_rating_widget.dart';

/// Prefer [AppRoundedRatingWidget]. Kept for call sites that still pass a rating string.
class ResultsRatingBadge extends StatelessWidget {
  const ResultsRatingBadge({
    super.key,
    required this.textTheme,
    required this.rating,
  });

  final TextTheme textTheme;
  final String rating;

  @override
  Widget build(BuildContext context) {
    final score = double.tryParse(rating.split('/').first.trim()) ?? 0;
    return AppRoundedRatingWidget(
      rating: score,
      textTheme: textTheme,
      width: 56.w,
      height: 24.h,
    );
  }
}
