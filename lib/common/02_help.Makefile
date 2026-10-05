#!make
# ─────────────────────────────────────────────────────────────────────────────
# common/02_help — auto-generated help + shared meta targets.
# Parses `## description` comments across every included *.Makefile, grouped by
# the file (category) they live in. This is the .DEFAULT_GOAL.
# Target help syntax:  target: prereqs ## Description => [var={what}]
# ─────────────────────────────────────────────────────────────────────────────

.DEFAULT_GOAL := help

# Every documented target across all included bricks is phony by construction.
# This single declaration is why the bricks don't repeat `.PHONY` for the help
# meta-targets — they only declare their own targets once, at the top of each file.
.PHONY: $(shell grep -hE '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) 2>/dev/null | cut -d: -f1 | sort -u | tr '\n' ' ') help help-%

help: ## Show this help, grouped by category
	@printf "$(COLOR_BOLD)%s$(COLOR_RESET)\n\n" "$(PROJECT_NAME) — available targets"
	@for makefile in $(MAKEFILE_LIST); do \
		targets=$$(grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' "$$makefile" 2>/dev/null || true); \
		[ -z "$$targets" ] && continue; \
		category=$$(basename "$$makefile" | sed -E 's/^[0-9]+_//; s/\.[Mm]akefile$$//'); \
		printf "$(COLOR_BLUE)%s$(COLOR_RESET)\n" "$$category"; \
		printf "%s\n" "$$targets" | sort | awk 'BEGIN{FS=":.*?## "}{printf "  $(COLOR_GREEN)%-22s$(COLOR_RESET) %s\n", $$1, $$2}'; \
		printf "\n"; \
	done

help-%: ## Show the definition of one target: make help-<target>
	@grep -rnE "^$*:" $(MAKEFILE_LIST) 2>/dev/null || echo "Target '$*' not found."

# check-defined-<VAR>: usable as a prerequisite to enforce a required variable.
check-defined-%:
	@:$(call check_defined, $*, required)
