import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Title block above search in the pharmacy main panel.
class PharmacyMainSectionTitleWidget extends StatelessWidget {
  const PharmacyMainSectionTitleWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: AppColors.clr1A2B49,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
