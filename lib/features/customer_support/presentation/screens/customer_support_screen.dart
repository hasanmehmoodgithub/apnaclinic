import 'package:apnaclinic/core/extensions/context_extensions.dart';
import 'package:apnaclinic/core/extensions/screen_util_extensions.dart';
import 'package:apnaclinic/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Customer Support: cyan header + shield/phone hero, overlapping help body.
class CustomerSupportScreen extends StatelessWidget {
  const CustomerSupportScreen({
    super.key,
    this.showBackButton = true,
    this.onBack,
  });

  final bool showBackButton;
  final VoidCallback? onBack;

  static const String _heroAsset = 'assets/img/support/support_hero.png';
  static const String _supportCardArrowSvg =
      'assets/svg/ic_support_card_arrow.svg';

  static const Color _titleNavy = Color(0xFF0B2239);
  static const Color _headingDark = Color(0xFF111827);
  static const Color _subtitleGrey = Color(0xFF6B7280);

  static const double _topBannerFraction = 0.39;
  static const double _cardOverlap = 32;
  static const double _cardTopRadius = 32;

  @override
  Widget build(BuildContext context) {
    final bannerHeight = MediaQuery.sizeOf(context).height * _topBannerFraction;

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: bannerHeight,
            child: _SupportTopHeader(
              showBackButton: showBackButton,
              onBack: onBack,
            ),
          ),
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: -_cardOverlap,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: const _SupportBodyPanel(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SupportTopHeader extends StatelessWidget {
  const _SupportTopHeader({
    required this.showBackButton,
    required this.onBack,
  });

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
                                onBack ?? () => Navigator.of(context).maybePop(),
                            icon: const Icon(Icons.arrow_back_rounded),
                            color: CustomerSupportScreen._titleNavy,
                          )
                        : SizedBox(width: 48.w),
                  ),
                  Text(
                    'Customer Support',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: CustomerSupportScreen._titleNavy,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 1.h, 0, 30.h),
                child: Image.asset(
                  CustomerSupportScreen._heroAsset,
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

class _SupportBodyPanel extends StatelessWidget {
  const _SupportBodyPanel();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const radius = BorderRadius.vertical(
      top: Radius.circular(CustomerSupportScreen._cardTopRadius),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 24.r,
            offset: Offset(0, -6.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Help Centre',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: CustomerSupportScreen._headingDark,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Reach out to Apna Clinic for any support.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: CustomerSupportScreen._subtitleGrey,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 24.h),
              _ApnaSupportCard(
                onTap: () {
                  showDialog<void>(
                    context: context,
                    builder: (dialogContext) {
                      final theme = Theme.of(dialogContext);
                      return Dialog(
                        backgroundColor: Colors.transparent,
                        insetPadding: EdgeInsets.symmetric(horizontal: 18.w),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFFAFE),
                            borderRadius: BorderRadius.circular(4.r),
                            border: Border.all(color: const Color(0xFFD6DEE6)),
                          ),
                          padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 62.r,
                                height: 62.r,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFFD6D9DE),
                                  ),
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    Assets.imgPartner,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'Customer Support',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color: const Color(0xFF0E2D55),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20.sp,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'Or further support please contact us 24/7 on\n042-111-333-033.',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: const Color(0xFF6C82A2),
                                  height: 1.25,
                                  fontSize: 13.sp,
                                ),
                              ),
                              SizedBox(height: 14.h),
                              SizedBox(
                                width: double.infinity,
                                height: 52.h,
                                child: FilledButton(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: const Color(0xFF40AFA2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                  ),
                                  onPressed: () => Navigator.of(dialogContext).pop(),
                                  child: Text(
                                    'Call Now',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: (22 / 1.6).sp,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ApnaSupportCard extends StatelessWidget {
  const _ApnaSupportCard({required this.onTap});

  final VoidCallback onTap;

  static const double _radius = 12;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = BorderRadius.all(Radius.circular(_radius.r));
    final curveWidth = context.screenWidth * 0.7206; // Figma ratio
    final curveHeight = 281.37.h;
    final curveLeft = context.screenWidth * 0.6290;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: radius,
            border: Border.all(color: const Color(0xFFF3F4F6)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: radius,
            clipBehavior: Clip.antiAlias,
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                Positioned(
                  left: curveLeft,
                  top: -48.78.h,
                  child: IgnorePointer(
                    child: Container(
                      width: curveWidth,
                      height: curveHeight,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFDDE2EE).withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 12.h,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48.r,
                        height: 48.r,
                        padding: EdgeInsets.all(7.r),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: SvgPicture.asset(
                          Assets.svgNavHomeLogo,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          'Apna Clinic Support',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: CustomerSupportScreen._headingDark,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 44.w,
                        height: 46.h,
                        child: SvgPicture.asset(
                          CustomerSupportScreen._supportCardArrowSvg,
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
    );
  }
}
