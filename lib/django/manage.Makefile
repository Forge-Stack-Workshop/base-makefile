#!make
# ─────────────────────────────────────────────────────────────────────────────
# django/manage — Django management commands.
# MANAGE runs manage.py: host interpreter by default, or inside a compose
# service when DJANGO_SERVICE is set (e.g. DJANGO_SERVICE=web).
# ─────────────────────────────────────────────────────────────────────────────

.PHONY: manage migrate makemigrations makemigrations-check showmigrations django-shell superuser

MANAGE_PY      ?= manage.py
DJANGO_SERVICE ?=

ifeq ($(strip $(DJANGO_SERVICE)),)
MANAGE = $(RUN) $(PYTHON) $(MANAGE_PY)
else
MANAGE = $(DOCKER_COMPOSE) exec -T $(DJANGO_SERVICE) python $(MANAGE_PY)
endif

manage: check-defined-cmd ## Run any manage.py command => [cmd="migrate --plan"]
	@$(MANAGE) $(cmd)

migrate: ## Apply database migrations
	@$(MANAGE) migrate

makemigrations: ## Create migrations => [app={label}]
	@$(MANAGE) makemigrations $(app)

makemigrations-check: ## Fail if models changed without a migration
	@$(MANAGE) makemigrations --check --dry-run

showmigrations: ## Show migration state => [app={label}]
	@$(MANAGE) showmigrations $(app)

django-shell: ## Open the Django shell
	@$(MANAGE) shell

superuser: ## Create a superuser interactively
	@$(MANAGE) createsuperuser
