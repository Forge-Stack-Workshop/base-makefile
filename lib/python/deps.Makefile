#!make
# ─────────────────────────────────────────────────────────────────────────────
# python/deps — canonical install + dependency audit (chrysa naming policy).
# EXTRAS controls the editable extras installed (default: dev tooling).
# ─────────────────────────────────────────────────────────────────────────────

.PHONY: install deps-outdated deps-audit

EXTRAS ?= tests,lint,dev

install: ## Install dev dependencies (editable, with extras) => [EXTRAS={a,b,c}]
	$(call log-info,pip install -e .[$(EXTRAS)])
	@$(call run_python,-m pip install -e ".[$(EXTRAS)]")

deps-outdated: ## List outdated packages
	@$(call run_python,-m pip list --outdated)

deps-audit: ## Scan installed dependencies for known CVEs (pip-audit)
	$(call log-info,pip-audit)
	@$(call run_python,-m pip_audit)
