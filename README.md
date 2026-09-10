# base-makefile

Composable Make library for Forge-Stack / chrysa projects. One shared core,
small single-purpose bricks, and ready-made profiles you drop into a project as
its root `Makefile`. Flat single-file templates are kept under `examples/` for
projects that don't want the `lib/` layout.

## Layout

```
lib/                          the library (copy into your project)
  common/   00_variables · 01_functions · 02_help · lifecycle   (core)
  python/   quality · tests · deps · clean
  quality/  precommit · coverage-gate                (host-run hooks / coverage floor)
  js/       node                                     (npm/pnpm/yarn)
  unity/    unity                                    (Unity CLI: tests + build)
  docker/   compose · runner · build                 (runner = container mode)
  django/   manage
  db/       alembic                                  (SQLAlchemy/FastAPI migrations)
  infra/    helm · terraform
  docs/     sphinx
  git/      github
  ops/      backup · docs · release                  (drift-checked docs / changelog+tag)
profiles/                     pick one, rename to Makefile
  micro.Makefile                common + python + precommit + git      flat Python tool/lib
  micro-container.Makefile      micro, all tools in a container        containerized Python
  frontend.Makefile             common + js + precommit + git          Node/Vite front-end
  django.Makefile               + docker + django                      Dockerized Django app
  fastapi.Makefile              + docker + alembic                     Dockerized FastAPI service
  fullstack.Makefile            django + node + ops                    Django + Node monorepo
  fullstack-container.Makefile  fullstack, all tools in a container    containerized monorepo
  unity.Makefile                common + unity + precommit + git       Unity project
  infra.Makefile                common + helm + terraform              Helm/Terraform infra
examples/                     standalone flat templates (no lib/)
  Makefile.basic · Makefile.python · Makefile.with-sub-folder · makefiles/
scripts/install.sh            wire the library into a project (see below)
scripts/smoke-test.sh         dry-runs every profile + example (CI gate)
```

## Install into a project

One command wires the whole ecosystem in — copies `lib/` and the chosen profile
(renamed `Makefile`) into the target:

```bash
scripts/install.sh --profile django --dest /path/to/project
scripts/install.sh --list                 # list profiles
scripts/install.sh -p micro-container -d . # into the current dir
```

Or do it by hand:

1. Copy `lib/` to your project root.
2. Copy one profile as `Makefile`: `cp profiles/django.Makefile ./Makefile`.
3. Set project overrides at the top of that `Makefile`, before the includes:
   ```make
   PROJECT_NAME   := my-api
   SRC_DIR        := myapp
   DJANGO_SERVICE := web     # run manage.py inside this compose service
   ```
4. `make` → auto-generated help, grouped by category.

## Conventions

- **Help is generated** from `target: ## Description => [var={what}]` comments.
  Undocumented targets are hidden. `make help-<target>` shows a definition.
- **Everything is overridable** on the command line: `make test PYTEST_ARGS="-k foo"`,
  `make lint files=src/`, `make PYTHON=python3.14 ci`, `make PKG=pnpm web-build`.
- **Required variables** use the `check-defined-<var>` prerequisite; a missing
  value fails with a clear message instead of running a broken command.
- **Destructive actions** call `confirm_destructive`; pass `CONFIRM=yes` to skip
  the prompt in CI.
- **Include order matters**: `00_variables` → `01_functions` → category bricks →
  `02_help` (last, so it sees every target). Profiles already do this.
- **One `.PHONY` per file**: each brick declares all its phony targets in a
  single `.PHONY` line at the top; `common/02_help` also auto-declares every
  documented target across included bricks.

## Host vs container execution

Every tool call in the Python/JS bricks is prefixed with `$(RUN)`. On the host
`RUN` is empty. Including `lib/docker/runner.Makefile` sets it to
`docker compose run --rm --user <uid:gid> $(RUN_SERVICE)`, so the same targets
run inside a container. The `*-container` profiles do this for you:

```bash
make RUN_SERVICE=app test      # pytest runs inside the "app" service
```

pre-commit stays on the host (it manages its own isolated hook environments).

## Composing your own profile

```make
include lib/common/00_variables.Makefile
include lib/common/01_functions.Makefile
include lib/python/quality.Makefile
include lib/docker/compose.Makefile
include lib/common/02_help.Makefile
```

## Brick catalogue

Target names follow the chrysa canonical naming policy (`lint`/`format`/`test`/
`typecheck`/`pre-commit`…), enforced by `makefile-check`.

| Brick | Key targets |
| --- | --- |
| `common/help` | `help`, `help-%`, `check-defined-%` |
| `common/lifecycle` | `dev`, `build`, `ci`, `docker-test` |
| `python/quality` | `lint`, `lint-fix`, `format`, `typecheck` |
| `python/tests` | `test`, `test-cov`, `test-report` |
| `python/deps` | `install`, `deps-outdated`, `deps-audit` |
| `python/clean` | `clean`, `clean-reports` |
| `quality/precommit` | `pre-commit`, `pre-commit-install`, `pre-commit-update` |
| `quality/coverage-gate` | `coverage-gate` (fail below `COVERAGE_MIN`) |
| `js/node` | `web-install/dev/build/preview/lint/format/typecheck/test/test-cov/clean` |
| `unity/unity` | `unity-tests`, `unity-tests-play`, `unity-build`, `unity-license` |
| `docker/compose` | `docker-build/up/down/ps/logs/sh` |
| `docker/runner` | sets `RUN` to a container wrapper; `runner-shell` |
| `docker/build` | `image-build`, `image-tag`, `image-push` |
| `django/manage` | `manage`, `migrate`, `makemigrations(-check)`, `showmigrations`, `django-shell`, `superuser` |
| `db/alembic` | `db-upgrade`, `db-downgrade`, `db-revision`, `db-current`, `db-history` |
| `infra/helm` | `helm-lint/render/package/diff/deploy` |
| `infra/terraform` | `tf-init/fmt/validate/plan/apply/destroy` |
| `docs/sphinx` | `docs-html`, `docs-serve`, `docs-clean` |
| `git/github` | `git-clean-check`, `version`, `pr-create`, `pr-view` |
| `ops/backup` | `backup`, `restore` |
| `ops/docs` | `docs`, `docs-check` |
| `ops/release` | `changelog`, `release-tag`, `release` |

See `CONTRIBUTING.md` to add a brick or profile.
