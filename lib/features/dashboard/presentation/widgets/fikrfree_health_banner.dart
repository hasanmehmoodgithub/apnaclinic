import 'package:flutter/material.dart';
import '../../../../core/extensions/screen_util_extensions.dart';

/// Section title + mint card promoting FikrFree (insurance / health).
class FikrfreeHealthBanner extends StatelessWidget {
  const FikrfreeHealthBanner({super.key, this.onTap});

  final VoidCallback? onTap;

  static const String _logoAsset = 'assets/img/fikar_free.png';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Secure Your Health First',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF111827),
          ),
        ),
        SizedBox(height: 12.h),
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Material(
            color: const Color(0xFFEAF6F1),
            borderRadius: BorderRadius.circular(16.r),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 14.h, 12.w, 14.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'FikrFree',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF111827),
                              letterSpacing: -0.2,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            'Sehat aur insurance ab apke hath mei!',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF4B5563),
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12.w),
                    SizedBox(
                      width: 102.w,
                      height: 86.h,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Icon(
                              Icons.chevron_right_rounded,
                              color: const Color(0xFF0D9488),
                              size: 26.r,
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Image.asset(
                              _logoAsset,
                              height: 45.h,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
