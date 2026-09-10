#!make
# ─────────────────────────────────────────────────────────────────────────────
# infra/helm — Helm chart lint / template / package / deploy.
# CHART = chart dir, RELEASE = release name, NAMESPACE, VALUES = values file.
# ─────────────────────────────────────────────────────────────────────────────

.PHONY: helm-lint helm-render helm-package helm-deploy helm-diff

CHART     ?= chart
RELEASE   ?= $(PROJECT_NAME)
NAMESPACE ?= default
VALUES    ?= $(CHART)/values.yaml

helm-lint: ## Lint the chart
	@helm lint $(CHART) -f $(VALUES)

helm-render: ## Render manifests locally (helm template)
	@helm template $(RELEASE) $(CHART) -n $(NAMESPACE) -f $(VALUES)

helm-package: ## Package the chart into a .tgz
	@helm package $(CHART)

helm-diff: ## Show the diff against the cluster (needs helm-diff plugin)
	@helm diff upgrade $(RELEASE) $(CHART) -n $(NAMESPACE) -f $(VALUES)

helm-deploy: check-defined-NAMESPACE ## Install/upgrade the release => [NAMESPACE={ns}]
	$(call confirm_destructive,Deploy $(RELEASE) to namespace $(NAMESPACE).)
	@helm upgrade --install $(RELEASE) $(CHART) -n $(NAMESPACE) -f $(VALUES)
