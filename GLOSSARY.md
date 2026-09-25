# GLOSSARY — base-makefile

> Docs-only. Terms as used in this repository (FACT unless noted).

| Term | Meaning |
| --- | --- |
| **Brick** | A single-purpose includable `lib/<category>/<name>.Makefile`. Defines targets + local vars only; never includes another brick. |
| **Profile** | A ready-made root `Makefile` (`profiles/<name>.Makefile`) that includes the core + a selection of bricks for a stack. |
| **Core** | `lib/common/` bricks: `00_variables`, `01_functions`, `02_help`, `lifecycle`. |
| **`$(RUN)`** | Prefix before tool calls. Empty on host; a `docker compose run` wrapper in container mode. |
| **Container mode** | Enabled by including `lib/docker/runner.Makefile`; runs `$(RUN)`-routed tools inside service `$(RUN_SERVICE)`. |
| **Tier** (`# makefile-tier:`) | Marker on a profile classifying the project type; consumed by `makefile-check`. |
| **`makefile-check`** | External linter (chrysa `shared-standards`) validating canonical names/tiers. Not run in this repo's CI (UNKNOWN/INFERENCE). |
| **Canonical target names** | The chrysa standard names (`lint`/`format`/`test`/`typecheck`/`pre-commit`/`ci`…). |
| **Smoke-test** | `scripts/smoke-test.sh` — dry-runs `help` for every profile+example, fails on non-zero exit or stderr. |
| **`check-defined-%`** | Prerequisite target that fails if variable `%` is empty. |
| **`confirm_destructive`** | Macro gating irreversible actions behind y/N (bypass with `CONFIRM=yes`). |
| **Flat template** | Standalone `examples/Makefile.*` for projects not using the `lib/` layout. |
| **GitVersion** | Tool computing the semantic version (`GitVersion.yml`) used by CI/CD. |
