# HMAC in Apna Clinic (v1)

How request signing works **in this app** — not a generic spec. Open [HMAC.html](HMAC.html) in a browser for the visual twin.

Features do not sign anything themselves. `AuthCubit.requestOtp` still calls `ApiService.post(AppUrls.requestOtp, …)`. A Dio interceptor adds the five HMAC headers before the request leaves the device.

## What problem it solves

TLS encrypts the hop to the gateway. After TLS is terminated, HMAC proves:

- this **app** (android / ios key) sent the request
- the **method + path + body** were not altered
- it was sent **now** (timestamp ±5 minutes)
- it is **not a replay** (nonce used once)

Backend `HMAC_MODE`:

| Mode | Unsigned / bad signature |
|------|--------------------------|
| `off` | Ignored |
| `log` | Request still succeeds; server warning |
| `enforce` | Generic `401` with a reason in the JSON/`error.message` (this environment is **enforce**) |

## What this app signs

`hmacBackendFor(uri)` looks at **path only**:

| Path contains | Backend enum | Signed? |
|---------------|--------------|---------|
| `acs-aggregator` | `HmacBackend.aggregator` | Yes (guest + logged-in) |
| `acs-auth` | `HmacBackend.userAuth` | Yes (OTP, verify, refresh, logout, profile, …) |
| `acs-cmsbe`, `acs-notification`, dummyjson, anything else | `null` | **No** |

Examples that **are** signed:

- `POST /acs-auth/api/v1/auth/otp/generate`
- `POST /acs-auth/api/v1/auth/token/refresh` (separate Dio, still signed)
- `GET /acs-aggregator/api/v1/mobile/cities`

Examples that are **not** signed: banners/services (`acs-cmsbe`), in-app notifications.

HMAC does **not** replace login. Guest aggregator still sends `x-api-key`. Logged-in calls still send `Authorization: Bearer …`. HMAC is extra.

## Request path through the app

Startup (`initDependencyInjection`):

1. `HmacSecretStore()` + `initialize()` — load android/ios secrets, copy into Keystore/Keychain
2. Register store + `ApiService` in GetIt

Each `ApiService` call, interceptors in order:

1. **HeaderInterceptor** — `x-app-*`, `x-device-*`, `x-appsflyer-id` (when ready), `x-api-key`, `x-tenant-id`
2. **AuthInterceptor** — `Authorization` if a token exists
3. **HmacSigningInterceptor** — five HMAC headers; JSON body frozen to a string
4. **ApiLoggerInterceptor** / **Chucker** — you see the signed request

```
Login tap
  → AuthCubit.requestOtp
  → ApiService.post(AppUrls.requestOtp, { msisdn, channel })
  → HeaderInterceptor
  → AuthInterceptor (usually no Bearer yet)
  → HmacSigningInterceptor
       path contains acs-auth → userAuth
       secret = iOS or Android platform key
       digest = SHA-256 of exact JSON bytes
       canonical = v1 + POST + path + timestamp + nonce + digest
       headers: x-key-id, x-timestamp, x-nonce, x-content-digest, x-signature
  → user-auth HmacSignatureGuard
  → 200 or 401
```

## Five headers this app sends

| Header | How this app sets it |
|--------|----------------------|
| `x-key-id` | `ios` if `Platform.isIOS`, else `android` |
| `x-timestamp` | `DateTime.now().millisecondsSinceEpoch` as string |
| `x-nonce` | New UUID v4 **every HTTP attempt** (`hmac_uuid.dart`) |
| `x-content-digest` | Hex SHA-256 of body (see below) |
| `x-signature` | Hex HMAC-SHA256(platform secret, canonical string) |

Canonical string — six lines, `\n` joined, **no trailing newline**:

```
v1
POST
/acs-auth/api/v1/auth/otp/generate
<timestamp ms>
<uuid>
<sha256 hex of body>
```

The path is the **wire path** (scheme/host stripped), including `/acs-auth/api/v1/…`. It is **not** shortened to `/auth/otp/generate`. Query strings stay percent-encoded.

### Body digest

| Request | Digest |
|---------|--------|
| GET / no body (`data == null`) | SHA-256 of empty bytes = `e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855` |
| JSON Map/List (OTP, pharmacy, …) | `jsonEncode` once, **assign that string back to `options.data`**, hash UTF-8 bytes |
| Already a `String` / `Uint8List` | Hash those bytes |
| `FormData` (prescription, profile photo, consultation attachments) | Sorted `name=value` lines + SHA-256 hex of each file’s raw bytes (clone the file stream so upload still works). **Not** the multipart boundary |

OTP generate body becomes exactly:

```json
{"msisdn":"923015077202","channel":"SMS"}
```

(Dart `jsonEncode` — no extra spaces.) That string’s SHA-256 is `x-content-digest`.

## Secrets in this app

Issued keys are **per platform**, not per microservice. Aggregator and user-auth both use the same secret for the running OS.

| `x-key-id` | Source |
|------------|--------|
| `android` | `HMAC_ANDROID_SECRET` (baked-in default, like `MOBILE_API_KEY`) |
| `ios` | `HMAC_IOS_SECRET` (baked-in default) |

Resolution order in `HmacSecretStore.secretFor`:

1. Optional override `HMAC_AGGREGATOR_SECRET` / `HMAC_AUTH_SECRET` (only if backend later splits services)
2. In-memory value from `initialize()` (dart-define → secure storage)
3. Compile-time `fromEnvironment` (including default)
4. Hardcoded platform fallback (so **hot reload** still signs if `initialize()` ran with empty memory)

Never log the secret. `hmac.keys.json` is gitignored; use `--dart-define-from-file=hmac.keys.json` to override without a code change.

**Hot reload vs restart:** GetIt keeps the store singleton. After a secret-code change, **hot restart** (or stop/run) so `initialize()` runs again. Request-time fallback now covers an empty in-memory store.

## Token refresh and 401 retry

- Refresh uses a **second Dio** (no interceptor recursion) with the same `HmacSigningInterceptor` — user-auth must be signed in **enforce**.
- On JWT 401 retry, `_retryHeaders` **drops** the five HMAC headers so the interceptor mints a **new nonce** (reuse → `nonce_replayed`).

HMAC 401 is also a generic 401. Guest OTP has no refresh token, so `AuthInterceptor` does not try refresh (fail fast). Logged-in HMAC failures may trigger an unnecessary refresh; that does not fix a bad signature.

## Debug (`name: HmacSigning`)

Filter the console / `dart:developer` by **`HmacSigning`**. `kDebugMode` only. Never includes the secret.

| Log | Meaning |
|-----|---------|
| `Initialized keyId=ios … active=present(len=64)` | Store ready |
| `Signed userAuth POST /acs-auth/api/v1/auth/otp/generate` + canonical | Headers were attached — this is the healthy OTP path |
| `Skip unsigned … (secret missing — server returns missing_headers …)` | Interceptor did not sign. Chucker will lack `x-signature`. Server **enforce** → `401 missing_headers` |
| `401 … hmacHeaders=missing` | Confirms the five headers never left the device |
| `401 … hmacHeaders=present` | Headers were sent; server rejected signature/nonce/clock/key |

Chucker **must** show `x-key-id`, `x-timestamp`, `x-nonce`, `x-content-digest`, `x-signature` on signed calls.

`EncryptionService Decrypted Text Length: 0` on login is empty prefs (no token yet). Unrelated to HMAC.

## If the server returns 401

Do not branch UI on the message text. Use it in debug:

| `error.message` / server reason | What to check in this app |
|---------------------------------|---------------------------|
| `missing_headers` | Skip log, or Chucker has no HMAC headers. Hot-restart. Confirm `Signed …` log |
| `unknown_key_id` | `x-key-id` not `android`/`ios` |
| `timestamp_out_of_window` | Device clock ±5 minutes; request delayed in a debugger |
| `bad_signature` | Wrong secret, wrong wire path, or JSON not frozen |
| `nonce_replayed` | Same UUID on retry (should be stripped + re-signed) |
| `content_digest_mismatch` | Digest not over the bytes actually sent |
| `multipart_digest_mismatch` | Field sort / file grouping |

Worked OTP path to compare with the log:

```
POST http://<host>/acs-auth/api/v1/auth/otp/generate
canonical path: /acs-auth/api/v1/auth/otp/generate
x-key-id: ios   (or android)
```

## Files

| Path | Role |
|------|------|
| `lib/core/network/hmac/hmac_signer.dart` | SHA-256, HMAC, canonical string, path+query, multipart recipe |
| `lib/core/network/hmac/hmac_secret_store.dart` | android/ios secrets, Keychain/Keystore, request-time fallback |
| `lib/core/network/hmac/hmac_signing_interceptor.dart` | Dio `onRequest` / 401 debug |
| `lib/core/network/hmac/hmac_headers.dart` | Header names + `hmacBackendFor` |
| `lib/core/network/hmac/hmac_uuid.dart` | UUID v4 per attempt |
| `lib/core/network/hmac/hmac_dev_log.dart` | `developer.log(..., name: HmacSigning)` |
| `lib/core/network/api_service.dart` | Registers HMAC after auth, before logger/Chucker |
| `lib/core/network/auth_interceptor.dart` | Refresh Dio signed; retries drop old HMAC headers |
| `lib/core/di/dependency_injection.dart` | `HmacSecretStore.initialize()` before `ApiService` |
| `test/core/network/hmac_signer_test.dart` | Empty digest, canonical shape, RFC HMAC vector, path encoding |
| `hmac.keys.json.example` | Override template (real `hmac.keys.json` is gitignored) |

## Last updated

Documents the live app: platform secrets, interceptor pipeline, OTP `missing_headers` debug, request-time secret fallback, refresh + retry.
