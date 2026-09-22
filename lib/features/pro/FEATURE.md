# ApnaClinic Pro

## Purpose

Paid **ApnaClinic Pro** membership: show catalog (benefits + plans) in a bottom sheet and let the user pick a plan. Copy, images, benefits, and prices come from the API (mock until backend is live).

## Entry

- `showApnaClinicProSheet(context)` → returns `ProSheetResult?` (`planId`, selected `plan`).
- After subscribe (sheet closes with a plan), shows `showProSubscribeSuccessDialog` by default (`showSuccessDialog: true`).
- Menu → **ApnaClinic Pro** tile opens the sheet.
- Home → `ApnaClinicProHomeBanner` (above Secure Your Health) opens the sheet.
- Also ready for checkout upsell / profile later.

## UI

- Catalog bottom sheet: logo/banner, title, tagline, benefits table, plan cards, CTA (all from API). Uses `useSafeArea: true` so the sheet top sits below the status bar / Dynamic Island; CTA includes bottom inset padding.
- **Active Pro** (`membership.isPro` + `status` `active`/`cancelled`): manage view — ⋮ menu → Cancel Subscription confirm dialog; renew/expiry banner from `expiresAt` + `autoRenew`; Pro benefits list (pro values only). Mock: `ProMockApi.mockAsActivePro`.
- Success dialog: Pro brand mark + title/message + **OK** (`pro_subscribe_success_dialog.dart`).
- `ProUserAvatar` (`lib/core/widgets/pro_user_avatar.dart`) — `imageUrl` + `isPro`; when Pro shows `leftLeave` / `right` laurels + `badgeCrown` under the circle.
- `ProShowInfoWidget` — upsell card (`title`, `subtitle`, `discount`, `isVisible`); not wired yet.

## Data & APIs

| Action | Method | `AppUrls` |
|--------|--------|-----------|
| Catalog | GET | `membershipCatalog` → `/acs-aggregator/api/v1/mobile/membership/catalog` |

Response `data`: `title`, `tagline`, `logoUrl`, `bannerUrl`, `ctaLabel`, benefits table labels, `benefits[]`, `plans[]`, `membership`, `allowedActions`.

Subscribe / payment / unsubscribe APIs are not wired yet (sheet CTA currently returns the selected plan).

## State

- `ProCubit` / `ProState` — load catalog, `selectedPlanId` (defaults to `isCurrent` then `isRecommended`). Home banner reads `membership` / `isCatalogLoading` via `BlocSelector` (no screen `setState`).

## DI

- `pro_injection.dart` → `initProInjector()` from `dependency_injection.dart`.

## Mocks

- `ProMockApi` when `MockConfig.enableProMocks` is true (default **true** until live API is ready).
