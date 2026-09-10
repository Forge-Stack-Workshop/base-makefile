#!make
# ─────────────────────────────────────────────────────────────────────────────
# common/lifecycle — canonical dev / build / ci / docker-test targets.
# Generic and overridable: set DEV_CMD / BUILD_CMD to your stack's commands.
# `ci` aggregates lint + typecheck + test, which the profile provides via its
# quality/tests bricks. Include this only where those targets exist.
# ─────────────────────────────────────────────────────────────────────────────

.PHONY: dev build ci docker-test

DEV_CMD     ?= echo "no dev server for this project (override DEV_CMD)"
BUILD_CMD   ?= $(RUN) $(PYTHON) -m build
RUN_SERVICE ?= app

dev: ## Start the dev server / watch mode (Ctrl+C to stop)
	@$(DEV_CMD)

build: ## Build the production artefact => [BUILD_CMD={command}]
	$(call log-info,build)
	@$(BUILD_CMD)

ci: lint typecheck test ## Aggregate CI gate: lint + typecheck + test

docker-test: ## Run the test suite inside a container (CI-compatible)
	@$(DOCKER_COMPOSE) run --rm $(RUN_SERVICE) $(PYTHON) -m pytest $(PYTEST_ARGS)
