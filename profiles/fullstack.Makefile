# makefile-tier: fullstack
#!make
# ═════════════════════════════════════════════════════════════════════════════
# Profile: fullstack — Dockerized Django backend + Node front-end in one repo.
# Backend targets are the bare canonical names (lint/test/…); the front-end is
# under web-* (web-lint/web-build/…). For an all-in-container variant, use
# Makefile.fullstack-container.
# ═════════════════════════════════════════════════════════════════════════════

# ── Project overrides (set before includes) ─────────────────────────────────
# PROJECT_NAME   := my-app
# SRC_DIR        := backend
# DJANGO_SERVICE := web
# PKG            := pnpm

include lib/common/00_variables.Makefile
include lib/common/01_functions.Makefile
include lib/common/lifecycle.Makefile

# Backend (bare canonical names)
include lib/python/quality.Makefile
include lib/python/tests.Makefile
include lib/python/deps.Makefile
include lib/python/clean.Makefile
include lib/django/manage.Makefile

# Front-end (web-* names)
include lib/js/node.Makefile

# Infra + ops + quality
include lib/docker/compose.Makefile
include lib/quality/precommit.Makefile
include lib/git/github.Makefile
include lib/ops/backup.Makefile
include lib/ops/docs.Makefile

# ── Profile-local targets ────────────────────────────────────────────────────
.PHONY: config

config: ## Print the resolved project configuration
	@echo "PROJECT_NAME=$(PROJECT_NAME) SRC_DIR=$(SRC_DIR) PKG=$(PKG) DJANGO_SERVICE='$(DJANGO_SERVICE)'"

include lib/common/02_help.Makefile
