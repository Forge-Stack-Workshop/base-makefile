#!make
ifneq (,)
	$(error This Makefile requires GNU Make)
endif

include $(shell find . -type f -name "*.[Mm]akefile" -not -path "*/\.*" -exec echo " {}" \;)

.PHONY: all
# Toutes les commandes doivent être préfixées par @ pour ne pas s'afficher
.DEFAULT_GOAL := help

.PHONY: $(shell grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(shell find makefiles -name "*.Makefile" -type f) | sort | cut -d":" -f1 | tr "\n" " ")

help: ## Display this help message
	@echo "==================================================================="
	@echo "Padam AV Backoffice Development Environment"
	@echo "==================================================================="
	@echo ""
	@echo "Available commands:"
	@echo ""
	@for file in $$(ls makefiles/*.Makefile 2>/dev/null | sort); do \
		category=$$(basename $$file .Makefile); \
		case $$category in \
			gobal_rules) continue ;; \
			development) icon="⚡" ;; \
			docker) icon="🐳" ;; \
			quality) icon="🔍" ;; \
			tests) icon="🧪" ;; \
			*) icon="📦" ;; \
		esac; \
		echo "$$icon $$(echo $$category | tr '[:lower:]' '[:upper:]'):"; \
		grep -E '^[a-zA-Z_-]+(\([^)]*\))?:.*?## .*$$' $$file 2>/dev/null | sort | \
			awk 'BEGIN {FS = ":.*?## "}; { \
				cmd = $$1; \
				desc = $$2; \
				if (match(cmd, /\([^)]+\)/)) { \
					args = substr(cmd, RSTART+1, RLENGTH-2); \
					gsub(/\([^)]+\)/, "", cmd); \
					printf "  \033[36m%-20s\033[0m \033[33m%-15s\033[0m %s\n", cmd, args, desc; \
				} else { \
					printf "  \033[36m%-20s\033[0m \033[33m%-15s\033[0m %s\n", cmd, "", desc; \
				} \
			}'; \
		echo ""; \
	done
	@echo "📝 EXAMPLES:"
	@echo "  make dev              # Start development server"
	@echo "  make build-prod       # Build for production"
	@echo "  make format           # Format code"
	@echo "  make test             # Run tests"
	@echo ""
	@echo "Environment Variables:"
	@echo "  SERVICE=$(SERVICE)"
	@echo "  BACKEND_BRANCH=$(BACKEND_BRANCH)"
	@echo "  BACKEND_FOLDER=$(BACKEND_FOLDER)"
	@echo ""
	@echo "==================================================================="

help-%: ## Show detailed help for a specific command
	@echo "Showing help for: $*"
	@grep -A 5 -B 2 "^$*:" $(shell find makefiles -name "*.Makefile" -type f) || echo "Command '$*' not found"
