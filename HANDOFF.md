# HANDOFF — librairie base-makefile

Document de reprise. Un autre compte peut continuer sans contexte préalable.

## Objectif

Librairie Make **composable** dans
`/home/anthony/Documents/perso/projects/Forge-Stack-Workshop/base-makefile` :
socle partagé `lib/common/` + briques `lib/<catégorie>/` assemblées par des
profils `profiles/<nom>.Makefile`. Conforme au standard chrysa
`shared-standards/docs/MAKEFILE-STANDARD.md` (noms canoniques + tiers,
`makefile-check`).

## État — FAIT et validé

- **Briques** (`lib/`, 1 `.PHONY` par fichier ; outils routés via `$(RUN)`) :
  - `common/` : `00_variables`, `01_functions` (macros `check_defined`,
    `confirm_destructive`, `run_python`, `run_in_service`), `02_help`
    (help groupé + `.PHONY` auto), `lifecycle` (`dev`/`build`/`ci`/`docker-test`).
  - `python/` : `quality` (`lint`/`lint-fix`/`format`/`typecheck`),
    `tests` (`test`/`test-cov`/`test-report`), `deps` (`install`/`deps-*`), `clean`.
  - `quality/precommit` (`pre-commit*`, host, hors `$(RUN)`).
  - `js/node` (`web-*`), `unity/unity` (`unity-*`),
    `docker/{compose,runner}`, `django/manage`, `git/github`, `ops/{backup,docs}`.
- **Profils** (marqueur `# makefile-tier`, passent `makefile-check` exit 0) :
  `micro`, `micro-container`, `frontend`, `django`, `fullstack`,
  `fullstack-container`, `unity`.
- **Installer** : `scripts/install.sh --profile <nom> --dest <path>` (copie `lib/`
  + profil renommé `Makefile`) ; `--list`.
- **Mode conteneur** : inclure `lib/docker/runner.Makefile` (fait par les profils
  `*-container`) fixe `RUN` → tout tourne dans le service `$(RUN_SERVICE)`.
- **Réorg** : anciens templates plats sous `examples/` (inchangés, `Makefile.basic|
  python|with-sub-folder` gardent ce nom car le motif d'auto-include les référence).
- **Docs** : `README.md`, `CONTRIBUTING.md` (règles briques/profils), `CLAUDE.md`,
  ce HANDOFF. Standard chrysa mis à jour (nouvelle section « Brick library »).
- **smoke-test** : `scripts/smoke-test.sh` couvre 7 profils + 3 exemples (10 OK).

## Vérif rapide

```bash
cd base-makefile
bash scripts/smoke-test.sh
scripts/install.sh --list
```

## RESTE À FAIRE / points ouverts

1. **Aucun commit** dans base-makefile ni dans shared-standards. Ne pas committer/
   merger sans « merge #N » explicite. Branche base-makefile :
   `chore/decouple-chrysa-actions` ; shared-standards : `feat/context-pack-extra-files`.
2. **Warnings `makefile-check` non bloquants** : le linter ne fusionne pas les
   `.PHONY` des include (warning « .PHONY does not list… ») ; tiers `fullstack`
   signale `e2e`/`quality-gate-*` recommandés absents. Errors=0 partout.
3. **Briques candidates** listées dans le standard (docker/build, ops/release,
   infra/helm, infra/terraform, docs/sphinx, quality/coverage-gate, db/alembic) —
   à ajouter au besoin.
4. `sync-makefile.sh` / `BASE_MAKEFILE_REF` du standard pointent encore la baseline
   des templates plats (`v0.1.0-29`) ; à faire évoluer si la lib à briques devient
   la source par défaut.

## Contraintes

- Réponses en **français** ; code/commits selon conventions repo.
- Pas de `Co-Authored-By` IA. Ne pas introduire de secret.
- Nommage fichiers includables : `<nom>.Makefile` (jamais `Makefile.<nom>`).
- Ordre d'inclusion : `00_variables` → `01_functions` → briques → `02_help` en dernier.
