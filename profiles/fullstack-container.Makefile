# makefile-tier: fullstack
#!make
# ═════════════════════════════════════════════════════════════════════════════
# Profile: fullstack-container — Django + Node monorepo where the whole
# toolchain (lint/typecheck/test/install and the JS package manager) runs inside
# a docker-compose service $(RUN_SERVICE). Django management uses DJANGO_SERVICE.
# ═════════════════════════════════════════════════════════════════════════════

# ── Project overrides (set before includes) ─────────────────────────────────
# PROJECT_NAME   := my-app
# SRC_DIR        := backend
# RUN_SERVICE    := app
# DJANGO_SERVICE := web
# PKG            := pnpm

include lib/common/00_variables.Makefile
include lib/common/01_functions.Makefile
include lib/docker/runner.Makefile   # sets RUN → container execution
include lib/common/lifecycle.Makefile

include lib/python/quality.Makefile
include lib/python/tests.Makefile
include lib/python/deps.Makefile
include lib/python/clean.Makefile
include lib/django/manage.Makefile
include lib/js/node.Makefile
include lib/docker/compose.Makefile
include lib/quality/precommit.Makefile
include lib/git/github.Makefile
include lib/ops/backup.Makefile
include lib/ops/docs.Makefile

# ── Profile-local targets ────────────────────────────────────────────────────
.PHONY: config

config: ## Print the resolved project configuration
	@echo "PROJECT_NAME=$(PROJECT_NAME) SRC_DIR=$(SRC_DIR) RUN_SERVICE=$(RUN_SERVICE) PKG=$(PKG)"

include lib/common/02_help.Makefile
