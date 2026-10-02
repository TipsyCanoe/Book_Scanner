#!/usr/bin/env bash
#
# bootstrap.sh — apply the repository settings that a GitHub template cannot copy.
#
# Run this ONCE per repository generated from REPO_TEMPLATE. It is idempotent:
# re-running it is safe and is the correct way to repair drift reported by
# .github/workflows/repo-audit.yml.
#
#   Usage:  ./scripts/bootstrap.sh [owner/repo]
#
# With no argument it uses the repository of the current directory.
#
# The desired state lives in .github/expected-settings.json — this script only
# applies it. Change settings there, then re-run this script.
#
# Requires: gh (authenticated, admin on the repo) and jq.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
EXPECTED="$REPO_ROOT/.github/expected-settings.json"

applied=()
skipped=()

note()  { printf '  %s\n' "$*"; }
ok()    { applied+=("$*"); printf '  \033[32m✓\033[0m %s\n' "$*"; }
warn()  { skipped+=("$*"); printf '  \033[33m!\033[0m %s\n' "$*" >&2; }
die()   { printf '\033[31merror:\033[0m %s\n' "$*" >&2; exit 1; }

# ---------------------------------------------------------------- preflight --

command -v gh >/dev/null 2>&1 || die "gh (GitHub CLI) is required: https://cli.github.com"
command -v jq >/dev/null 2>&1 || die "jq is required: https://jqlang.github.io/jq/"
gh auth status >/dev/null 2>&1 || die "gh is not authenticated. Run: gh auth login"
[ -f "$EXPECTED" ] || die "missing $EXPECTED"

REPO="${1:-$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null || true)}"
[ -n "$REPO" ] || die "could not determine the repository. Pass it explicitly: ./scripts/bootstrap.sh owner/repo"

printf '\nBootstrapping \033[1m%s\033[0m from .github/expected-settings.json\n\n' "$REPO"

gh api "repos/$REPO" >/dev/null 2>&1 \
  || die "cannot read repos/$REPO — check the name and that your token has access."

# ------------------------------------------------------------ repo settings --

printf 'Repository settings\n'

repo_patch="$(jq -c '.repository' "$EXPECTED")"
if gh api -X PATCH "repos/$REPO" --input - <<<"$repo_patch" >/dev/null; then
  jq -r '.repository | to_entries[] | "\(.key) = \(.value)"' "$EXPECTED" | while read -r line; do
    printf '  \033[32m✓\033[0m %s\n' "$line"
  done
  applied+=("repository settings (merge/branch/wiki/projects)")
else
  warn "could not update repository settings (admin permission required)"
fi

# ---------------------------------------------------------------- security --

printf '\nSecurity features\n'

want_scanning="$(jq -r '.security.secret_scanning' "$EXPECTED")"
want_push_protection="$(jq -r '.security.secret_scanning_push_protection' "$EXPECTED")"

sec_patch="$(jq -nc \
  --arg s "$want_scanning" \
  --arg p "$want_push_protection" \
  '{security_and_analysis: {
      secret_scanning: {status: $s},
      secret_scanning_push_protection: {status: $p}
    }}')"

if gh api -X PATCH "repos/$REPO" --input - <<<"$sec_patch" >/dev/null 2>&1; then
  ok "secret scanning = $want_scanning"
  ok "secret scanning push protection = $want_push_protection"
else
  warn "secret scanning could not be enabled (private repos need GitHub Advanced Security)"
fi

if [ "$(jq -r '.security.vulnerability_alerts' "$EXPECTED")" = "true" ]; then
  if gh api -X PUT "repos/$REPO/vulnerability-alerts" >/dev/null 2>&1; then
    ok "Dependabot alerts enabled"
  else
    warn "could not enable Dependabot alerts"
  fi
fi

if [ "$(jq -r '.security.automated_security_fixes' "$EXPECTED")" = "true" ]; then
  if gh api -X PUT "repos/$REPO/automated-security-fixes" >/dev/null 2>&1; then
    ok "Dependabot security updates enabled"
  else
    warn "could not enable Dependabot security updates"
  fi
fi

# ---------------------------------------------------------------- ruleset --

printf '\nBranch protection ruleset\n'

RULESET_NAME="$(jq -r '.ruleset.name' "$EXPECTED")"

ruleset_payload="$(jq -c '
  .ruleset as $r
  | {
      name: $r.name,
      target: $r.target,
      enforcement: $r.enforcement,
      bypass_actors: [],
      conditions: { ref_name: { include: $r.include_refs, exclude: [] } },
      rules: (
        [
          # Block force-pushes and branch deletion.
          { type: "non_fast_forward" },
          { type: "deletion" },

          # Require a pull request. required_approving_review_count is 0 by
          # default so a solo maintainer can merge their own PR; raise it in
          # expected-settings.json once there is a second reviewer.
          { type: "pull_request",
            parameters: {
              required_approving_review_count: $r.required_approving_review_count,
              dismiss_stale_reviews_on_push: false,
              require_code_owner_review: false,
              require_last_push_approval: false,
              required_review_thread_resolution: false
            }
          },

          # Require CI. "ci" is the aggregate gate job in ci.yml, not the
          # workflow name — required checks match check-run names.
          { type: "required_status_checks",
            parameters: {
              strict_required_status_checks_policy: $r.strict_required_status_checks_policy,
              required_status_checks: [ $r.required_status_checks[] | { context: . } ]
            }
          }
        ]
        # Opt-in: set required_signatures to true in expected-settings.json.
        + (if $r.required_signatures then [ { type: "required_signatures" } ] else [] end)
      )
    }' "$EXPECTED")"

existing_id="$(gh api "repos/$REPO/rulesets" --jq \
  ".[] | select(.name == \"$RULESET_NAME\") | .id" 2>/dev/null | head -n1 || true)"

if [ -n "$existing_id" ]; then
  if gh api -X PUT "repos/$REPO/rulesets/$existing_id" --input - <<<"$ruleset_payload" >/dev/null; then
    ok "ruleset '$RULESET_NAME' updated (id $existing_id)"
  else
    warn "could not update ruleset '$RULESET_NAME'"
  fi
else
  if gh api -X POST "repos/$REPO/rulesets" --input - <<<"$ruleset_payload" >/dev/null; then
    ok "ruleset '$RULESET_NAME' created"
  else
    warn "could not create ruleset '$RULESET_NAME'"
  fi
fi

note "requires PRs into the default branch"
note "requires status check(s): $(jq -r '.ruleset.required_status_checks | join(", ")' "$EXPECTED")"
note "blocks force-push and branch deletion"

if [ "$(jq -r '.ruleset.strict_required_status_checks_policy' "$EXPECTED")" = "true" ]; then
  note "requires branches to be up to date before merging"
else
  note "(off) require branches up to date before merging — see expected-settings.json"
fi

if [ "$(jq -r '.ruleset.required_signatures' "$EXPECTED")" = "true" ]; then
  note "requires signed commits"
else
  note "(off) require signed commits — see expected-settings.json"
fi

# ---------------------------------------------------------------- summary --

printf '\n\033[1mSummary for %s\033[0m\n' "$REPO"
if [ "${#applied[@]}" -gt 0 ]; then
  for line in "${applied[@]}"; do printf '  applied  %s\n' "$line"; done
fi
if [ "${#skipped[@]}" -gt 0 ]; then
  for line in "${skipped[@]}"; do printf '  SKIPPED  %s\n' "$line"; done
  printf '\n%d setting(s) could not be applied — see the warnings above.\n' "${#skipped[@]}"
fi

printf '\nNext: fill the {{PLACEHOLDER}} values in README.md and SECURITY.md,\n'
printf 'and define your smoke test (npm "smoke" script or scripts/smoke.sh).\n\n'
