# REQUIREMENTS — base-makefile

> Docs-only. Technical requirements reverse-engineered from the repository.
> A requirement is **IMPLEMENTED** only where verifiable in-repo (file/behaviour).

## Technical requirements

| ID | Requirement | Status | Evidence |
| --- | --- | --- | --- |
| REQ-TECH-001 | Provide a composable Make library: shared core + single-purpose bricks + profiles. | IMPLEMENTED | `lib/common/`, `lib/<category>/`, `profiles/` |
| REQ-TECH-002 | A profile is a drop-in root `Makefile` that includes core + selected bricks. | IMPLEMENTED | `profiles/*.Makefile`, include blocks |
| REQ-TECH-003 | One-command install into a target project (copy `lib/` + profile→`Makefile`). | IMPLEMENTED | `scripts/install.sh` |
| REQ-TECH-004 | Auto-generated help grouped by category from `## ` comments; undocumented targets hidden. | IMPLEMENTED | `lib/common/02_help.Makefile` |
| REQ-TECH-005 | Everything overridable on the command line via `?=` variables. | IMPLEMENTED | `lib/common/00_variables.Makefile` |
| REQ-TECH-006 | Same targets run on host or in a container via `$(RUN)`; UID/GID preserved in container mode. | IMPLEMENTED | `lib/docker/runner.Makefile`, bricks |
| REQ-TECH-007 | Required inputs fail fast with a clear message (`check-defined-%`). | IMPLEMENTED | `lib/common/02_help.Makefile`, `01_functions` |
| REQ-TECH-008 | Destructive actions are gated (`confirm_destructive`, `CONFIRM=yes` bypass). | IMPLEMENTED | `lib/common/01_functions.Makefile` |
| REQ-TECH-009 | One `.PHONY` per brick; help brick auto-declares documented targets `.PHONY`. | IMPLEMENTED | `02_help.Makefile`, bricks |
| REQ-TECH-010 | Canonical target names (`lint`/`format`/`test`/`typecheck`/`pre-commit`…) per chrysa standard. | IMPLEMENTED (naming present); enforcement is external (`makefile-check`) | README, HANDOFF |
| REQ-TECH-011 | CI validates every profile + example via smoke-test; fails on non-zero exit or stderr. | IMPLEMENTED | `.github/workflows/ci.yml`, `scripts/smoke-test.sh` |
| REQ-TECH-012 | Automated versioning + release (GitVersion, tag, GH release). | IMPLEMENTED | `GitVersion.yml`, `.github/workflows/cd.yml` |
| REQ-TECH-013 | Strict shell (`bash -eu -o pipefail`, warn-undefined-variables, no-builtin-rules). | IMPLEMENTED | `lib/common/00_variables.Makefile` |
| REQ-TECH-014 | English-only across code/comments/docs/config. | IMPLEMENTED (repo body); HANDOFF.md itself is French (author handoff note) | CLAUDE.md, files |
| REQ-TECH-015 | pre-commit runs on the host, not via `$(RUN)`. | IMPLEMENTED | `lib/quality/precommit.Makefile`, README |
| REQ-TECH-016 | Flat single-file templates retained for non-`lib/` projects. | IMPLEMENTED | `examples/Makefile.*`, `examples/makefiles/` |

## Verification (2026-09-25)

`bash scripts/smoke-test.sh` → **12/12 OK** (9 profiles + 3 examples). Confirms
REQ-TECH-001/002/004/011.
