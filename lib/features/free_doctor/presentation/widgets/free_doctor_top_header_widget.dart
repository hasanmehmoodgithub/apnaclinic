import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../generated/assets.dart';

class FreeDoctorTopHeaderWidget extends StatelessWidget {
  const FreeDoctorTopHeaderWidget({
    super.key,
    required this.title,
    required this.showBackButton,
    required this.onBack,
  });

  final String title;
  final bool showBackButton;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.clrB8EDE5,
            AppColors.clrE8F8F5,
            AppColors.clrF5FBFA,
          ],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SizedBox(
              height: 50.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: showBackButton
                        ? IconButton(
                            onPressed:
                                onBack ??
                                () {
                                  if (context.canPop()) context.pop();
                                },
                            icon: const Icon(Icons.arrow_back_rounded),
                            color: AppColors.clr0B2239,
                          )
                        : SizedBox(width: 48.w),
                  ),
                  Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.clr0B2239,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ClipRect(
                child: Align(
                  alignment: const Alignment(0, 0.32),
                  heightFactor: 0.72,
                  widthFactor: 1,
                  child: Image.asset(
                    Assets.imgHeroFamily,
                    fit: BoxFit.fitWidth,
                    width: context.screenWidth - 80.w,
                    alignment: Alignment.topCenter,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
