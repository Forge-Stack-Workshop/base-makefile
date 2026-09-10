#!make
# ─────────────────────────────────────────────────────────────────────────────
# common/00_variables — global, overridable configuration
# Loaded first (00_ prefix). Every value here is overridable on the command
# line: `make <target> PYTHON=python3.14`. Keep alphabetical within each block.
# ─────────────────────────────────────────────────────────────────────────────

# Fail fast and loud: undefined variables and errored pipes stop the build.
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
MAKEFLAGS += --warn-undefined-variables --no-builtin-rules

# ── Identity ────────────────────────────────────────────────────────────────
PROJECT_NAME ?= $(notdir $(CURDIR))

# ── Tooling (host commands) ─────────────────────────────────────────────────
DOCKER_COMPOSE ?= docker compose
PRE_COMMIT     ?= pre-commit
PYTHON         ?= python3

# ── Execution mode: host (default) or container ─────────────────────────────
# RUN is prepended before every tool invocation in the bricks. Empty = run on
# the host. Include lib/docker/runner.Makefile (or a *-container profile) to set
# it to a `docker compose run` wrapper so the whole ecosystem runs in a service.
RUN ?=

# ── Paths ───────────────────────────────────────────────────────────────────
REPORTS_DIR ?= reports
SRC_DIR     ?= .

# ── User-overridable target parameters ──────────────────────────────────────
# Passed on the command line, e.g. `make tests PYTEST_ARGS="-k foo"`.
# Alphabetical order.
files       ?=
PYTEST_ARGS ?=
service     ?=

# ── Colors (disabled when not a TTY) ────────────────────────────────────────
ifeq ($(shell test -t 1 && echo tty),tty)
COLOR_RESET := \033[0m
COLOR_BOLD  := \033[1m
COLOR_BLUE  := \033[34m
COLOR_GREEN := \033[32m
COLOR_RED   := \033[31m
else
COLOR_RESET :=
COLOR_BOLD  :=
COLOR_BLUE  :=
COLOR_GREEN :=
COLOR_RED   :=
endif
