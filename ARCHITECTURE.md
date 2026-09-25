# ARCHITECTURE — base-makefile

> Docs-only artefact. Claims tagged **FACT** (verified in-repo), **INFERENCE**
> (reasoned from evidence), **UNKNOWN**, **PROPOSAL**. No source was modified.

## 1. Purpose (FACT)

Composable GNU Make library for Forge-Stack-Workshop / chrysa projects. It ships
a shared core, single-purpose "bricks", and ready-made "profiles" that a project
drops in as its root `Makefile` (via `scripts/install.sh` or by hand). Flat
single-file templates are retained under `examples/` for projects that do not
want the `lib/` layout.

Evidence: `README.md`, `HANDOFF.md`, `CLAUDE.md`, `lib/`, `profiles/`,
`scripts/install.sh`.

## 2. Layers (FACT)

Three composition layers, assembled by include order:

```
common/00_variables  →  common/01_functions  →  <category bricks>  →  common/02_help
```

| Layer | Path | Role |
| --- | --- | --- |
| Core variables | `lib/common/00_variables.Makefile` | Overridable config (`PYTHON`, `RUN`, `SRC_DIR`, `REPORTS_DIR`, colors); strict shell (`bash -eu -o pipefail`, `--warn-undefined-variables`, `--no-builtin-rules`). |
| Core functions | `lib/common/01_functions.Makefile` | Macros only, no targets: `log-info/error/ok`, `check_defined`, `confirm_destructive`, `run_python`, `run_in_service`. |
| Category bricks | `lib/<category>/<name>.Makefile` | Domain targets (python, docker, django, db, infra, js, unity, ops, docs, git, quality). One concern per brick; never `include` another brick. |
| Help / meta | `lib/common/02_help.Makefile` | `.DEFAULT_GOAL := help`; parses `## ` comments across `MAKEFILE_LIST`, grouped by file; auto-declares every documented target `.PHONY`; provides `help-%`, `check-defined-%`. Loaded **last**. |

## 3. Execution modes: host vs container (FACT)

Every tool call in the Python/JS bricks is prefixed with `$(RUN)`.

- Host mode (default): `RUN` is empty → tools run on the host.
- Container mode: including `lib/docker/runner.Makefile` sets
  `RUN := $(DOCKER_COMPOSE) run --rm --user $(RUN_USER) $(RUN_SERVICE)` where
  `RUN_USER ?= $(id -u):$(id -g)` — so mount-written files stay developer-owned.
- pre-commit is deliberately **not** routed through `$(RUN)` (it manages its own
  isolated hook environments). Evidence: `README.md`, `CONTRIBUTING.md`,
  `lib/docker/runner.Makefile`, `lib/quality/precommit.Makefile`.

The `*-container` profiles include `runner` for you.

## 4. Brick catalogue (FACT — verified against `lib/` tree + README table)

| Brick | File | Key targets |
| --- | --- | --- |
| common/help | `lib/common/02_help.Makefile` | `help`, `help-%`, `check-defined-%` |
| common/lifecycle | `lib/common/lifecycle.Makefile` | `dev`, `build`, `ci` (= lint+typecheck+test), `docker-test` |
| python/quality | `lib/python/quality.Makefile` | `lint`, `lint-fix`, `format`, `typecheck` |
| python/tests | `lib/python/tests.Makefile` | `test`, `test-cov`, `test-report` |
| python/deps | `lib/python/deps.Makefile` | `install`, `deps-outdated`, `deps-audit` |
| python/clean | `lib/python/clean.Makefile` | `clean`, `clean-reports` |
| quality/precommit | `lib/quality/precommit.Makefile` | `pre-commit`, `pre-commit-install`, `pre-commit-update` |
| quality/coverage-gate | `lib/quality/coverage-gate.Makefile` | `coverage-gate` (fails below `COVERAGE_MIN`) |
| js/node | `lib/js/node.Makefile` | `web-install/dev/build/preview/lint/format/typecheck/test/test-cov/clean` |
| unity/unity | `lib/unity/unity.Makefile` | `unity-tests`, `unity-tests-play`, `unity-build`, `unity-license` |
| docker/compose | `lib/docker/compose.Makefile` | `docker-build/up/down/ps/logs/sh` |
| docker/runner | `lib/docker/runner.Makefile` | sets `RUN`; `runner-shell` |
| docker/build | `lib/docker/build.Makefile` | `image-build`, `image-tag`, `image-push` |
| django/manage | `lib/django/manage.Makefile` | `manage`, `migrate`, `makemigrations(-check)`, `showmigrations`, `django-shell`, `superuser` |
| db/alembic | `lib/db/alembic.Makefile` | `db-upgrade/downgrade/revision/current/history` |
| infra/helm | `lib/infra/helm.Makefile` | `helm-lint/render/package/diff/deploy` |
| infra/terraform | `lib/infra/terraform.Makefile` | `tf-init/fmt/validate/plan/apply/destroy` |
| docs/sphinx | `lib/docs/sphinx.Makefile` | `docs-html`, `docs-serve`, `docs-clean` |
| git/github | `lib/git/github.Makefile` | `git-clean-check`, `version`, `pr-create`, `pr-view` |
| ops/backup | `lib/ops/backup.Makefile` | `backup`, `restore` |
| ops/docs | `lib/ops/docs.Makefile` | `docs`, `docs-check` |
| ops/release | `lib/ops/release.Makefile` | `changelog`, `release-tag`, `release` |

## 5. Profiles (FACT — 9 files verified in `profiles/`)

`micro`, `micro-container`, `frontend`, `django`, `fastapi`, `fullstack`,
`fullstack-container`, `unity`, `infra`. Each carries a `# makefile-tier:`
marker and includes `00_variables → 01_functions → bricks → 02_help`.

## 6. Consumers & distribution (FACT / INFERENCE)

- **Install** (FACT): `scripts/install.sh --profile <name> --dest <path>` copies
  `lib/` and the chosen profile (renamed `Makefile`).
- **Standard** (FACT, per `HANDOFF.md`): conforms to chrysa
  `shared-standards/docs/MAKEFILE-STANDARD.md` (canonical target names + tiers,
  enforced by `makefile-check`).
- **Versioning** (FACT): GitVersion (`GitVersion.yml`, `chrysa/github-actions/gitversion@v1.8.2`);
  CD tags + releases on `main` / `v*` tags.
- The standard's `sync-makefile.sh` / `BASE_MAKEFILE_REF` still point at the flat
  template baseline `v0.1.0-29` (UNKNOWN whether updated since `HANDOFF.md`).
