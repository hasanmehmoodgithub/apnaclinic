# Payment (card WebView)

## Purpose

After a booking API returns `data.paymentUrl`, open an in-app WebView for JazzCash/Rox card payment. On success, the calling feature shows its existing booking success dialog. Instant Doctor is excluded (uses its own redirect WebView).

## Routes / entry

- `AppRoutes.cardPayment` — `PaymentWebViewScreen` via `PaymentWebViewArgs(paymentUrl:, title?)`.
- Helpers: `openCardPaymentWebView`, `settleCardPaymentIfNeeded`, `showCardPaymentOutcomeDialog` in `payment_navigation.dart`.

## Success / fail / cancel detection

Rox uses the **same** callback path (`…/api/subscription/v1/jazzcash/callback`) for paid **and** failed/cancelled/dropped HTML. The app must not treat that URL as success.

Success page (`handleSuccess()` / **Return to ROX App**):

```js
window.AndroidInterface.postMessage(JSON.stringify({
  status: "success",
  success: true,
  message: "...",
  statusCode: 200
}));
```

Fail / cancel / dropped page (`handleFailure()` / **Return to ROX App**):

```js
window.AndroidInterface.postMessage(JSON.stringify({
  status: "fail",
  success: false,
  message: "Transaction is dropped.",
  statusCode: 400
}));
```

App registers JS channel **`AndroidInterface`**. `PaymentWebViewResult.tryParseBridgeMessage` accepts JSON or plain tokens (`success`, `fail`, `cancel`, `dropped`, …). `success: false` and `statusCode >= 400` always win over a success guess.

Also:

- On callback pages, inspect title / `.status-chip` / `failureBtn` / `handleSuccess` vs `handleFailure`, then auto-run the matching handler.
- Fallback after a short delay **mirrors the detected outcome** (success, fail, or cancel). Unknown pages wait for the user to tap Return to ROX App — they are never auto-marked paid.
- Callers (`settleCardPaymentIfNeeded`) only show the booking success dialog when `paymentResult.isSuccess`. Cancel and fail open `PaymentOutcomeDialogWidget` with the gateway `message` when present (e.g. “Transaction is dropped.”). App-local copy is used only if the gateway sent no message. Gateway “Transaction is dropped.” is treated as cancel.
- Back/close is disabled by default (`allowClose: false`); the screen stays until the gateway reports success or failure.
- Lab, pharmacy, and doctor consultation checkout open with `allowClose: true` so the user can dismiss via the AppBar **X** only (system back / swipe-back are blocked). **X** still tries `handleFailure()` / the callback page so the dialog can show the gateway `message` (same as **Return to ROX App**). If the gateway has not posted a message yet, it returns `cancelled` with app copy.
- **Android SSL:** `NavigationDelegate.onSslAuthError` calls `proceed()` so staging payment hosts (corp/self-signed certs) load in WebView the same way Dio trust-alls via `AppHttpOverrides`.

## Data

`PaymentInitiationResult.fromBookingResponse(map)` reads `paymentUrl`, `orderId`, `publicId`, `status`, `inProgress` from booking envelopes. `isPendingWithoutPaymentUrl` is true when `status` is `PENDING_PAYMENT` and no payment URL was returned. Lab, consultation, pharmacy, and surgery then show `PaymentPendingDialogWidget` instead of the WebView.

Wired when `paymentUrl` is present:

- Consultation summary → after `SubmitConsultationBookingUseCase`
- Lab checkout → after `BookLabTestUseCase` (same `settleCardPaymentIfNeeded` WebView path as pharmacy)
- Pharmacy checkout → after order checkout result
- Surgery booking details → after `BookSurgeryUseCase`

`PaymentInitiationResult.fromBookingResponse` unwraps `data` / nested `data.data` (pharmacy-style) and reads `paymentUrl` / `payment_url` plus common redirect aliases.
