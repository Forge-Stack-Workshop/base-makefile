# CLAUDE.md — base-makefile

## Role

Collection of reusable Makefile templates for chrysa / Forge-Stack-Workshop projects.

## Language Rules

- Language: English — all code, comments, documentation, instructions, and configuration files must be in English.

## Available templates

| File | Usage |
|---------|-------|
| `Makefile.basic` | Simple single-file project |
| `Makefile.with-sub-folder` | Multi-file project with `makefiles/` (auto-detected categories) |
| `Makefile.python` | Python profile with lint/test/format/venv targets |

## Required convention

```makefile
target: ## Short description of the target
	@command
```

- All commands prefixed with `@` (no shell echo).
- `## Description` after the target name = shown in `make help`.

## `Makefile.with-sub-folder` structure

Place `*.Makefile` files in `makefiles/`. The `help` target groups by filename:

| File | Icon | Category |
|---------|-------|-----------|
| `development.Makefile` | ⚡ | DEVELOPMENT |
| `docker.Makefile` | 🐳 | DOCKER |
| `quality.Makefile` | 🔍 | QUALITY |
| `tests.Makefile` | 🧪 | TESTS |
| `ci.Makefile` | ⚙️ | CI/CICD |
| `global_rules.Makefile` | *(hidden)* | *(skipped in help)* |

A sample `makefiles/` directory is committed; `scripts/smoke-test.sh` dry-runs every template's `help` and asserts no stderr (wired into CI `validate-makefile`).

## CI / Standards

- CI workflow: `.github/workflows/ci.yml`
- pre-commit: `.pre-commit-config.yaml`
- Automatic versioning: GitVersion (`GitVersion.yml`)

## Links

- [GitHub](https://github.com/Forge-Stack-Workshop/base-makefile)
- [Notion — base-makefile](https://www.notion.so/base-makefile-Makefile-standard-r-utilisable-33959293e35e812d9237fad7830ac941)

<!-- gitnexus:start -->
# GitNexus — Code Intelligence

This project is indexed by GitNexus as **base-makefile** (27 symbols, 23 relationships, 0 execution flows). Use the GitNexus MCP tools to understand code, assess impact, and navigate safely.

> If any GitNexus tool warns the index is stale, run `npx gitnexus analyze` in terminal first.

## Always Do

- **MUST run impact analysis before editing any symbol.** Before modifying a function, class, or method, run `gitnexus_impact({target: "symbolName", direction: "upstream"})` and report the blast radius (direct callers, affected processes, risk level) to the user.
- **MUST run `gitnexus_detect_changes()` before committing** to verify your changes only affect expected symbols and execution flows.
- **MUST warn the user** if impact analysis returns HIGH or CRITICAL risk before proceeding with edits.
- When exploring unfamiliar code, use `gitnexus_query({query: "concept"})` to find execution flows instead of grepping. It returns process-grouped results ranked by relevance.
- When you need full context on a specific symbol — callers, callees, which execution flows it participates in — use `gitnexus_context({name: "symbolName"})`.

## Never Do

- NEVER edit a function, class, or method without first running `gitnexus_impact` on it.
- NEVER ignore HIGH or CRITICAL risk warnings from impact analysis.
- NEVER rename symbols with find-and-replace — use `gitnexus_rename` which understands the call graph.
- NEVER commit changes without running `gitnexus_detect_changes()` to check affected scope.

## Resources

| Resource | Use for |
|----------|---------|
| `gitnexus://repo/base-makefile/context` | Codebase overview, check index freshness |
| `gitnexus://repo/base-makefile/clusters` | All functional areas |
| `gitnexus://repo/base-makefile/processes` | All execution flows |
| `gitnexus://repo/base-makefile/process/{name}` | Step-by-step execution trace |

## CLI

| Task | Read this skill file |
|------|---------------------|
| Understand architecture / "How does X work?" | `.claude/skills/gitnexus/gitnexus-exploring/SKILL.md` |
| Blast radius / "What breaks if I change X?" | `.claude/skills/gitnexus/gitnexus-impact-analysis/SKILL.md` |
| Trace bugs / "Why is X failing?" | `.claude/skills/gitnexus/gitnexus-debugging/SKILL.md` |
| Rename / extract / split / refactor | `.claude/skills/gitnexus/gitnexus-refactoring/SKILL.md` |
| Tools, resources, schema reference | `.claude/skills/gitnexus/gitnexus-guide/SKILL.md` |
| Index, status, clean, wiki CLI commands | `.claude/skills/gitnexus/gitnexus-cli/SKILL.md` |

<!-- gitnexus:end -->
