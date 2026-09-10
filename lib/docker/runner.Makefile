#!make
# ─────────────────────────────────────────────────────────────────────────────
# docker/runner — container execution mode.
# Include this AFTER common/00_variables to make every $(RUN)-routed tool
# (ruff, mypy, pytest, pip…) run inside a docker-compose service instead of the
# host. Assumes a service named $(RUN_SERVICE) with the repo bind-mounted.
# Host UID/GID are passed so files written into the mount stay developer-owned.
# ─────────────────────────────────────────────────────────────────────────────

.PHONY: runner-shell

RUN_SERVICE ?= app
RUN_USER    ?= $(shell id -u):$(shell id -g)
RUN         := $(DOCKER_COMPOSE) run --rm --user $(RUN_USER) $(RUN_SERVICE)

runner-shell: ## Open an interactive shell in the runner service
	@$(DOCKER_COMPOSE) run --rm $(RUN_SERVICE) bash
