import 'package:apnaclinic/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Customer Support: cyan header + shield/phone hero, overlapping help body.
class CustomerSupportScreen extends StatelessWidget {
  const CustomerSupportScreen({super.key, required this.onBack});

  final VoidCallback onBack;

  static const String _heroAsset = 'assets/img/support/support_hero.png';
  static const String _supportCardArrowSvg =
      'assets/svg/ic_support_card_arrow.svg';

  static const Color _titleNavy = Color(0xFF0B2239);
  static const Color _headingDark = Color(0xFF111827);
  static const Color _subtitleGrey = Color(0xFF6B7280);

  static const double _topBannerFraction = 0.32;
  static const double _cardOverlap = 32;
  static const double _cardTopRadius = 32;

  @override
  Widget build(BuildContext context) {
    final bannerHeight = MediaQuery.sizeOf(context).height * _topBannerFraction;

    return ColoredBox(
      color: const Color(0xFFF8FAF9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: bannerHeight,
            child: _SupportTopHeader(onBack: onBack),
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
  const _SupportTopHeader({required this.onBack});

  final VoidCallback onBack;

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
                    child: IconButton(
                      onPressed: onBack,
                      icon: const Icon(Icons.arrow_back_rounded),
                      color: CustomerSupportScreen._titleNavy,
                    ),
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
                padding: const EdgeInsets.fromLTRB(24, 4, 24, 8),
                child: Image.asset(
                  CustomerSupportScreen._heroAsset,
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomCenter,
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
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
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
              const SizedBox(height: 8),
              Text(
                'Reach out to Apna Clinic for any support.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: CustomerSupportScreen._subtitleGrey,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              _ApnaSupportCard(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Apna Clinic Support — coming soon.'),
                      behavior: SnackBarBehavior.floating,
                    ),
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
  static const Color _accentBlob = Color(0xFFF0F4FF);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const radius = BorderRadius.all(Radius.circular(_radius));

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
                blurRadius: 10,
                offset: const Offset(0, 2),
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
                  right: -56,
                  top: -8,
                  bottom: -8,
                  child: Center(
                    child: Container(
                      width: 132,
                      height: 132,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: _accentBlob,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        padding: const EdgeInsets.all(7),
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
                      const SizedBox(width: 12),
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
                        width: 44,
                        height: 46,
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
