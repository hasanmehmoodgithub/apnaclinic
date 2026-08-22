# Onboarding

## Purpose
Intro carousel (4 active pages) before first use; skip or finish stores intro
completion in `AppPref.isOnboardingCompleted` and navigates to home, or to
profile setup when logged in without a completed profile.

## Routes / entry
- `AppRoutes.onboarding` — from splash when onboarding not completed.
- Skip / last-page Next → `AppRoutes.home`.

## State
- Local `PageController` + `_currentIndex` on `OnboardingScreen` (no Cubit).

## DI
- `CompleteOnboardingUseCase` → `AppPref.setOnboardingCompleted(true)`.
- `AnalyticsService` from core (see `lib/core/analytics/ANALYTICS.md`).

## Analytics
`AnalyticsService.logEvent` from `OnboardingScreen` (first open / page change / Skip).
1-based `step_number`.

| Event | When |
|---|---|
| `onboarding_step_1` | Instant doctor (screen open) |
| `onboarding_step_2` | Lands on book consultation |
| `onboarding_step_3` | Lands on pharmacy |
| `onboarding_step_4` | Lands on laboratory |
| `onboarding_skipped` | Skip; `step_number` is the page left |

Completing via last-page Next is not a skip.

## Layout (responsive)
- Figma artboard **430×932**; `onboardingScale()` = `min(width/430, height/932)`.
- Header logo: `Assets.imgBrandAlfahealth` (`assets/img/brand_alfahealth.png`).
- Column: header → `Expanded` page view → pager → next button (`SafeArea`).
- Page content scrolls on very short screens; image/title sizes clamped via scale.
