import 'package:apnaclinic/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Free Doctor: mint header + hero, overlapping info card, FikrFree CTA.
class FreeDoctorScreen extends StatelessWidget {
  const FreeDoctorScreen({super.key, required this.onBack});

  final VoidCallback onBack;

  static const String _watermarkAsset = 'assets/img/fikrfree_logo.png';

  static const Color _titleNavy = Color(0xFF0B2239);
  static const Color _bodyText = Color(0xFF374151);
  static const Color _primaryTeal = Color(0xFF0FAA9A);
  static const Color _iconTileBg = Color(0xFFE8F5F3);

  static const double _cardOverlap = 32;
  static const double _cardTopRadius = 32;

  static const double _topBannerFraction = 0.30;
  static final Uri _fikrfreeUrl = Uri.parse('https://www.fikrfree.com');

  @override
  Widget build(BuildContext context) {
    final bannerHeight =
        MediaQuery.sizeOf(context).height * _topBannerFraction;

    return ColoredBox(
      color: const Color(0xFFF4F6F8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: bannerHeight,
            child: _FreeDoctorTopHeader(onBack: onBack),
          ),
          const Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: -_cardOverlap,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _ConsultationInfoCard(),
                ),
              ],
            ),
          ),
          _OpenFikrfreeButton(
            onPressed: () => _openFikrfree(context),
          ),
        ],
      ),
    );
  }

  Future<void> _openFikrfree(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final opened = await launchUrl(
      _fikrfreeUrl,
      mode: LaunchMode.externalApplication,
    );
    if (!opened && context.mounted) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Could not open FikrFree right now.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

class _FreeDoctorTopHeader extends StatelessWidget {
  const _FreeDoctorTopHeader({required this.onBack});

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
          colors: [
            Color(0xFFB8EDE5),
            Color(0xFFE8F8F5),
            Color(0xFFF5FBFA),
          ],
          stops: [0.0, 0.55, 1.0],
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
                      color: FreeDoctorScreen._titleNavy,
                    ),
                  ),
                  Text(
                    'Free Doctor',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: FreeDoctorScreen._titleNavy,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(2, 2, 2, 8),
                child: Image.asset(
                  Assets.imgHeroFamily,
                  fit: BoxFit.cover,
                  width: 200,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConsultationInfoCard extends StatelessWidget {
  const _ConsultationInfoCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const radius = BorderRadius.vertical(
      top: Radius.circular(FreeDoctorScreen._cardTopRadius),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6F8),
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
        child: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: Center(
                  child: Opacity(
                    opacity: 0.09,
                    child: Image.asset(
                      FreeDoctorScreen._watermarkAsset,
                      width: 260,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: FreeDoctorScreen._iconTileBg,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.medical_services_rounded,
                            color: FreeDoctorScreen._primaryTeal,
                            size: 28,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          '24/7 Free Doctor Consultation',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: FreeDoctorScreen._titleNavy,
                            height: 1.25,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  _Bullet(
                    text:
                        'This service is available exclusively for Bima m-Health subscribers.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: FreeDoctorScreen._bodyText,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _Bullet(
                    text:
                        'Get 24/7 access to qualified doctors for general medical support and much more.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: FreeDoctorScreen._bodyText,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _Bullet(
                    text:
                        'To avail the service, subscribe to BIMA m-Health via FikrFree.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: FreeDoctorScreen._bodyText,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.text, required this.style});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 7),
          child: Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFF111827),
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: style)),
      ],
    );
  }
}

class _OpenFikrfreeButton extends StatelessWidget {
  const _OpenFikrfreeButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: FreeDoctorScreen._primaryTeal,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            'Open Fikrfree app',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
