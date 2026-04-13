import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

import '../../../../core/router/app_routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  static const String seenKey = 'onboarding_seen';

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  static const Color _mint = Color(0xFF0FAE9D);
  static const Color _bgBottom = Color(0xFFE5F1F3);
  static const Color _subtitle = Color(0xFF6E6E6E);

  static const List<_OnboardingPageData> _pages = [
    _OnboardingPageData(
      title: 'Doctor Consultation',
      subtitle: 'Access to PMDC certified doctors',
      imageAsset: 'assets/img/onboarding/doctor_consultation.png',
    ),
    _OnboardingPageData(
      title: 'Pharmacy',
      subtitle: 'Get authentic medicines at your doorstep.',
      imageAsset: 'assets/img/onboarding/pharmacy.png',
    ),
    _OnboardingPageData(
      title: 'Laboratory Testing',
      subtitle: 'Access reliable lab tests with accurate results.',
      imageAsset: 'assets/img/onboarding/laboratory.png',
    ),
    _OnboardingPageData(
      title: 'Surgery Booking',
      subtitle: 'Book your surgery with ease.',
      imageAsset: 'assets/img/onboarding/surgery_booking.png',
    ),
  ];

  bool get _isLast => _currentIndex == _pages.length - 1;

  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(OnboardingScreen.seenKey, true);
    if (!mounted) return;
    context.go(AppRoutes.path(AppRoutes.home));
  }

  Future<void> _onNext() async {
    if (_isLast) {
      await _finishOnboarding();
      return;
    }
    await _pageController.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final scale = math.min(
            constraints.maxWidth / 430,
            constraints.maxHeight / 932,
          );
          final canvasWidth = 430 * scale;
          final canvasHeight = 932 * scale;
          final left = (constraints.maxWidth - canvasWidth) / 2;
          final top = (constraints.maxHeight - canvasHeight) / 2;

          return Stack(
            children: [
              Positioned(
                left: left,
                top: top,
                width: canvasWidth,
                height: canvasHeight,
                child: ClipRect(
                  child: Stack(
                    children: [
                      _OnboardingBackdrop(scale: scale),
                      Positioned(
                        top: 58 * scale,
                        right: 26 * scale,
                        child: TextButton(
                          onPressed: _finishOnboarding,
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                            textStyle: TextStyle(
                              fontSize: 20 * scale,
                              fontWeight: FontWeight.w400,
                            ),
                            padding: EdgeInsets.zero,
                            minimumSize: Size(37 * scale, 20 * scale),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text('Skip'),
                        ),
                      ),
                      Positioned(
                        left: 103.71 * scale,
                        top: 119.84 * scale,
                        child: SvgPicture.asset(
                          'assets/svg/brand_apna_clinic.svg',
                          width: 222.58 * scale,
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 212 * scale,
                        height: 560 * scale,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: _pages.length,
                          onPageChanged: (value) =>
                              setState(() => _currentIndex = value),
                          itemBuilder: (context, index) => _OnboardingPage(
                            page: _pages[index],
                            scale: scale,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 793 * scale,
                        left: 0,
                        right: 0,
                        child: _PagerIndicator(
                          count: _pages.length,
                          activeIndex: _currentIndex,
                          scale: scale,
                        ),
                      ),
                      Positioned(
                        top: 818 * scale,
                        left: (430 - 140.97) * 0.5 * scale,
                        child: SizedBox(
                          width: 140.97 * scale,
                          height: 41.98 * scale,
                          child: FilledButton.icon(
                            onPressed: _onNext,
                            style: FilledButton.styleFrom(
                              backgroundColor: _mint,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  120 * scale,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 24 * scale,
                              ),
                            ),
                            label: Text(
                              'Next',
                              style: TextStyle(
                                fontSize: 18 * scale,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            icon: Icon(
                              Icons.arrow_forward_rounded,
                              size: 24 * scale,
                            ),
                            iconAlignment: IconAlignment.end,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.page, required this.scale});

  final _OnboardingPageData page;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 395 * scale,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 10 * scale,
                child: Container(
                  width: 360 * scale,
                  height: 324 * scale,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _OnboardingScreenState._mint,
                      width: 30 * scale,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Image.asset(
                  page.imageAsset,
                  fit: BoxFit.contain,
                  height: 395 * scale,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 64 * scale),
        Text(
          page.title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 36 * scale,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 22 * scale),
        Text(
          page.subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18 * scale,
            fontWeight: FontWeight.w400,
            color: _OnboardingScreenState._subtitle,
          ),
        ),
      ],
    );
  }
}

class _PagerIndicator extends StatelessWidget {
  const _PagerIndicator({
    required this.count,
    required this.activeIndex,
    required this.scale,
  });

  final int count;
  final int activeIndex;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final active = index == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: EdgeInsets.symmetric(horizontal: 4 * scale),
          width: active ? 58.48 * scale : 16.58 * scale,
          height: 2 * scale,
          decoration: BoxDecoration(
            color: active ? const Color(0xFF0E5C97) : const Color(0xFFBCBCBC),
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}

class _OnboardingBackdrop extends StatelessWidget {
  const _OnboardingBackdrop({required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -100 * scale,
          left: -100 * scale,
          right: 0,
          child: SvgPicture.asset(
            'assets/svg/onboarding_bg_top.svg',
            fit: BoxFit.fitWidth,
          ),
        ),
        Positioned(
          right: -140 * scale,
          bottom: -130 * scale,
          child: Container(
            width: 360 * scale,
            height: 220 * scale,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: _OnboardingScreenState._bgBottom,
            ),
          ),
        ),
      ],
    );
  }
}

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.title,
    required this.subtitle,
    required this.imageAsset,
  });

  final String title;
  final String subtitle;
  final String imageAsset;
}
