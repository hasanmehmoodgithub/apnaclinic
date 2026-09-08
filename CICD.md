# CI/CD (GitLab)

Automated verify + Android build for Apna Clinic. Pipeline config is `.gitlab-ci.yml`. Merge-request quality comments still use Danger (`DANGER_GUIDE.md`).

## Flow

```text
push / merge request
        │
        ▼
   verify stage
   ├── analyze   (MR only — machine report for Danger)
   ├── test      (flutter test)
   └── danger    (MR only — comments + fail rules)
        │
        ▼
   build stage
   ├── staging APK     (development / staging; manual on MRs)
   └── production AAB  (production / main / tags)
```

iOS IPA is not in CI yet (needs a macOS runner). Build locally with the commands in `lib/core/flavor/guide/COMMANDS.md`.

## When jobs run

| Job | Merge request | `development` / `staging` | `production` / `main` / tag |
|---|---|---|---|
| `analyze` | yes | no | no |
| `test` | yes | yes | yes |
| `danger` | yes | no | no |
| `build_android_staging` | manual | auto | manual |
| `build_android_production` | — | manual | auto |

Only one pipeline runs per change: MR pipelines for feature branches, branch pipelines for `development` / `staging` / `production` / `main`.

## Build flags

| Flavor | Artifact | `APP_FLAVOR` | Chucker |
|---|---|---|---|
| Staging | APK | `staging` | on |
| Production | AAB | `production` | off |

`SECURITY_CHECKS` stays at the app default (`true`). Version name comes from `pubspec.yaml`; version code is `$CI_PIPELINE_IID`.

HMAC is passed with `--dart-define-from-file=hmac.keys.json` when `HMAC_KEYS_JSON` is set. Otherwise the compile-time fallbacks in `HmacSecretStore` are used.

## GitLab CI/CD variables

**Settings → CI/CD → Variables.** Mask secrets. Protect production signing variables if only protected branches should see them.

| Key | Type | Required | Purpose |
|---|---|---|---|
| `DANGER_GITLAB_API_TOKEN` | Variable | MR pipelines | Danger GitLab API (`api` scope) |
| `GITLAB_CA_FILE` or `GITLAB_CA_PEM` | File / Variable | Self-hosted TLS | Custom CA for Danger |
| `HMAC_KEYS_JSON` | File or Variable | Recommended | Contents of `hmac.keys.json` (see `hmac.keys.json.example`) |
| `ANDROID_KEYSTORE_FILE` | File | Production (or use base64) | Raw `econceptions.jks` |
| `ANDROID_KEYSTORE_BASE64` | Variable | Production (or use file) | Base64 of the same `.jks` |
| `UPLOAD_STORE_PASSWORD` | Variable | Production | Keystore password |
| `UPLOAD_KEY_PASSWORD` | Variable | Production | Key password |
| `UPLOAD_KEY_ALIAS` | Variable | Production | Key alias (matches `android/key.properties`) |

Staging APKs still build if the keystore is missing (Gradle falls back to debug signing). Production **fails** without the upload keystore + passwords.

Encode a local keystore (do not commit it):

```bash
base64 -i android/app/econceptions.jks | pbcopy
```

On Linux: `base64 -w0 android/app/econceptions.jks`.

## Local equivalents

```bash
flutter pub get
flutter analyze
flutter test

bash tool/ci/build_android.sh staging apk
bash tool/ci/build_android.sh production appbundle
```

Production local builds still need `android/key.properties` (gitignored) or the `UPLOAD_*` env vars.

## After a green pipeline

1. Open the pipeline → `build_android_staging` / `build_android_production`
2. Download the APK or AAB from **Job artifacts**
3. Share the staging APK with QA, or upload the production AAB to Play Console internal testing

Firebase App Distribution and TestFlight are not wired yet; artifacts are the hand-off.

## Troubleshooting

- **Danger auth** — token missing/expired; see `DANGER_GUIDE.md`
- **Analyzer in Danger, not in `test`** — `analyze` uses `--machine` and does not fail the job; Danger fails the MR on errors. `test` only runs `flutter test`
- **Unsigned staging APK** — set keystore variables
- **Production job exits on keystore** — set `ANDROID_KEYSTORE_FILE` or `ANDROID_KEYSTORE_BASE64` plus `UPLOAD_*`
- **Flutter version drift** — CI image is `ghcr.io/cirruslabs/flutter:stable`; pin a version in `.gitlab-ci.yml` if local and CI disagree
