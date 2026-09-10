#!make
# ─────────────────────────────────────────────────────────────────────────────
# python/tests — canonical test / test-cov (chrysa naming policy).
# `PYTEST_ARGS` forwards raw flags to pytest: make test PYTEST_ARGS="-k mqtt -x".
# ─────────────────────────────────────────────────────────────────────────────

.PHONY: test test-cov test-report

test: ## Run the test suite (pytest) => [PYTEST_ARGS={flags}]
	$(call log-info,pytest $(PYTEST_ARGS))
	@$(call run_python,-m pytest $(PYTEST_ARGS))

test-cov: ## Run tests with coverage (floor 80%) => [PYTEST_ARGS={flags}]
	@$(call run_python,-m pytest --cov=$(SRC_DIR) --cov-report=term-missing $(PYTEST_ARGS))

test-report: ## Run tests and write XML + HTML coverage under the reports dir
	@mkdir -p $(REPORTS_DIR)
	@$(call run_python,-m pytest \
		--junitxml=$(REPORTS_DIR)/tests.xml \
		--cov=$(SRC_DIR) \
		--cov-report=xml:$(REPORTS_DIR)/coverage.xml \
		--cov-report=html:$(REPORTS_DIR)/htmlcov $(PYTEST_ARGS))
