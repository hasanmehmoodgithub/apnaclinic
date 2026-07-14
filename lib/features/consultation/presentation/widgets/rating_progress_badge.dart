import 'package:flutter/material.dart';

import '../../../../core/widgets/app_rounded_rating_widget.dart';

/// Use [AppRoundedRatingWidget] for new code.
@Deprecated('Use AppRoundedRatingWidget')
class RatingProgressBadge extends StatelessWidget {
  const RatingProgressBadge({
    super.key,
    required this.rating,
    required this.maxRating,
    required this.textTheme,
  });

  final double rating;
  final double maxRating;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return AppRoundedRatingWidget(
      rating: rating,
      maxRating: maxRating,
      textTheme: textTheme,
    );
  }
}
