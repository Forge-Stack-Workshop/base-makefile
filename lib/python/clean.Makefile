#!make
# ─────────────────────────────────────────────────────────────────────────────
# python/clean — remove build/test caches and generated reports.
# ─────────────────────────────────────────────────────────────────────────────

.PHONY: clean clean-reports

CLEAN_DIRS ?= __pycache__ *.egg-info .mypy_cache .ruff_cache .pytest_cache

clean: ## Remove Python caches and build artifacts
	$(call log-info,cleaning caches)
	@for pattern in $(CLEAN_DIRS); do \
		find . -type d -name "$$pattern" -not -path './.git/*' -exec rm -rf {} + 2>/dev/null || true; \
	done
	@find . -type f -name '*.py[co]' -delete 2>/dev/null || true

clean-reports: ## Remove the reports directory
	@rm -rf $(REPORTS_DIR)
