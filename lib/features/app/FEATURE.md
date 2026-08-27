# App shell

## Purpose

Root `ApnaClinicApp` (theme, l10n, router, global cubits) and cold-start splash.

## Routes / entry

- `AppRoutes.splash` — first Flutter screen (`AppRouter` `initialLocation`).
- After splash: onboarding, profile setup, or home via `GetInitialRouteUseCase`.

## Splash

Shows `SplashBackgroundImageWidget` for at least 2 seconds while:

- Prefetching CMS support content (`GetCustomerSupportContentUseCase`, 5s timeout)
- Awaiting `SecurityService.ensureChecked()` (same future as `SecurityGate`)

Does not navigate if the device is compromised; `SecurityGate` then shows the blocked screen.

## State

- `AppCubit` — app-level UI state
