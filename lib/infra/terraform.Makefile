#!make
# ─────────────────────────────────────────────────────────────────────────────
# infra/terraform — Terraform/OpenTofu workflow. TF = binary (terraform|tofu),
# TF_DIR = working directory. Apply is guarded by confirm_destructive.
# ─────────────────────────────────────────────────────────────────────────────

.PHONY: tf-init tf-fmt tf-validate tf-plan tf-apply tf-destroy

TF     ?= terraform
TF_DIR ?= infra

tf-init: ## Initialise the working directory
	@$(TF) -chdir=$(TF_DIR) init

tf-fmt: ## Format Terraform files
	@$(TF) -chdir=$(TF_DIR) fmt -recursive

tf-validate: ## Validate the configuration
	@$(TF) -chdir=$(TF_DIR) validate

tf-plan: ## Show an execution plan
	@$(TF) -chdir=$(TF_DIR) plan

tf-apply: ## Apply changes (guarded) => [CONFIRM=yes to skip prompt]
	$(call confirm_destructive,Apply Terraform changes in $(TF_DIR).)
	@$(TF) -chdir=$(TF_DIR) apply

tf-destroy: ## Destroy managed infrastructure (guarded)
	$(call confirm_destructive,DESTROY all Terraform-managed resources in $(TF_DIR).)
	@$(TF) -chdir=$(TF_DIR) destroy
