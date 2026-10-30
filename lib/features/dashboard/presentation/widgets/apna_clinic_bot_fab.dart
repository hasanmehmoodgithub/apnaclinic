import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/apna_clinic_ai_bot_lottie.dart';
import '../../../../generated/assets.dart';
import '../constants/main_navigation_tabs.dart';
import '../cubit/main_navigation_cubit.dart';

/// Floating doctor-bot on home. Tap opens Apna Clinic AI.
class ApnaClinicBotFab extends StatefulWidget {
  const ApnaClinicBotFab({super.key});

  @override
  State<ApnaClinicBotFab> createState() => _ApnaClinicBotFabState();
}

class _ApnaClinicBotFabState extends State<ApnaClinicBotFab>
    with TickerProviderStateMixin {
  late final AnimationController _enter;
  late final AnimationController _float;
  late final AnimationController _orbit;
  bool _pressed = false;

  static const _orbitLogos = [
    Assets.imgApnaClinicAiChipDoctor,
    Assets.imgApnaClinicAiChipMedicine,
  ];

  @override
  void initState() {
    super.initState();
    _enter = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 640),
    )..forward();
    _float = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _orbit = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 8000),
    )..repeat();
  }

  @override
  void dispose() {
    _enter.dispose();
    _float.dispose();
    _orbit.dispose();
    super.dispose();
  }

  void _syncFloat(bool enabled) {
    if (enabled) {
      if (!_float.isAnimating) _float.repeat(reverse: true);
      if (!_orbit.isAnimating) _orbit.repeat();
    } else {
      if (_float.isAnimating) _float.stop();
      if (_orbit.isAnimating) _orbit.stop();
    }
  }

  void _openAi() {
    context.pushNamed(AppRoutes.apnaClinicAi);
  }

  @override
  Widget build(BuildContext context) {
    final animate = context.select<MainNavigationCubit, bool>(
      (cubit) => cubit.state.currentIndex == MainNavigationTabs.home,
    );
    _syncFloat(animate);
    final l10n = AppLocalizations.of(context)!;

    return Semantics(
      button: true,
      excludeSemantics: true,
      label: '${l10n.apnaClinicBotLabel}. ${l10n.apnaClinicAiAskAnything}',
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
              AnimatedBuilder(
                animation: _float,
                builder: (context, child) {
                  final lift = Curves.easeInOut.transform(_float.value);
                  return Transform.translate(
                    offset: Offset(-25.r, -6.h * lift),
                    child: Transform.scale(
                      scale: 0.96 + (0.08 * lift),
                      alignment: Alignment.centerRight,
                      child: child,
                    ),
                  );
                },
                child: _AskBubble(text: l10n.apnaClinicAiAskAnything),
              ),
              SizedBox(height: 2.h),
              _OrbitingBot(
                orbit: _orbit,
                animate: animate,
                logos: _orbitLogos,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Stethoscope and pharmacy logos orbit under the face, inside the bot.
class _OrbitingBot extends StatelessWidget {
  const _OrbitingBot({
    required this.orbit,
    required this.animate,
    required this.logos,
  });

  final Animation<double> orbit;
  final bool animate;
  final List<String> logos;

  @override
  Widget build(BuildContext context) {
    final bot = 50.r;
    final chip = 12.r;
    // Ellipse sits on the lower half so the path stays under the face.
    final centerY = bot * 0.22;
    final radiusX = bot * 0.22;
    final radiusY = bot * 0.07;
    return SizedBox(
      width: bot,
      height: bot,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ApnaClinicAiBotLottie(size: 50, animate: animate),
          ClipOval(
            child: SizedBox(
              width: bot,
              height: bot,
              child: AnimatedBuilder(
                animation: orbit,
                builder: (context, _) {
                  final turn = orbit.value * math.pi * 2;
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      for (var i = 0; i < logos.length; i++)
                        Transform.translate(
                          offset: Offset(
                            math.cos(turn + (i * math.pi)) * radiusX,
                            centerY +
                                math.sin(turn + (i * math.pi)) * radiusY,
                          ),
                          child: _OrbitLogo(asset: logos[i], size: chip),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrbitLogo extends StatelessWidget {
  const _OrbitLogo({required this.asset, required this.size});

  final String asset;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(3.r),
      decoration: BoxDecoration(
        color: AppColors.clrWhite,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.clr061E40.withValues(alpha: 0.12),
            blurRadius: 6.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Image.asset(asset, fit: BoxFit.contain),
    );
  }
}

class _AskBubble extends StatelessWidget {
  const _AskBubble({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.clrWhite,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.clr061E40.withValues(alpha: 0.08),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.clr061E40,
          fontWeight: FontWeight.w700,
          fontSize: 10.sp,
          height: 1.1,
        ),
      ),
    );
  }
}
