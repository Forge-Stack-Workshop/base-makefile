# makefile-tier: infra
#!make
# ═════════════════════════════════════════════════════════════════════════════
# Profile: infra — Helm + Terraform infrastructure repo.
# Exposes the canonical core mapped onto helm/terraform operations, plus the
# domain targets (helm-*, tf-*).
#   make lint            # helm lint + terraform validate
#   make helm-deploy NAMESPACE=prod
# ═════════════════════════════════════════════════════════════════════════════

# ── Project overrides (set before includes) ─────────────────────────────────
# PROJECT_NAME := my-infra
# CHART        := chart
# TF_DIR       := infra

include lib/common/00_variables.Makefile
include lib/common/01_functions.Makefile

include lib/infra/helm.Makefile
include lib/infra/terraform.Makefile
include lib/quality/precommit.Makefile
include lib/git/github.Makefile

# ── Canonical core mapped onto infra operations (chrysa naming policy) ────────
.PHONY: install dev lint format test build clean

install: ## Fetch chart dependencies and init Terraform
	@helm dependency update $(CHART) 2>/dev/null || true
	@$(TF) -chdir=$(TF_DIR) init -input=false 2>/dev/null || true

dev: ## Render manifests locally (dry preview)
	@$(MAKE) --no-print-directory helm-render

lint: helm-lint tf-validate ## Lint charts and validate Terraform

format: tf-fmt ## Format Terraform files

test: ## Render charts as a smoke check
	@helm template $(RELEASE) $(CHART) -n $(NAMESPACE) -f $(VALUES) >/dev/null && echo "render OK"

build: helm-package ## Package the chart

clean: ## Remove packaged charts and Terraform state caches
	@rm -f $(PROJECT_NAME)-*.tgz
	@rm -rf $(TF_DIR)/.terraform

include lib/common/02_help.Makefile
