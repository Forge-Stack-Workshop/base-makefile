# base-makefile

[![CI](https://github.com/Forge-Stack-Workshop/base-makefile/actions/workflows/ci.yml/badge.svg)](https://github.com/Forge-Stack-Workshop/base-makefile/actions/workflows/ci.yml)
[![CD](https://github.com/Forge-Stack-Workshop/base-makefile/actions/workflows/cd.yml/badge.svg)](https://github.com/Forge-Stack-Workshop/base-makefile/actions/workflows/cd.yml)
[![Latest Release](https://img.shields.io/github/v/release/Forge-Stack-Workshop/base-makefile)](https://github.com/Forge-Stack-Workshop/base-makefile/releases/latest)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=Forge-Stack-Workshop_base-makefile&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=Forge-Stack-Workshop_base-makefile)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit)](https://github.com/pre-commit/pre-commit)
[![GitVersion](https://img.shields.io/badge/versioning-GitVersion-blue)](https://gitversion.net/)

Generic, reusable Makefile templates for any project.

## Templates

### `Makefile.basic`

Single-file Makefile. Iterates over `$(MAKEFILE_LIST)` to display the `help` target.

Override the project name at call time or at the top of the file:

```bash
make help PROJECT_NAME="my-project"
```

### `Makefile.with-sub-folder`

Multi-file variant. Requires `*.Makefile` files placed in a `makefiles/` sub-folder.

The `help` target automatically groups commands by category based on the filename:

| Filename | Icon | Category |
|---|---|---|
| `development.Makefile` | ⚡ | DEVELOPMENT |
| `docker.Makefile` | 🐳 | DOCKER |
| `quality.Makefile` | 🔍 | QUALITY |
| `tests.Makefile` | 🧪 | TESTS |
| `tools.Makefile` | 🔧 | TOOLS |
| `project.Makefile` | 🚀 | PROJECT |
| `ci.Makefile` / `cicd.Makefile` | ⚙️ | CI/CICD |
| `lint.Makefile` | 🧹 | LINT |
| `secrets.Makefile` | 🔐 | SECRETS |
| *(other)* | 📌 | *(name)* |

Override the project name:

```bash
make help PROJECT_NAME="my-project"
```

### `Makefile.python`

Python-oriented template with Docker Compose support. Covers `install`, `lint`, `format`, `typecheck`, `test`, `build`, `pre-commit`, and Docker helpers.

See [`Makefile.python`](Makefile.python) for the full template.

## Conventions

- All recipe lines must be prefixed with `@` to suppress shell echo.
- Add `## Description` after the target name to include it in the `help` output.

```makefile
build: ## Build the project
        @docker build -t myapp .
```

## Non-root `package.json` projects

When the app lives in a subdirectory (e.g. `app/`) rather than the repo root, CI workflows
must set the working directory explicitly:

```yaml
# .github/workflows/ci.yml
- name: Install
  working-directory: app
  run: npm ci

- name: Build
  working-directory: app
  run: npm run build
```

The Makefile should forward targets accordingly:

```makefile
install: ## Install dependencies
        @cd app && npm ci

build: ## Build the application
        @cd app && npm run build
```

## `ci.Makefile` example

When using `Makefile.with-sub-folder`, place CI-specific targets in `makefiles/ci.Makefile`:

```makefile
# makefiles/ci.Makefile
# CI targets — run without Docker in CI runners

.PHONY: ci-pre-commit
ci-pre-commit: ## CI: run all pre-commit hooks
        @pre-commit run --all-files

.PHONY: ci-lint
ci-lint: ## CI: run linter
        @npm run lint --prefix app

.PHONY: ci-test
ci-test: ## CI: run test suite with coverage
        @npm run test:ci --prefix app

.PHONY: ci-build
ci-build: ## CI: build for production
        @npm run build --prefix app

.PHONY: ci
ci: ci-pre-commit ci-lint ci-test ci-build ## CI: run all checks
```

## Versioning

This repository uses [GitVersion](https://gitversion.net/) for automatic semantic versioning driven by commit messages and branch names. Configuration is in [`GitVersion.yml`](GitVersion.yml).
