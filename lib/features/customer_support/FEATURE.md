# Customer Support feature

## Purpose

Help centre screen with Apna Clinic support card; tapping opens a dialog with CMS support contact details and a call CTA.

## Routes / entry

- `AppRoutes.customerSupport` (from menu / navigation shell).

## Data & APIs

- Fetched through **dashboard** module: `AppUrls.mobileSupport` → `GET /api/v1/mobile/support` (`GetSupportSettingsUseCase` → `CustomerSupportRepositoryImpl` maps to UI entities).
- Mock: `SupportSettingsMockApi` when `MockConfig.enableDashboardMocks` is true.

## State

- `CustomerSupportCubit` — loads content on init; `dialNumber()` launches `tel:` URI.

## DI

- `customer_support_injection.dart` — depends on `DashboardRepository` (dashboard injector must run first).

## UI

- `CustomerSupportScreen` — header + `SupportBodyPanel`.
- Support dialog: phone (+ email when API provides it), description, button text from API.
