# CLAUDE.md — base-makefile

## Role

Collection de templates Makefile réutilisables pour les projets chrysa / Forge-Stack-Workshop.

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
