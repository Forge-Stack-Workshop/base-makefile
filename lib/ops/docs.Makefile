#!make
# ─────────────────────────────────────────────────────────────────────────────
# ops/docs — generated-docs drift gate.
# Treat generated docs as build artifacts: regenerate mechanically, then fail if
# the committed copy drifts. Point DOCS_GENERATE at this project's deterministic
# generator (sorted output, pinned hashes) so the diff stays quiet.
# ─────────────────────────────────────────────────────────────────────────────

.PHONY: docs docs-check

DOCS_PATHS    ?= docs/
DOCS_GENERATE ?=

docs: ## Regenerate all generated docs => set DOCS_GENERATE={command}
	@if [ -z "$(DOCS_GENERATE)" ]; then \
		$(call log-error,set DOCS_GENERATE to this project's docs generator); exit 1; \
	fi
	@$(DOCS_GENERATE)

docs-check: docs ## Fail if generated docs drift from the committed copy (CI)
	@git diff --exit-code -- $(DOCS_PATHS) \
		|| { $(call log-error,docs are stale — run 'make docs' and commit); exit 1; }
