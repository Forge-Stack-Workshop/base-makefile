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

## Conventions

- All recipe lines must be prefixed with `@` to suppress shell echo.
- Add `## Description` after the target name to include it in the `help` output.

```makefile
build: ## Build the project
	@docker build -t myapp .
```

## Versioning

This repository uses [GitVersion](https://gitversion.net/) for automatic semantic versioning driven by commit messages and branch names. Configuration is in [`GitVersion.yml`](GitVersion.yml).
