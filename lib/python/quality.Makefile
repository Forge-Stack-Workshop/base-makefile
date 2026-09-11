#!make
# ─────────────────────────────────────────────────────────────────────────────
# python/quality — canonical lint / format / typecheck (chrysa naming policy).
# Ruff is the single lint+format authority. `files=` narrows the target set.
# Tools run through $(RUN) so they honour host vs container mode.
# ─────────────────────────────────────────────────────────────────────────────

.PHONY: lint lint-fix format typecheck

RUFF_TARGET = $(if $(files),$(files),$(SRC_DIR))

lint: ## Run the linter (ruff) => [files={path}]
	$(call log-info,ruff check $(RUFF_TARGET))
	@$(RUN) ruff check $(RUFF_TARGET)

lint-fix: ## Auto-fix lint violations (ruff --fix) => [files={path}]
	@$(RUN) ruff check --fix $(RUFF_TARGET)

format: ## Auto-format code (ruff format) => [files={path}]
	$(call log-info,ruff format $(RUFF_TARGET))
	@$(RUN) ruff format $(RUFF_TARGET)

typecheck: ## Static type-check (mypy) => [files={path}]
	$(call log-info,mypy $(RUFF_TARGET))
	@$(RUN) mypy $(RUFF_TARGET)
