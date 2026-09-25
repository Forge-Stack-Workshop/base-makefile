# TESTING — base-makefile

> Docs-only. **FACT / INFERENCE / UNKNOWN**.

## Test surface (FACT)

This repo ships Make bricks, not application code; its "tests" validate that
every profile and example composes and parses cleanly.

- **`scripts/smoke-test.sh`** (FACT): for each `profiles/*.Makefile` and each
  flat example, runs `make … --dry-run help` and asserts **exit 0 AND empty
  stderr**. Rationale (in-file): a shell error inside `$(shell …)` surfaces on
  stderr even when make exits 0, so both are checked.
  - Profiles are run from repo root (their `include lib/...` is CWD-relative).
  - The `with-sub-folder` example scans its own dir, so examples run from
    `examples/` via `make -C`.
- **Local result (2026-09-25)**: 12/12 OK (9 profiles + 3 examples).

## CI (FACT — `.github/workflows/ci.yml`)

| Job | What it runs |
| --- | --- |
| pre-commit | `pre-commit run --all-files` (Python 3.14, `SKIP=no-commit-to-branch`) |
| validate-makefile | `./scripts/smoke-test.sh` |
| version | GitVersion compute |

CONTRIBUTING requires running `bash scripts/smoke-test.sh` before opening a PR
and forbids weakening the `validate-makefile` gate.

## Not covered / gaps

- **INFERENCE**: no runtime/functional test of individual brick targets against a
  real project (e.g. actually running `make test` in a sample repo) — only
  dry-run `help` parsing is validated.
- **UNKNOWN**: whether `makefile-check` (the standard's linter) runs in this
  repo's CI or only in `shared-standards`. `HANDOFF.md` reports running it
  manually (errors 0, non-blocking warnings).
- `scripts/install.sh` has no automated test in-repo (INFERENCE).
