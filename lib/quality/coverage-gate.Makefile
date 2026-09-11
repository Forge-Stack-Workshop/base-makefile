#!make
# ─────────────────────────────────────────────────────────────────────────────
# quality/coverage-gate — enforce a coverage floor as a standalone gate.
# COVERAGE_MIN = percentage floor (chrysa standard: 80). Reads coverage from a
# prior run; runs pytest with --cov-fail-under so CI fails below the floor.
# ─────────────────────────────────────────────────────────────────────────────

.PHONY: coverage-gate

COVERAGE_MIN ?= 80

coverage-gate: ## Fail if coverage is below the floor => [COVERAGE_MIN={pct}]
	$(call log-info,coverage floor $(COVERAGE_MIN)%)
	@$(call run_python,-m pytest --cov=$(SRC_DIR) --cov-fail-under=$(COVERAGE_MIN) $(PYTEST_ARGS))
