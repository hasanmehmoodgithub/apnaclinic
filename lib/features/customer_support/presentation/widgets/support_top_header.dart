import 'package:apnaclinic/core/extensions/screen_util_extensions.dart';
import 'package:flutter/material.dart';

class SupportTopHeader extends StatelessWidget {
  const SupportTopHeader({
    super.key,
    required this.showBackButton,
    required this.onBack,
  });

  final bool showBackButton;
  final VoidCallback? onBack;

  static const String _heroAsset = 'assets/img/support/support_hero.png';
  static const Color _titleNavy = Color(0xFF0B2239);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFC8EEF2), Color(0xFFE2F5F7), Color(0xFFF0FAFB)],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SizedBox(
              height: kToolbarHeight,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: showBackButton
                        ? IconButton(
                            onPressed:
                                onBack ??
                                () => Navigator.of(context).maybePop(),
                            icon: const Icon(Icons.arrow_back_rounded),
                            color: _titleNavy,
                          )
                        : SizedBox(width: 48.w),
                  ),
                  Text(
                    'Customer Support',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: _titleNavy,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 1.h, 0, 30.h),
                child: Image.asset(
                  _heroAsset,
                  fit: BoxFit.fill,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
