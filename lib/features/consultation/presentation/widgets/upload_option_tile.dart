import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';

class UploadOptionTile extends StatelessWidget {
  const UploadOptionTile({
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
      leading: Icon(icon, color: const Color(0xFF4D5869), size: 22.r),
      title: Text(
        label,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: const Color(0xFF2E3A4B),
          fontSize: 14.sp,
        ),
      ),
      onTap: onTap,
    );
  }
}
