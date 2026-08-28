import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

class InstantDoctorConsultationAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const InstantDoctorConsultationAppBarWidget({
    super.key,
    required this.title,
    this.onBackTap,
  });

  final String title;
  final VoidCallback? onBackTap;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: AppColors.clrWhite,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: onBackTap ?? () => context.pop(),
        icon: const Icon(Icons.arrow_back_rounded, color: AppColors.clr060),
      ),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          color: AppColors.clr060,
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: true,
    );
  }
}
