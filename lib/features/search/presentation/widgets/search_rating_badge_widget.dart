import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/widgets/app_rounded_rating_widget.dart';

class SearchRatingBadgeWidget extends StatelessWidget {
  const SearchRatingBadgeWidget({
    super.key,
    required this.rating,
  });

  final String rating;

  @override
  Widget build(BuildContext context) {
    final score = double.tryParse(rating.split('/').first.trim()) ?? 0;
    return AppRoundedRatingWidget(
      rating: score,
      width: 56.w,
      height: 24.h,
    );
  }
}
