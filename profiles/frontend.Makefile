# makefile-tier: lib
#!make
# ═════════════════════════════════════════════════════════════════════════════
# Profile: frontend — a standalone Node/Vite front-end (React/Vue/Svelte…).
# The library ships front-end targets as web-*; this profile exposes them under
# the canonical bare names (lint/format/test/…) required of a standalone repo.
#   make install && make dev
# Set PKG=pnpm (or yarn) if you don't use npm.
# ═════════════════════════════════════════════════════════════════════════════

# ── Project overrides (set before includes) ─────────────────────────────────
# PROJECT_NAME := my-front
# PKG          := pnpm

include lib/common/00_variables.Makefile
include lib/common/01_functions.Makefile

include lib/js/node.Makefile
include lib/quality/precommit.Makefile
include lib/git/github.Makefile

# ── Canonical core → web-* (chrysa naming policy) ────────────────────────────
.PHONY: install dev build lint format typecheck test test-cov clean ci

install: web-install    ## Install dependencies
dev: web-dev            ## Start the dev server
build: web-build        ## Build for production
lint: web-lint          ## Run the linter
format: web-format      ## Auto-format code
typecheck: web-typecheck ## Type-check
test: web-test          ## Run tests
test-cov: web-test-cov  ## Run tests with coverage
clean: web-clean        ## Remove build output and node_modules
ci: lint typecheck test ## Aggregate CI gate: lint + typecheck + test

include lib/common/02_help.Makefile
