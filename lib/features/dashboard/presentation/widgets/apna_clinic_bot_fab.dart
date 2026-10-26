import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/apna_clinic_bot_animation.dart';
import '../constants/main_navigation_tabs.dart';
import '../cubit/main_navigation_cubit.dart';

/// Floating Apna Clinic bot on home. Tap opens Apna Clinic AI.
class ApnaClinicBotFab extends StatefulWidget {
  const ApnaClinicBotFab({super.key});

  @override
  State<ApnaClinicBotFab> createState() => _ApnaClinicBotFabState();
}

class _ApnaClinicBotFabState extends State<ApnaClinicBotFab>
    with TickerProviderStateMixin {
  late final AnimationController _enter;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _enter = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 640),
    )..forward();
  }

  @override
  void dispose() {
    _enter.dispose();
    super.dispose();
  }

  void _openAi() {
    context.pushNamed(AppRoutes.apnaClinicAi);
  }

  @override
  Widget build(BuildContext context) {
    final animate = context.select<MainNavigationCubit, bool>(
      (cubit) => cubit.state.currentIndex == MainNavigationTabs.home,
    );
    final l10n = AppLocalizations.of(context)!;

    return Semantics(
      button: true,
      excludeSemantics: true,
      label: '${l10n.apnaClinicBotLabel}. ${l10n.apnaClinicBotBubble}',
      child: GestureDetector(
        onTap: _openAi,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedBuilder(
          animation: _enter,
          builder: (context, child) {
            final enter = Curves.easeOutBack.transform(_enter.value);
            final scale = (enter * (_pressed ? 0.94 : 1)).clamp(0.0, 1.15);
            return Transform.scale(scale: scale, child: child);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _AskBubble(
                title: l10n.apnaClinicBotLabel,
                subtitle: l10n.apnaClinicBotBubble,
              ),
              SizedBox(height: 4.h),
              ApnaClinicBotAnimation(enabled: animate),
            ],
          ),
        ),
      ),
    );
  }
}

class _AskBubble extends StatelessWidget {
  const _AskBubble({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: 148.w),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
          decoration: BoxDecoration(
            color: AppColors.clrWhite,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.clrE8F8F5),
            boxShadow: [
              BoxShadow(
                color: AppColors.clr061E40.withValues(alpha: 0.08),
                blurRadius: 12.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.clr00897B,
                  fontWeight: FontWeight.w700,
                  fontSize: 12.sp,
                  height: 1.15,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.clr6B7280,
                  fontWeight: FontWeight.w500,
                  fontSize: 11.sp,
                  height: 1.15,
                ),
              ),
            ],
          ),
        ),
        CustomPaint(size: Size(12.r, 7.r), painter: const _BubbleTailPainter()),
      ],
    );
  }
}

class _BubbleTailPainter extends CustomPainter {
  const _BubbleTailPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = AppColors.clrWhite);
    final edge = Paint()
      ..color = AppColors.clrE8F8F5
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawLine(Offset(0, 0), Offset(size.width / 2, size.height), edge);
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width / 2, size.height),
      edge,
    );
  }

  @override
  bool shouldRepaint(covariant _BubbleTailPainter oldDelegate) => false;
}
