import 'dart:async';

import 'package:apnaclinic/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/analytics/analytics_event_keys.dart';
import '../../../../core/analytics/analytics_service.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/router/app_routes.dart';
import '../../../profile_setup/presentation/profile_setup_launch_source.dart';
import '../../domain/use_cases/complete_onboarding_use_case.dart';
import '../widgets/onboarding_backdrop.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/onboarding_next_button.dart';
import '../widgets/onboarding_page_data.dart';
import '../widgets/onboarding_page_view.dart';
import '../widgets/onboarding_pager_indicator.dart';
import '../widgets/onboarding_scale.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  late final CompleteOnboardingUseCase _completeOnboardingUseCase;
  late final AnalyticsService _analytics;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _completeOnboardingUseCase = CompleteOnboardingUseCase(sl<AppPref>());
    _analytics = sl<AnalyticsService>();
    _logStep(0);
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
          final scale = onboardingScale(constraints);
          final bottomPad = onboardingScaled(24, scale).clamp(12.0, 32.0);

          return Stack(
            fit: StackFit.expand,
            children: [
              OnboardingBackdrop(scale: scale),
              SafeArea(
                child: Column(
                  children: [
                    OnboardingHeader(
                      scale: scale,
                      skipLabel: l10n.onboardingSkip,
                      onSkip: _onSkip,
                    ),
                    Expanded(
                      child: OnboardingPageView(
                        controller: _pageController,
                        pages: pages,
                        scale: scale,
                        onPageChanged: _onPageChanged,
                      ),
                    ),
                    OnboardingPagerIndicator(
                      count: pages.length,
                      activeIndex: _currentIndex,
                      scale: scale,
                    ),
                    SizedBox(height: onboardingScaled(20, scale)),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: onboardingScaled(50, scale),
                      ),
                      child: OnboardingNextButton(
                        scale: scale,
                        label: l10n.onboardingNext,
                        onTap: () => _onNext(pages.length),
                      ),
                    ),
                    SizedBox(height: bottomPad),
                  ],
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
        title: l10n.onboardingInstantDoctorTitle,
        subtitle: l10n.onboardingInstantDoctorSubtitle,
        imageAsset: Assets.onboardingInstantDoctor,
      ),
      OnboardingPageData(
        title: l10n.onboardingBookConsultationTitle,
        subtitle: l10n.onboardingBookConsultationSubtitle,
        imageAsset: Assets.onboardingBookConsultation,
      ),
      // OnboardingPageData(
      //   title: l10n.onboardingDoctorConsultationTitle,
      //   subtitle: l10n.onboardingDoctorConsultationSubtitle,
      //   imageAsset: Assets.onboardingDoctorConsultation,
      // ),
      OnboardingPageData(
        title: l10n.onboardingPharmacyTitle,
        subtitle: l10n.onboardingPharmacySubtitle,
        imageAsset: Assets.onboardingPharmacy,
      ),
      OnboardingPageData(
        title: l10n.onboardingLaboratoryTitle,
        subtitle: l10n.onboardingLaboratorySubtitle,
        imageAsset: Assets.onboardingLaboratory,
      ),
      // OnboardingPageData(
      //   title: l10n.onboardingSurgeryTitle,
      //   subtitle: l10n.onboardingSurgerySubtitle,
      //   imageAsset: Assets.onboardingSurgeryBooking,
      // ),
    ];
  }

  void _logStep(int index) {
    final step = index + 1;
    unawaited(
      _analytics.logEvent(
        AnalyticsEventKeys.onboardingStep(step),
        {AnalyticsParamKeys.stepNumber: step},
      ),
    );
  }

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
    _logStep(index);
  }

  Future<void> _onSkip() async {
    unawaited(
      _analytics.logEvent(
        AnalyticsEventKeys.onboardingSkipped,
        {AnalyticsParamKeys.stepNumber: _currentIndex + 1},
      ),
    );
    await _finishOnboarding();
  }

  Future<void> _finishOnboarding() async {
    await _completeOnboardingUseCase();
    if (!mounted) return;
    final appPref = sl<AppPref>();
    if (appPref.getLoginStatus() && !appPref.isProfileCompleted()) {
      context.go(
        AppRoutes.path(AppRoutes.profileSetup),
        extra: ProfileSetupLaunchSource.onboarding,
      );
      return;
    }
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
