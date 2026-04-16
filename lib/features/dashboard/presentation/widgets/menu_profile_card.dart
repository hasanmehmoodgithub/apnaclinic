import 'package:apnaclinic/components/widgets/action_option_card.dart';
import 'package:apnaclinic/core/extensions/screen_util_extensions.dart';
import 'package:flutter/material.dart';

class MenuProfileCard extends StatelessWidget {
  const MenuProfileCard({
    super.key,
    required this.isLoggedIn,
    required this.name,
    required this.phone,
    required this.onActionTap,
  });

  final bool isLoggedIn;
  final String name;
  final String phone;
  final VoidCallback onActionTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ActionOptionCard(
      title: name,
      subtitle: phone,
      onTap: onActionTap,
      onTrailingTap: onActionTap,
      curveOverlayColor: const Color(0x99EBDFFF),
      trailingOverlayWidth: 124.w,
      trailingOverlayHeight: 40.h,
      contentPadding: EdgeInsets.fromLTRB(28.w, 25.h, 16.w, 24.h),
      titleSpacing: 7,
      titleStyle: theme.textTheme.titleMedium?.copyWith(
        color: const Color(0xFF0E2D55),
        fontWeight: FontWeight.w500,
        fontSize: 20.sp,
        height: 1,
      ),
      subtitleStyle: theme.textTheme.bodyMedium?.copyWith(
        color: const Color(0xFF4A4A4A),
        fontWeight: FontWeight.w400,
        fontSize: 14.sp,
        height: 1,
      ),
      leading: Container(
        width: 46.08.r,
        height: 46.08.r,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFD1DDFE),
        ),
        child: Icon(
          Icons.person_rounded,
          color: isLoggedIn
              ? const Color(0xFF0B77C5)
              : const Color(0xFF6B7280),
        ),
      ),
      trailing: OutlinedButton(
        onPressed: onActionTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(
            color: Color(0xFF9BA6A7),
            width: 0.8,
          ),
          foregroundColor: const Color(0xFF0E2D55),
          minimumSize: Size(72.w, 24.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 10.5.w,
            vertical: 9.h,
          ),
          backgroundColor: Colors.transparent,
        ),
        child: Text(
          isLoggedIn ? 'Edit Profile' : 'Login / Signup',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 9.sp,
            color: const Color(0xFF0E2D55),
          ),
        ),
      ),
    );
  }
}
