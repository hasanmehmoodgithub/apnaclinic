# Customer Support feature

## Purpose

Help centre screen with Apna Clinic support card; tapping opens a dialog with CMS support contact details and a call CTA.

## Routes / entry

- `AppRoutes.customerSupport` (from menu / navigation shell).

## Data & APIs

- `AppUrls.mobileSupport` → CMS `GET /api/v1/mobile/support`
- `CustomerSupportRemoteDataSourceImpl.getSupportSettings()` — response fields: `phone`, `email`, `description`, `buttonText`
- Mock: `CustomerSupportMockApi` when `MockConfig.enableMocks` is true

## State

- `CustomerSupportCubit` — loads content on init; `dialNumber()` launches `tel:` URI.

## DI

- `customer_support_injection.dart` — `ApiService`, remote data source, repository, use case, cubit.

## UI

- `CustomerSupportScreen` — header + `SupportBodyPanel`.
- Support dialog: phone (+ email when API provides it), description, button text from API.
