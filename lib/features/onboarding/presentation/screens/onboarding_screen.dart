import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/router/app_routes.dart';
import '../widgets/onboarding_backdrop.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/onboarding_next_button.dart';
import '../widgets/onboarding_page_data.dart';
import '../widgets/onboarding_page_view.dart';
import '../widgets/onboarding_pager_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  static const List<OnboardingPageData> _pages = [
    OnboardingPageData(
      title: 'Doctor Consultation',
      subtitle: 'Access to PMDC certified doctors',
      imageAsset: 'assets/img/onboarding/doctor_consultation.webp',
    ),
    OnboardingPageData(
      title: 'Pharmacy',
      subtitle: 'Get authentic medicines at your doorstep.',
      imageAsset: 'assets/img/onboarding/pharmacy.webp',
    ),
    OnboardingPageData(
      title: 'Laboratory Testing',
      subtitle: 'Access reliable lab tests with accurate results.',
      imageAsset: 'assets/img/onboarding/laboratory.webp',
    ),
    OnboardingPageData(
      title: 'Surgery Booking',
      subtitle: 'Book your surgery with ease.',
      imageAsset: 'assets/img/onboarding/surgery_booking.webp',
    ),
  ];

  bool get _isLast => _currentIndex == _pages.length - 1;

  Future<void> _finishOnboarding() async {
    await sl<AppPref>().setOnboardingCompleted(true);
    if (!mounted) return;
    context.go(AppRoutes.path(AppRoutes.authLogin));
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
                      OnboardingBackdrop(scale: scale),
                      OnboardingHeader(scale: scale, onSkip: _finishOnboarding),
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 212 * scale,
                        height: 560 * scale,
                        child: OnboardingPageView(
                          controller: _pageController,
                          pages: _pages,
                          scale: scale,
                          onPageChanged: (value) =>
                              setState(() => _currentIndex = value),
                        ),
                      ),
                      Positioned(
                        top: 793 * scale,
                        left: 0,
                        right: 0,
                        child: OnboardingPagerIndicator(
                          count: _pages.length,
                          activeIndex: _currentIndex,
                          scale: scale,
                        ),
                      ),
                      Positioned(
                        top: 818 * scale,
                        left: (430 - 140.97) * 0.5 * scale,
                        child: OnboardingNextButton(
                          scale: scale,
                          onTap: _onNext,
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
