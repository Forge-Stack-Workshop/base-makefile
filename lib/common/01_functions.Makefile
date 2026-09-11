#!make
# ─────────────────────────────────────────────────────────────────────────────
# common/01_functions — reusable macros. No targets here.
# Depends on common/00_variables (colors). Loaded before any category brick.
# ─────────────────────────────────────────────────────────────────────────────

# log-info / log-error: consistent, colored logging. Use as a recipe line:
#   $(call log-info,building image)
log-info  = @printf "$(COLOR_BLUE)▶ %s$(COLOR_RESET)\n" "$(1)"
log-error = @printf "$(COLOR_RED)✖ %s$(COLOR_RESET)\n" "$(1)" >&2
log-ok    = @printf "$(COLOR_GREEN)✔ %s$(COLOR_RESET)\n" "$(1)"

# check_defined: fail with a clear message if a required variable is empty.
# Pair with the `check-defined-%` target (see below) as a prerequisite:
#   deploy: check-defined-env ## Deploy => [env={staging|prod}]
check_defined = \
    $(strip $(foreach 1,$1,$(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
    $(if $(value $1),,$(error Undefined variable '$1'$(if $2, ($2))$(if $(value @), required by target '$@')))

# confirm_destructive: interactive y/N gate before an irreversible action.
# $(1) = human-readable description. Skipped when CONFIRM=yes is passed.
define confirm_destructive
	@if [ "$(CONFIRM)" != "yes" ]; then \
		printf "$(COLOR_RED)⚠️  %s$(COLOR_RESET) Continue? [y/N] " "$(1)"; \
		read -r answer; \
		case "$$answer" in [yY]*) ;; *) echo "Aborted."; exit 1 ;; esac; \
	fi
endef

# run_python: run a Python command with the configured interpreter, honouring the
# execution mode (RUN is empty on host, a container wrapper in container mode).
#   $(call run_python,-m pytest)
run_python = $(RUN) $(PYTHON) $(1)

# run_in_service: run a command inside a running docker-compose service.
#   $(call run_in_service,web,pytest -q)
define run_in_service
	@$(DOCKER_COMPOSE) exec -T $(1) $(2)
endef
