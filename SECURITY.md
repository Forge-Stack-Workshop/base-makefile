# SECURITY — base-makefile

> Docs-only review by a documentation agent. Findings are flagged for the owner;
> **no code was changed**. Severity: informational unless marked.

## Secret scan (FACT)

- Repository-wide grep for hardcoded credentials/keys/tokens across
  `*.Makefile`, `*.sh`, `*.yml`, `*.json`: **no hardcoded secrets found**.
- The only token references are `${{ secrets.GITHUB_TOKEN }}` in `cd.yml`
  (correct GitHub Actions usage) and `check_defined`/scanner metadata.
- `.claude/secret-scanner-allowlist.json` contains an example placeholder value
  `sk-test-placeholder` — a documented allowlist sample, not a live secret.

## Security posture (FACT / positive)

- Local defensive `.claude/hooks/secret-scanner.cjs` runs as a hook (settings.json).
- Strict shell everywhere (`bash -eu -o pipefail`) reduces silent failures.
- Destructive Make targets gated by `confirm_destructive` (y/N, `CONFIRM=yes` to
  bypass in CI).
- CD is idempotent and never force-pushes released tags.
- `install.sh` guards against clobbering existing `Makefile`/`lib/` without
  `--force`, and uses `set -euo pipefail`.

## Findings for owner (low severity — NOT fixed here)

1. **LOW — tracked file contradicts `.gitignore`.** `.gitignore` lists
   `.claude/settings.local.json`, but that file is committed/tracked. It holds a
   broad Bash/tool permission allowlist (no secrets). Owner may want to
   `git rm --cached` it to match the ignore rule, or drop the ignore line.
   *(Docs-only mission — not actioned.)*
2. **INFO — container mode passes host UID/GID** (`runner.Makefile`); expected
   and desirable (keeps mount ownership correct). No action.
3. **INFO — `install.sh --force`** overwrites a project's `Makefile`/`lib/`;
   intended, gated behind an explicit flag.

## No HIGH/CRITICAL findings.

Nothing in this repo introduces auth, user input, DB queries, deserialization,
upload, or network surface beyond CI credentials handled by GitHub Actions.
