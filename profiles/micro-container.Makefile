# makefile-tier: lib
#!make
# ═════════════════════════════════════════════════════════════════════════════
# Profile: micro-container — same as micro, but every tool (lint/typecheck/test/
# install) runs inside a docker-compose service. Requires a compose file with a
# service named $(RUN_SERVICE) (default: app) that bind-mounts the repo.
#   make RUN_SERVICE=app test
# pre-commit still runs on the host (it manages its own hook envs).
# ═════════════════════════════════════════════════════════════════════════════

# ── Project overrides (set before includes) ─────────────────────────────────
# PROJECT_NAME := my-tool
# SRC_DIR      := src
# RUN_SERVICE  := app

include lib/common/00_variables.Makefile
include lib/common/01_functions.Makefile
include lib/docker/runner.Makefile   # sets RUN → container execution
include lib/common/lifecycle.Makefile

include lib/python/quality.Makefile
include lib/python/tests.Makefile
include lib/python/deps.Makefile
include lib/python/clean.Makefile
include lib/docker/compose.Makefile
include lib/quality/precommit.Makefile
include lib/git/github.Makefile

# ── Profile-local targets ────────────────────────────────────────────────────
.PHONY: config

config: ## Print the resolved project configuration
	@echo "PROJECT_NAME=$(PROJECT_NAME) SRC_DIR=$(SRC_DIR) RUN='$(RUN)'"

include lib/common/02_help.Makefile
