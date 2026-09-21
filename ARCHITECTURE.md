# Architecture — base-makefile

## Purpose

Composable Make library for Forge-Stack / chrysa projects. It provides one shared
core, small single-purpose "bricks", and ready-made "profiles" that are dropped
into a target project as its root `Makefile`. Flat single-file templates are kept
under `examples/` for projects that do not want the `lib/` layout. Consumers copy
`lib/` plus one profile into their project rather than depending on this repo at
runtime.

## Stack

- **GNU Make** — the entire library is `*.Makefile` fragments assembled via `include`.
- **Shell (bash)** — `scripts/install.sh` (wiring) and `scripts/smoke-test.sh` (validation).
- **Node.js** — `.claude/hooks/*.cjs` (Claude Code automation hooks; not part of the Make library).
- **Tooling referenced by bricks** — Python (Ruff, mypy, pytest, Alembic, Django, Sphinx),
  JS/Node, Docker/Compose, Helm, Terraform, Unity CLI, pre-commit, GitVersion.
- **CI** — GitHub Actions (`.github/workflows/ci.yml`, `cd.yml`); Python 3.14 in CI for pre-commit.

## Layout

- `lib/` — the library, organized by category, copied into consumer projects:
  - `common/` — `00_variables`, `01_functions`, `02_help`, `lifecycle` (shared core; `02_help` included last).
  - `python/` — `clean`, `deps`, `quality`, `tests`.
  - `js/` — `node`.
  - `docker/` — `build`, `compose`, `runner` (sets `RUN` to exec inside a container).
  - `db/` — `alembic`. `django/` — `manage`. `docs/` — `sphinx`.
  - `infra/` — `helm`, `terraform`. `ops/` — `backup`, `docs`, `release`.
  - `quality/` — `precommit`, `coverage-gate`. `git/` — `github`. `unity/` — `unity`.
- `profiles/` — pick one, rename to `Makefile`: `micro`, `micro-container`, `frontend`,
  `django`, `fastapi`, `fullstack`, `fullstack-container`, `infra`, `unity`.
- `examples/` — standalone flat templates with no `lib/`: `Makefile.basic`,
  `Makefile.python`, `Makefile.with-sub-folder`, plus a sample `examples/makefiles/` set.
- `scripts/` — `install.sh` (wire library into a project), `smoke-test.sh` (validate templates).
- `.github/` — CI/CD workflows, issue/PR templates, dependabot.
- `.claude/` — Claude Code hooks, settings, and thresholds (repo tooling, not shipped to consumers).

## Entrypoints

- **`scripts/install.sh`** — one command wires the library into a project: copies `lib/`
  and the chosen profile as `Makefile`. Supports `--list` to list profiles.
- **A consumer's root `Makefile`** — a copied profile that `include`s the `lib/` bricks;
  `common/02_help` is included last so it sees every target. `make help` is the generated
  entry surface (built from `target: ## Description` comments).
- **`scripts/smoke-test.sh`** — validation entrypoint; runs Make against the templates and
  asserts a clean exit with empty stderr.

## Data / External deps

- No application data store or runtime service — this is a build-tooling library.
- External dependencies are the tools invoked by the bricks (installed in the consumer
  project or its containers), not by this repo. Every Python/JS tool call is prefixed with
  `$(RUN)`: empty on the host, or a container-exec prefix when `lib/docker/runner.Makefile`
  is included (the `*-container` profiles do this). pre-commit stays on the host.
- Variables are overridable on the command line (e.g. `make test PYTEST_ARGS="-k foo"`);
  required variables use a `check-defined-<var>` prerequisite that fails with a clear message.
- CI uses `chrysa/github-actions/gitversion` and GitVersion (`GitVersion.yml`) for versioning.

## Build & test

Real commands (from README and CI):

```bash
# Install the library + a profile into a project
scripts/install.sh --list                 # list available profiles
scripts/install.sh                         # copy lib/ + chosen profile as Makefile

# Validate the templates (also run in CI job "Validate Makefiles")
./scripts/smoke-test.sh

# Quality gate (CI job "Pre-commit checks", Python 3.14)
pip install pre-commit
pre-commit run --all-files

# In a consumer project, common targets exposed by the bricks:
make help                                  # generated target listing
make dev / make build / make ci / make docker-test   # common/lifecycle
make test / make lint / make format / make typecheck # python/js bricks
make coverage-gate                         # fail below COVERAGE_MIN
make pre-commit / make pre-commit-install  # quality/precommit
```

Note: this repo itself has no root `Makefile` — the profiles are meant to be copied
into a consumer as `Makefile`. The repo's own checks run through `scripts/smoke-test.sh`
and pre-commit, wired in GitHub Actions.

## Notes

- The repo README/CLAUDE.md describe manifests accurately; the only divergence worth flagging
  is that `CLAUDE.md` references a "GitNexus" MCP index, while the active knowledge graph in
  this checkout is under `graphify-out/` (graphify). Trust the actual `lib/`, `profiles/`, and
  `scripts/` files, which are the source of truth for the Make library.
