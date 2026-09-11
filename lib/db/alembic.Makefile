#!make
# ─────────────────────────────────────────────────────────────────────────────
# db/alembic — Alembic migrations for SQLAlchemy/FastAPI services.
# Runs through $(RUN) so migrations can execute inside a container.
# ─────────────────────────────────────────────────────────────────────────────

.PHONY: db-upgrade db-downgrade db-revision db-current db-history

db-upgrade: ## Apply migrations up to a revision => [REV=head]
	@$(RUN) $(PYTHON) -m alembic upgrade $(if $(REV),$(REV),head)

db-downgrade: ## Revert migrations down to a revision => [REV=-1]
	$(call confirm_destructive,Downgrade the database schema.)
	@$(RUN) $(PYTHON) -m alembic downgrade $(if $(REV),$(REV),-1)

db-revision: check-defined-message ## Autogenerate a revision => [message="..."]
	@$(RUN) $(PYTHON) -m alembic revision --autogenerate -m "$(message)"

db-current: ## Show the current revision
	@$(RUN) $(PYTHON) -m alembic current

db-history: ## Show the migration history
	@$(RUN) $(PYTHON) -m alembic history
