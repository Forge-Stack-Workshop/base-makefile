# CONSTRAINTS — base-makefile

> Docs-only. Each constraint tagged **FACT / INFERENCE / UNKNOWN**.

## Authoring rules (FACT — `CONTRIBUTING.md`)

- **One brick, one concern.** `lib/<category>/<name>.Makefile`; a brick defines
  targets + brick-local vars only and never `include`s another brick.
- **One `.PHONY` per file**, declared once at the top.
- **Route tools through `$(RUN)`** (ruff, mypy, pytest, pip, JS pkg manager…) —
  except pre-commit.
- **Document every target** with `## Description => [var={what}]`; undocumented
  targets are hidden.
- **Static help text**: no `$(VAR)` inside a `##` comment (shown literally).
- **Overridable, not hardcoded**: expose choices as `?=`; never bake a project name.
- **Guard required inputs** with `check-defined-<var>`; **guard destructive
  actions** with `confirm_destructive`.
- **English only** in code, comments, docs.

## Structural constraints (FACT)

- Include order is load-bearing: `00_variables → 01_functions → bricks → 02_help`.
- Includable brick filenames are `<name>.Makefile`; the flat `examples/Makefile.*`
  keep the `Makefile.<name>` form because an auto-include pattern references them
  (`HANDOFF.md`).
- Strict shell flags apply to every recipe (`00_variables`).
- CI gate `validate-makefile` must stay green: smoke-test fails on any non-zero
  exit **or** stderr; CONTRIBUTING states "Do not remove or weaken this gate."

## Ecosystem / process constraints (FACT / INFERENCE)

- Conforms to chrysa `shared-standards/docs/MAKEFILE-STANDARD.md` (canonical
  names + tiers, `makefile-check`) — FACT per `HANDOFF.md`.
- Profiles carry a `# makefile-tier:` marker consumed by `makefile-check` — FACT.
- Versioning via GitVersion; releases automated on `main`/tags — FACT.
- Branch policy (INFERENCE from CI + memory): `main` + `develop` protected;
  PRs required. HANDOFF instructs "no commit/merge without explicit 'merge #N'".

## Environment assumptions (FACT / INFERENCE)

- Container mode assumes a compose service named `$(RUN_SERVICE)` (default `app`)
  with the repo bind-mounted — FACT (`runner.Makefile` header).
- Host needs GNU Make + bash; Python bricks assume `python3` (overridable) — FACT.
- CI runs Python 3.14 — FACT (`ci.yml`).

## Open / unknown

- **UNKNOWN**: minimum GNU Make version required (uses `$(value)`, pattern rules,
  `$(shell …)`; not pinned anywhere in-repo).
- **UNKNOWN**: whether `BASE_MAKEFILE_REF` in the shared standard now points at
  this brick library or still the flat baseline `v0.1.0-29` (`HANDOFF.md`).
