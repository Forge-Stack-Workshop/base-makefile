# makefile-tier: python-app
#!make
# ═════════════════════════════════════════════════════════════════════════════
# Profile: django — a Dockerized Django/DRF app.
# Usage: copy `lib/` into your project and this file as `Makefile` at the root.
#   make docker-up
#   make migrate            # runs inside DJANGO_SERVICE when set
#   make ci                 # lint + typecheck + test
# ═════════════════════════════════════════════════════════════════════════════

# ── Project overrides (set before includes) ─────────────────────────────────
# PROJECT_NAME   := my-api
# SRC_DIR        := myapp
# DJANGO_SERVICE := web
# DEFAULT_BRANCH := develop
# DEV_CMD        := $(DOCKER_COMPOSE) up

include lib/common/00_variables.Makefile
include lib/common/01_functions.Makefile
include lib/common/lifecycle.Makefile

include lib/python/quality.Makefile
include lib/python/tests.Makefile
include lib/python/deps.Makefile
include lib/python/clean.Makefile
include lib/docker/compose.Makefile
include lib/django/manage.Makefile
include lib/quality/precommit.Makefile
include lib/git/github.Makefile

# ── Profile-local targets ────────────────────────────────────────────────────
.PHONY: config

config: ## Print the resolved project configuration
	@echo "PROJECT_NAME=$(PROJECT_NAME) SRC_DIR=$(SRC_DIR) DJANGO_SERVICE='$(DJANGO_SERVICE)'"

include lib/common/02_help.Makefile
