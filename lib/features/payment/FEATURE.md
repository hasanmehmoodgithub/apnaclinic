# Payment (card WebView)

## Purpose

After a booking API returns `data.paymentUrl`, open an in-app WebView for JazzCash/Rox card payment. On success, the calling feature shows its existing booking success dialog. Instant Doctor is excluded (uses its own redirect WebView).

## Routes / entry

- `AppRoutes.cardPayment` — `PaymentWebViewScreen` via `PaymentWebViewArgs(paymentUrl:, title?)`.
- Helpers: `openCardPaymentWebView`, `settleCardPaymentIfNeeded`, `showCardPaymentOutcomeSnackBar` in `payment_navigation.dart`.

## Success / fail detection

Rox callback HTML (`…/api/subscription/v1/jazzcash/callback`) exposes:

```js
window.AndroidInterface.postMessage(JSON.stringify({
  status: "success",
  success: true,
  message: "...",
  statusCode: 200
}));
```

(Fired from **Return to ROX App** / `handleSuccess()`.)

App registers JS channel **`AndroidInterface`**, parses JSON or plain `"success"`.

Also:

- On pages whose URL contains `/api/subscription/v1/jazzcash/callback`, app auto-runs `handleSuccess()` and falls back to success after a short delay if the bridge does not fire.
- Closing the WebView early → `cancelled`.
- **Android SSL:** `NavigationDelegate.onSslAuthError` calls `proceed()` so staging payment hosts (corp/self-signed certs) load in WebView the same way Dio trust-alls via `AppHttpOverrides`.

## Data

`PaymentInitiationResult.fromBookingResponse(map)` reads `paymentUrl`, `orderId`, `publicId`, `status`, `inProgress` from booking envelopes.

Wired when `paymentUrl` is present:

- Consultation summary → after `SubmitConsultationBookingUseCase`
- Lab checkout → after `BookLabTestUseCase`
- Pharmacy checkout → after order checkout result
- Surgery booking details → after `BookSurgeryUseCase`
