#!make
# ─────────────────────────────────────────────────────────────────────────────
# quality/precommit — canonical pre-commit target (chrysa naming policy).
# Runs on the host: pre-commit manages its own isolated hook environments, so it
# is deliberately NOT routed through $(RUN). `files=` narrows the run.
# ─────────────────────────────────────────────────────────────────────────────

.PHONY: pre-commit pre-commit-install pre-commit-update

pre-commit: ## Run all pre-commit hooks => [files={path}]
	@$(PRE_COMMIT) run $(if $(files),--files $(files),--all-files)

pre-commit-install: ## Install the git pre-commit and pre-push hooks
	@$(PRE_COMMIT) install
	@$(PRE_COMMIT) install --hook-type pre-push

pre-commit-update: ## Update pinned pre-commit hook versions
	@$(PRE_COMMIT) autoupdate
