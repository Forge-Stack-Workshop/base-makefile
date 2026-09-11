# Contributing to base-makefile

The library is a set of small, includable Make bricks under `lib/`, assembled by
`profiles/`. Keep bricks single-purpose and path-independent.

## Golden rules

- **One brick, one concern.** A brick is `lib/<category>/<name>.Makefile`.
  It defines targets and brick-local variables only — never `include` another brick.
- **One `.PHONY` per file.** Declare every phony target of the brick in a single
  `.PHONY:` line at the top of the file. Do not scatter per-target `.PHONY` lines.
- **Route tools through `$(RUN)`.** Prefix tool invocations (ruff, mypy, pytest,
  pip, the JS package manager…) with `$(RUN)` so the brick works both on the host
  and in container mode. Do not route pre-commit through `$(RUN)`.
- **Document every target.** `target: prereqs ## Description => [var={what}]`.
  Undocumented targets are hidden from `make help`; the `=> [...]` suffix lists
  the variables the target reads.
- **Static help text.** Do not put `$(VAR)` inside a `##` comment — it is shown
  literally. Write the plain word instead.
- **Overridable, not hardcoded.** Expose choices as `?=` variables (interpreter,
  package manager, paths). Read them in recipes; never bake in a project name.
- **Guard required inputs** with a `check-defined-<var>` prerequisite rather than
  failing mid-recipe.
- **Guard destructive actions** with `$(call confirm_destructive,…)` (skippable
  via `CONFIRM=yes`).
- **English only**, in code, comments and docs.

## Shared macros (from `lib/common/01_functions.Makefile`)

| Macro | Use |
| --- | --- |
| `$(call log-info,msg)` / `log-error` / `log-ok` | consistent colored logging |
| `$(call check_defined,var,hint)` | fail if a variable is empty |
| `$(call confirm_destructive,desc)` | interactive y/N gate |
| `$(call run_python,args)` | run the configured interpreter |
| `$(call run_in_service,svc,cmd)` | exec inside a compose service |

## Adding a brick

1. Create `lib/<category>/<name>.Makefile` with a header comment stating its
   purpose and the variables it reads.
2. Use the shared macros; document each target.
3. Add it to the relevant profile(s) between `01_functions` and `02_help`.
4. Update the brick catalogue table in `README.md`.

## Adding a profile

1. Create `profiles/Makefile.<name>`: include `common/00_variables`,
   `common/01_functions`, the bricks you need, then `common/02_help` **last**.
2. List overridable project variables as commented examples at the top.
3. Document the profile in `README.md`.

## Before opening a PR

```bash
bash scripts/smoke-test.sh   # dry-runs every profile + example; must be clean
```

CI (`validate-makefile`) runs the same script and fails on any non-zero exit or
stderr output. Do not remove or weaken this gate.
