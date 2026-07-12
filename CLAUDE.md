# CLAUDE.md — base-makefile

## Role

Collection de templates Makefile réutilisables pour les projets chrysa / Forge-Stack-Workshop.


## Language Rules

- Language: English — all code, comments, documentation, instructions, and configuration files must be in English.
## Templates disponibles

| Fichier | Usage |
|---------|-------|
| `Makefile.basic` | Projet simple mono-fichier |
| `Makefile.with-sub-folder` | Projet multi-fichier avec `makefiles/` (catégories auto-détectées) |
| `Makefile.python` | Profil Python avec cibles lint/test/format/venv |

## Convention obligatoire

```makefile
target: ## Description courte de la cible
	@commande
```

- Toutes les commandes préfixées par `@` (pas d'écho shell).
- `## Description` après le nom de cible = apparaît dans `make help`.

## Structure `Makefile.with-sub-folder`

Placer les fichiers `*.Makefile` dans `makefiles/`. La cible `help` groupe par nom de fichier :

| Fichier | Icône | Catégorie |
|---------|-------|-----------|
| `development.Makefile` | ⚡ | DEVELOPMENT |
| `docker.Makefile` | 🐳 | DOCKER |
| `quality.Makefile` | 🔍 | QUALITY |
| `tests.Makefile` | 🧪 | TESTS |
| `ci.Makefile` | ⚙️ | CI/CICD |

## CI / Standards

- CI workflow : `.github/workflows/ci.yml`
- pre-commit : `.pre-commit-config.yaml`
- Versioning automatique : GitVersion (`GitVersion.yml`)

## PRs ouvertes

- #18 (dependabot) : actions/checkout v4 → v6 — à merger

## Liens

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

## graphify

This project has a knowledge graph at graphify-out/ with god nodes, community structure, and cross-file relationships.

Rules:
- For codebase questions, first run `graphify query "<question>"` when graphify-out/graph.json exists. Use `graphify path "<A>" "<B>"` for relationships and `graphify explain "<concept>"` for focused concepts. These return a scoped subgraph, usually much smaller than GRAPH_REPORT.md or raw grep output.
- If graphify-out/wiki/index.md exists, use it for broad navigation instead of raw source browsing.
- Read graphify-out/GRAPH_REPORT.md only for broad architecture review or when query/path/explain do not surface enough context.
- After modifying code, run `graphify update .` to keep the graph current (AST-only, no API cost).
