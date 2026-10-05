# makefile-tier: python-app
#!make
# ═════════════════════════════════════════════════════════════════════════════
# Profile: fastapi — a Dockerized FastAPI service with Alembic migrations.
#   make docker-up
#   make db-upgrade
#   make ci                 # lint + typecheck + test
# Add lib/docker/runner.Makefile after 00_variables to run tools in a container.
# ═════════════════════════════════════════════════════════════════════════════

# ── Project overrides (set before includes) ─────────────────────────────────
# PROJECT_NAME := my-service
# SRC_DIR      := app
# DEV_CMD      := $(DOCKER_COMPOSE) up

include lib/common/00_variables.Makefile
include lib/common/01_functions.Makefile
include lib/common/lifecycle.Makefile

include lib/python/quality.Makefile
include lib/python/tests.Makefile
include lib/python/deps.Makefile
include lib/python/clean.Makefile
include lib/db/alembic.Makefile
include lib/docker/compose.Makefile
include lib/quality/precommit.Makefile
include lib/git/github.Makefile

# ── Profile-local targets ────────────────────────────────────────────────────
.PHONY: config

config: ## Print the resolved project configuration
	@echo "PROJECT_NAME=$(PROJECT_NAME) SRC_DIR=$(SRC_DIR) RUN='$(RUN)'"

include lib/common/02_help.Makefile
