---
name: new-brick
description: "Use when the user wants to add a new Makefile brick (a category file under makefiles/) to this library — e.g. \"add a docker brick\", \"scaffold a new makefile category\", \"add a security brick with an audit target\""
---

# Scaffolding a new brick

A brick is `makefiles/<category>.Makefile`. Every profile (`Makefile.basic`,
`Makefile.with-sub-folder`, `Makefile.python`) auto-`include`s every file
matching `makefiles/*.Makefile` and auto-derives `.PHONY` from `## `-documented
targets — no manual wiring needed for a new file to be picked up.

## Steps

1. Create `makefiles/<category>.Makefile`.
2. Add a one-line header comment stating the brick's purpose.
3. Add targets, each documented with `target: ## Description`:

```make
# <Category> targets — <one-line purpose>.

<target-name>: ## <Short description>
	@echo "TODO: <target-name>"
```

4. If a target takes an argument, use the `=> [var={what}]` suffix so
   `make help` shows it (see `README.md` brick catalogue table for examples).
5. Do not add a `.PHONY:` line yourself — the root profile derives it
   automatically from documented targets across all `makefiles/*.Makefile`.
6. Update the brick catalogue table in `README.md` with the new category.
7. Run `bash scripts/smoke-test.sh` before opening a PR — it dry-runs every
   profile's `help` target and must exit clean (no stderr).

## Conventions to follow

- One brick, one concern — don't mix unrelated targets in the same file.
- English only, in code and comments.
- Static help text: never put `$(VAR)` inside a `##` comment, it prints
  literally.
- Guard destructive targets with a confirmation prompt before doing rm/reset.
