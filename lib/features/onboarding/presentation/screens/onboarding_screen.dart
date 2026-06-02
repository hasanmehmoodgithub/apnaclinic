import 'package:apnaclinic/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
                      onSkip: _finishOnboarding,
                    ),
                    Expanded(
                      child: OnboardingPageView(
                        controller: _pageController,
                        pages: pages,
                        scale: scale,
                        onPageChanged: (value) =>
                            setState(() => _currentIndex = value),
                      ),
                    ),
                    OnboardingPagerIndicator(
                      count: pages.length,
                      activeIndex: _currentIndex,
                      scale: scale,
                    ),
                    SizedBox(height: onboardingScaled(16, scale)),
                    Center(
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
        title: l10n.onboardingDoctorConsultationTitle,
        subtitle: l10n.onboardingDoctorConsultationSubtitle,
        imageAsset: Assets.onboardingDoctorConsultation,
      ),
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
      OnboardingPageData(
        title: l10n.onboardingSurgeryTitle,
        subtitle: l10n.onboardingSurgerySubtitle,
        imageAsset: Assets.onboardingSurgeryBooking,
      ),
    ];
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
