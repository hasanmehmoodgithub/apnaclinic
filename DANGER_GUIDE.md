# Danger Guide (GitLab CI)

This project uses **Danger JS** to run merge-request quality checks before merge.

Danger runs in GitLab CI and comments/fails the MR when rules are violated.

---

## What is configured

The setup is already added in this repo:

- `dangerfile.js` - Danger rules and checks.
- `.gitlab-ci.yml` - CI job that runs Danger on merge request pipelines.
- `package.json` - includes `danger` dependency and `danger:ci` script.

Current enforced checks:

1. **No `setState(` in added Dart lines**
   - Fails MR if `setState(` appears in newly added lines.
   - Enforces Cubit/Bloc state updates.

2. **Analyzer/lints must pass**
   - Runs:
     - `dart analyze --fatal-infos --fatal-warnings`
   - Fails MR on analyzer issues.

3. **Widget file max line limit**
   - For changed files under `presentation/widgets/`
   - Fails if file exceeds **300 lines**.

---

## Required GitLab variable

Danger needs API access to read/write MR checks/comments.

Create these CI/CD variables in GitLab project settings:

- **Key:** `DANGER_GITLAB_API_TOKEN`
- **Value:** GitLab access token
- **Scope needed:** `api`
- Recommended: mark as **Masked** and **Protected**

For self-hosted GitLab with custom TLS chain, add one of:

- **Preferred:** `GITLAB_CA_FILE` as a **File** variable containing your CA PEM chain
- **Alternative:** `GITLAB_CA_PEM` as a text variable containing full PEM chain

Path:

- GitLab -> **Project Settings** -> **CI/CD** -> **Variables**

---

## CI job behavior

Danger job is defined in `.gitlab-ci.yml`:

- Runs only for merge request pipelines:
  - `CI_PIPELINE_SOURCE == "merge_request_event"`
- Installs Node/npm dependencies via `npm ci`
- Executes:
  - `npx danger ci --dangerfile dangerfile.js`

If any Danger rule fails, the pipeline fails and merge is blocked (depending on branch protections/rules).

---

## Local test commands

Install dependencies:

```bash
npm ci
```

Check dangerfile syntax:

```bash
node --check dangerfile.js
```

Run analyzer manually:

```bash
dart analyze --fatal-infos --fatal-warnings
```

---

## How to update rules

Edit:

- `dangerfile.js`

Typical additions:

- block `Navigator.of(` usage in changed lines
- block hardcoded `Color(0x...)` in changed lines
- block `Image.network(` and enforce `CachedNetworkImage`
- require ARB pair updates (`app_en.arb` + `app_ur.arb`)

Keep rules focused on **changed lines/files** to avoid failing old untouched code.

---

## Troubleshooting

### 1) Danger job fails with auth errors

Check:

- `DANGER_GITLAB_API_TOKEN` exists in CI variables
- token has `api` scope
- token is valid (not expired/revoked)

### 2) `npm ci` fails

Check:

- `package-lock.json` is committed
- Node/npm available in CI image

### 3) Analyzer fails in CI but passes locally

Check:

- Flutter/Dart versions in CI vs local environment
- dependency state (`pubspec.lock`) and generated files consistency

---

## Summary

Danger now gives MR-level guardrails for:

- no `setState(` in added code
- strict analyzer/lint compliance
- widget file size control (max 300 lines)

This helps keep PRs aligned with your Flutter architecture and clean-code rules before merge.
