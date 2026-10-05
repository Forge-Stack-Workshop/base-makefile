#!make
# ─────────────────────────────────────────────────────────────────────────────
# js/node — front-end tooling under the canonical `web-*` names (chrysa policy:
# fullstack keeps backend lint/test bare and prefixes the frontend with web-).
# For a standalone frontend, the frontend profile aliases the bare canonical
# core (lint/format/test…) onto these web-* targets.
# PKG selects the package manager: npm (default) | pnpm | yarn.
# Commands run through $(RUN) so they honour host vs container mode.
# ─────────────────────────────────────────────────────────────────────────────

.PHONY: web-install web-dev web-build web-preview web-lint web-format web-typecheck web-test web-test-cov web-clean

PKG     ?= npm
PKG_RUN ?= $(PKG) run

web-install: ## Install node dependencies (reproducible)
	$(call log-info,$(PKG) install)
	@if [ "$(PKG)" = "npm" ]; then $(RUN) npm ci; else $(RUN) $(PKG) install --frozen-lockfile; fi

web-dev: ## Start the front-end dev server (hot reload)
	@$(RUN) $(PKG_RUN) dev

web-build: ## Build the front-end for production
	@$(RUN) $(PKG_RUN) build

web-preview: ## Preview the production build
	@$(RUN) $(PKG_RUN) preview

web-lint: ## Lint the front-end (ESLint)
	@$(RUN) $(PKG_RUN) lint

web-format: ## Format the front-end (Prettier)
	@$(RUN) $(PKG) exec prettier -- --write .

web-typecheck: ## Type-check the front-end (tsc, no emit)
	@$(RUN) $(PKG) exec tsc -- --noEmit

web-test: ## Run the front-end test suite
	@$(RUN) $(PKG_RUN) test

web-test-cov: ## Run front-end tests with coverage
	@$(RUN) $(PKG_RUN) test -- --coverage

web-clean: ## Remove front-end build output and node_modules
	@rm -rf dist build node_modules
