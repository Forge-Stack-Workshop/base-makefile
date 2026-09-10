#!make
# ─────────────────────────────────────────────────────────────────────────────
# docker/compose — docker-compose lifecycle. `service=` targets one service.
# Assumes a compose file resolvable by `$(DOCKER_COMPOSE)` in the project root.
# ─────────────────────────────────────────────────────────────────────────────

.PHONY: docker-build docker-up docker-down docker-ps docker-logs docker-sh

docker-build: ## Build images => [service={name}]
	$(call log-info,docker compose build $(service))
	@$(DOCKER_COMPOSE) build $(service)

docker-up: ## Start services in the background => [service={name}]
	@$(DOCKER_COMPOSE) up -d $(service)

docker-down: ## Stop and remove containers, networks
	@$(DOCKER_COMPOSE) down

docker-ps: ## List running services
	@$(DOCKER_COMPOSE) ps

docker-logs: check-defined-service ## Follow one service's logs => [service={name}]
	@$(DOCKER_COMPOSE) logs --no-log-prefix --follow $(service)

docker-sh: check-defined-service ## Open a shell in a running service => [service={name}]
	@$(DOCKER_COMPOSE) exec $(service) bash
