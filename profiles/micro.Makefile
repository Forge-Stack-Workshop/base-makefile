# makefile-tier: lib
#!make
# ═════════════════════════════════════════════════════════════════════════════
# Profile: micro — a flat, host-run Python tool or library (no Docker).
# Usage: copy `lib/` into your project and this file as `Makefile` at the root.
#   make            # help
#   make ci         # lint + typecheck + test
# For a version where every tool runs in a container, use Makefile.micro-container.
# ═════════════════════════════════════════════════════════════════════════════

# ── Project overrides (set before includes) ─────────────────────────────────
# PROJECT_NAME := my-tool
# SRC_DIR      := src
# EXTRAS       := tests,lint

include lib/common/00_variables.Makefile
include lib/common/01_functions.Makefile
include lib/common/lifecycle.Makefile

include lib/python/quality.Makefile
include lib/python/tests.Makefile
include lib/python/deps.Makefile
include lib/python/clean.Makefile
include lib/quality/precommit.Makefile
include lib/git/github.Makefile

# ── Profile-local targets ────────────────────────────────────────────────────
.PHONY: config

config: ## Print the resolved project configuration
	@echo "PROJECT_NAME=$(PROJECT_NAME) SRC_DIR=$(SRC_DIR) RUN='$(RUN)'"

include lib/common/02_help.Makefile
