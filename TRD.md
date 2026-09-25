# TRD — base-makefile (Technical Reference Document)

> Docs-only. Claims tagged **FACT / INFERENCE / UNKNOWN / PROPOSAL**.

## 1. Runtime & tooling (FACT)

- GNU Make with a strict shell: `SHELL := bash`, `.SHELLFLAGS := -eu -o pipefail -c`,
  `MAKEFLAGS += --warn-undefined-variables --no-builtin-rules`
  (`lib/common/00_variables.Makefile`).
- Host commands are overridable variables: `PYTHON ?= python3`,
  `DOCKER_COMPOSE ?= docker compose`, `PRE_COMMIT ?= pre-commit`.
- CI Python pin: `3.14` (`.github/workflows/ci.yml`).

## 2. Include contract (FACT)

Order is load-bearing and enforced by convention:
`common/00_variables` → `common/01_functions` → category bricks →
`common/02_help` (last, so `MAKEFILE_LIST` is complete when help/`.PHONY` are
generated). Filenames of includable bricks are `<name>.Makefile` (never
`Makefile.<name>`; the flat `examples/Makefile.*` keep the old name because the
auto-include pattern references them — `HANDOFF.md`).

## 3. Shared macros (FACT — `lib/common/01_functions.Makefile`)

| Macro | Signature | Effect |
| --- | --- | --- |
| `log-info/log-error/log-ok` | `$(call log-info,msg)` | colored `printf` recipe line (TTY-gated colors) |
| `check_defined` | `$(call check_defined,var,hint)` | `$(error …)` if variable empty |
| `confirm_destructive` | `$(call confirm_destructive,desc)` | interactive y/N; skipped with `CONFIRM=yes` |
| `run_python` | `$(call run_python,args)` | `$(RUN) $(PYTHON) args` |
| `run_in_service` | `$(call run_in_service,svc,cmd)` | `docker compose exec -T svc cmd` |

## 4. Help generation (FACT — `lib/common/02_help.Makefile`)

- `.DEFAULT_GOAL := help`.
- Documented target syntax: `target: prereqs ## Description => [var={what}]`.
  Undocumented targets are hidden.
- `help` greps `## ` lines across `MAKEFILE_LIST`, groups by file basename
  (strips `NN_` prefix and `.Makefile`).
- Every documented target is auto-declared `.PHONY` via a single `$(shell grep …)`
  expansion — this is why bricks declare only their own `.PHONY` line once.
- `help-%` prints a target's definition; `check-defined-%` is a usable prerequisite.

## 5. Required-input / destructive guards (FACT)

- `check-defined-<var>` prerequisite fails early with a clear message instead of
  running a broken recipe (README "Required variables").
- Destructive recipes call `confirm_destructive`; `CONFIRM=yes` bypasses the
  prompt for CI.

## 6. CI / CD (FACT — `.github/workflows/`)

`ci.yml` on PR/push to `main`/`develop`, three jobs:
1. **pre-commit** — `pre-commit run --all-files` (Python 3.14, `SKIP=no-commit-to-branch`).
2. **validate-makefile** — runs `./scripts/smoke-test.sh` (the profile gate).
3. **version** — GitVersion compute.

`cd.yml` on push to `main` / `v*` tags: computes version (branch push), tags if
absent, creates a GitHub release with generated notes. Idempotent; no force-push
(released tags immutable). Fix documented inline: token-pushed tags do not
retrigger workflows, so the release is created in the same run.

## 7. Smoke test (FACT — `scripts/smoke-test.sh`)

Dry-runs `help` for every `profiles/*.Makefile` and the three flat examples;
fails on non-zero exit **or** any stderr output (catches `$(shell …)` errors
that make swallows with exit 0). Verified locally 2026-09-25: **12/12 OK**
(9 profiles + 3 examples).

## 8. Installer (FACT — `scripts/install.sh`)

`set -euo pipefail`. Flags `-p/--profile`, `-d/--dest` (default `.`), `--force`,
`--list`, `-h/--help`. Copies `lib/` + profile→`Makefile`; refuses to clobber an
existing `Makefile`/`lib/` unless `--force`; validates profile exists and dest
is a directory.

## 9. Known technical debt / gaps

- **UNKNOWN/CONTRADICTION**: `install.sh --help` header and its `--profile` flag
  doc enumerate 7 profiles and omit the newer `fastapi` and `infra` (9 exist on
  disk). `--list` is data-driven and correct; only the static help text lags.
  See CONTRADICTIONS in `REVIEW.md`.
- **INFERENCE** (`HANDOFF.md`): `makefile-check` emits non-blocking warnings
  (unmerged `.PHONY` across includes; `fullstack` tier flags recommended
  `e2e`/`quality-gate-*` absent). Errors = 0.
- **UNKNOWN**: whether the standard's `BASE_MAKEFILE_REF` (`v0.1.0-29`) was moved
  to the brick library since `HANDOFF.md` was written.
