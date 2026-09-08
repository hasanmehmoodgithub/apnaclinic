#!/usr/bin/env bash
# Usage: tool/ci/build_android.sh <staging|production> [apk|appbundle]
set -euo pipefail

FLAVOR="${1:?usage: build_android.sh <staging|production> [apk|appbundle]}"
KIND="${2:-apk}"
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"

bash tool/ci/prepare_android_secrets.sh

defines=(--dart-define="APP_FLAVOR=$FLAVOR")
if [ -f hmac.keys.json ]; then
  defines+=(--dart-define-from-file=hmac.keys.json)
fi

if [ "$FLAVOR" = "production" ]; then
  defines+=(--dart-define=CHUCKER_ACTIVE=false)
  if [ ! -f android/app/econceptions.jks ]; then
    echo "Production requires ANDROID_KEYSTORE_FILE or ANDROID_KEYSTORE_BASE64" >&2
    exit 1
  fi
  if [ -z "${UPLOAD_STORE_PASSWORD:-}" ] || [ -z "${UPLOAD_KEY_PASSWORD:-}" ] || [ -z "${UPLOAD_KEY_ALIAS:-}" ]; then
    echo "Production requires UPLOAD_STORE_PASSWORD, UPLOAD_KEY_PASSWORD, UPLOAD_KEY_ALIAS" >&2
    exit 1
  fi
else
  defines+=(--dart-define=CHUCKER_ACTIVE=true)
fi

build_name="${APP_BUILD_NAME:-$(awk '/^version:/ { print $2; exit }' pubspec.yaml | cut -d+ -f1)}"
build_number="${CI_PIPELINE_IID:-1}"

if [ "$KIND" = "appbundle" ]; then
  flutter build appbundle --release \
    --build-name="$build_name" \
    --build-number="$build_number" \
    "${defines[@]}"
  echo "AAB: build/app/outputs/bundle/release/app-release.aab"
else
  flutter build apk --release \
    --build-name="$build_name" \
    --build-number="$build_number" \
    "${defines[@]}"
  src="build/app/outputs/flutter-apk/app-release.apk"
  dest="build/app/outputs/flutter-apk/apnaclinic-${FLAVOR}-${CI_COMMIT_SHORT_SHA:-local}.apk"
  mv "$src" "$dest"
  echo "APK: $dest"
fi
