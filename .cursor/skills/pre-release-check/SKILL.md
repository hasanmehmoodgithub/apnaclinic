---
name: pre-release-check
description: >-
  Reviews Flutter/Dart code for release readiness against ApnaClinic clean
  architecture, security, localization, routing, and FEATURE.md conventions.
  Use when the user asks for a pre-release check, release review, ship checklist,
  or to verify code before release/production.
disable-model-invocation: true
---

# Pre-release code check

Run a release-readiness review on the current changes (or a named scope). Do not rewrite code unless the user asks to fix findings.

## Scope

1. Prefer `git status` + `git diff` (staged/unstaged) and recent commits on the branch.
2. If the user names files/features, limit review to that scope.
3. If nothing is changed, ask what to review (branch vs `main`, feature folder, or PR).

## How to review

Inspect real code. Flag only issues you can point to with a file path. Severity:

- **Blocker** — must fix before release
- **Should fix** — high risk / clear convention break
- **Nice to have** — polish, optional cleanup

## Checklist

### Correctness & regressions
- [ ] Happy path and failure/empty/loading paths are handled in Cubit/UI
- [ ] Null/edge cases and pagination/refresh (if any) are safe
- [ ] No dead navigation, broken routes, or unused broken imports
- [ ] Generated code (`*.freezed.dart`, `*.g.dart`) matches sources if models/states changed

### Architecture (ApnaClinic)
- [ ] Business logic stays in Cubit / use-cases / domain — not widgets
- [ ] Use-cases that need input use a dedicated `Params` class through repo + data source
- [ ] Feature layout matches clean architecture under `lib/features/<name>/`
- [ ] DI updated in feature `*_injection.dart` when new deps were added

### Navigation & UI conventions
- [ ] Routing uses `go_router` only (`context.pop` / `go` / `pushNamed`) — no `Navigator`
- [ ] User-facing strings use `AppLocalizations.of(context)!` (no hardcoded copy)
- [ ] Network images use `CachedNetworkImage` with placeholder/error
- [ ] Assets via `Assets.*` from `generated/assets.dart` — no hardcoded asset paths
- [ ] Colors/styles from app constants/theme — no hardcoded colors or one-off style sprawl
- [ ] Screens stay thin; feature widgets live in `presentation/widgets/`
- [ ] Scoped rebuilds (`BlocSelector` / `BlocBuilder(buildWhen:)`) where lists/forms warrant it

### Docs
- [ ] Material feature changes under `lib/features/<name>/` have `FEATURE.md` created/updated (purpose, routes, APIs, state, DI, mocks)
- [ ] Core/shared changes update the existing area doc when one exists

### Security & release hygiene
- [ ] No secrets, tokens, API keys, or credentials in source or commits
- [ ] Auth/session and refresh-token paths not weakened
- [ ] Debug/mock flags (`MockConfig`, logging of PII) are safe for production
- [ ] Deep links / permissions / platform config consistent with the change

### Quality bar
- [ ] No obvious performance footguns (rebuild storms, unbounded lists without keys)
- [ ] Error surfaces are user-safe (no raw exception dumps in UI)
- [ ] Tests exist or are clearly missing for critical new logic (note gaps; don’t invent coverage claims)

## Output format

```markdown
# Pre-release check

**Verdict:** Ready to release | Ready with follow-ups | Not ready
**Scope:** <branch / files / feature>

## Blockers
- `path`: issue — why it blocks release

## Should fix
- `path`: issue — risk

## Nice to have
- `path`: suggestion

## Checklist summary
| Area | Status |
|------|--------|
| Correctness | Pass / Fail / N/A |
| Architecture | Pass / Fail / N/A |
| Nav & UI | Pass / Fail / N/A |
| Docs | Pass / Fail / N/A |
| Security | Pass / Fail / N/A |
| Quality | Pass / Fail / N/A |

## Suggested next steps
1. …
```

If there are no blockers, say so explicitly. Keep the report concise; group duplicates.
