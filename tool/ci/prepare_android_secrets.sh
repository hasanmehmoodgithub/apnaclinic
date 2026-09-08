#!/usr/bin/env bash
# Writes HMAC + upload keystore into the workspace from GitLab CI variables.
set -euo pipefail

if [ -n "${HMAC_KEYS_JSON:-}" ]; then
  if [ -f "$HMAC_KEYS_JSON" ]; then
    cp "$HMAC_KEYS_JSON" hmac.keys.json
  else
    printf '%s\n' "$HMAC_KEYS_JSON" > hmac.keys.json
  fi
  echo "Wrote hmac.keys.json"
else
  echo "HMAC_KEYS_JSON not set; using compile-time HMAC fallbacks"
fi

dest="android/app/econceptions.jks"
if [ -n "${ANDROID_KEYSTORE_FILE:-}" ] && [ -f "$ANDROID_KEYSTORE_FILE" ]; then
  cp "$ANDROID_KEYSTORE_FILE" "$dest"
  echo "Wrote $dest from ANDROID_KEYSTORE_FILE"
elif [ -n "${ANDROID_KEYSTORE_BASE64:-}" ]; then
  if [ -f "$ANDROID_KEYSTORE_BASE64" ]; then
    tr -d '\n\r ' < "$ANDROID_KEYSTORE_BASE64" | base64 -d > "$dest"
  else
    printf '%s' "$ANDROID_KEYSTORE_BASE64" | tr -d '\n\r ' | base64 -d > "$dest"
  fi
  echo "Wrote $dest from ANDROID_KEYSTORE_BASE64"
else
  echo "No CI keystore; Gradle may fall back to debug signing"
fi
