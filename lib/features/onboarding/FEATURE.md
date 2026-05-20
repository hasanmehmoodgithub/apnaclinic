# Onboarding

## Purpose
Intro carousel (4 pages) before first use; skip or finish stores completion in `AppPref` and navigates to home.

## Routes / entry
- `AppRoutes.onboarding` — from splash when onboarding not completed.
- Skip / last-page Next → `AppRoutes.home`.

## State
- Local `PageController` + `_currentIndex` on `OnboardingScreen` (no Cubit).

## DI
- `CompleteOnboardingUseCase` → `AppPref.setOnboardingCompleted(true)`.

## Layout (responsive)
- Figma artboard **430×932**; `onboardingScale()` = `min(width/430, height/932)`.
- Column: header → `Expanded` page view → pager → next button (`SafeArea`).
- Page content scrolls on very short screens; image/title sizes clamped via scale.
