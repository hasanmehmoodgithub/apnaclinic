import 'package:apnaclinic/components/widgets/action_option_card.dart';
import 'package:apnaclinic/core/constants/app_colors.dart';
import 'package:apnaclinic/core/extensions/screen_util_extensions.dart';
import 'package:flutter/material.dart';

class MenuActionTile extends StatelessWidget {
  const MenuActionTile({
    super.key,
    required this.title,
    required this.icon,
    required this.curveOverlayColor,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Color curveOverlayColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionOptionCard(
      title: title,
      onTap: onTap,
      curveOverlayColor: curveOverlayColor,
      leading: Container(
        width: 46.07.r,
        height: 46.14.r,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.black.withValues(alpha: 0.21),
            width: 0.33.r,
          ),
        ),
        child: Icon(icon, size: 24.r, color: AppColors.clr303D4F),
      ),
    );
  }
}
