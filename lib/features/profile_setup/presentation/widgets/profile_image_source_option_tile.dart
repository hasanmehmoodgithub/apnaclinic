import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

class ProfileImageSourceOptionTile extends StatelessWidget {
  const ProfileImageSourceOptionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0),
      dense: true,
      minLeadingWidth: 28.w,
      leading: Icon(icon, color: AppColors.clr4D5A70, size: 22.r),
      title: Text(
        label,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: AppColors.clr1A2B49,
          fontSize: 14.sp,
        ),
      ),
      onTap: onTap,
    );
  }
}
