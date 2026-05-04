import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/use_cases/complete_onboarding_use_case.dart';
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
  late final CompleteOnboardingUseCase _completeOnboardingUseCase;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _completeOnboardingUseCase = CompleteOnboardingUseCase(sl<AppPref>());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pages = _buildPages(l10n);
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

          return Stack(
            children: [
              Positioned(
                left: left,
                top: 0,
                width: canvasWidth,
                height: canvasHeight,
                child: ClipRect(
                  child: Stack(
                    children: [
                      OnboardingBackdrop(scale: scale),
                      OnboardingHeader(
                        scale: scale,
                        skipLabel: l10n.onboardingSkip,
                        onSkip: _finishOnboarding,
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 212 * scale,
                        height: 560 * scale,
                        child: OnboardingPageView(
                          controller: _pageController,
                          pages: pages,
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
                          count: pages.length,
                          activeIndex: _currentIndex,
                          scale: scale,
                        ),
                      ),
                      Positioned(
                        top: 818 * scale,
                        left: (430 - 140.97) * 0.5 * scale,
                        child: OnboardingNextButton(
                          scale: scale,
                          label: l10n.onboardingNext,
                          onTap: () => _onNext(pages.length),
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

  List<OnboardingPageData> _buildPages(AppLocalizations l10n) {
    return [
      OnboardingPageData(
        title: l10n.onboardingDoctorConsultationTitle,
        subtitle: l10n.onboardingDoctorConsultationSubtitle,
        imageAsset: 'assets/img/onboarding/doctor_consultation.webp',
      ),
      OnboardingPageData(
        title: l10n.onboardingPharmacyTitle,
        subtitle: l10n.onboardingPharmacySubtitle,
        imageAsset: 'assets/img/onboarding/pharmacy.webp',
      ),
      OnboardingPageData(
        title: l10n.onboardingLaboratoryTitle,
        subtitle: l10n.onboardingLaboratorySubtitle,
        imageAsset: 'assets/img/onboarding/laboratory.webp',
      ),
      OnboardingPageData(
        title: l10n.onboardingSurgeryTitle,
        subtitle: l10n.onboardingSurgerySubtitle,
        imageAsset: 'assets/img/onboarding/surgery_booking.webp',
      ),
    ];
  }

  Future<void> _finishOnboarding() async {
    await _completeOnboardingUseCase();
    if (!mounted) return;
    context.go(AppRoutes.path(AppRoutes.home));
  }

  Future<void> _onNext(int pageCount) async {
    if (_currentIndex == pageCount - 1) {
      await _finishOnboarding();
      return;
    }
    await _pageController.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }
}
