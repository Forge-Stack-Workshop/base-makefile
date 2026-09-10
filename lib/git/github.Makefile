#!make
# ─────────────────────────────────────────────────────────────────────────────
# git/github — git hygiene + GitHub CLI helpers. `gh` optional.
# ─────────────────────────────────────────────────────────────────────────────

.PHONY: git-clean-check version pr-create pr-view

DEFAULT_BRANCH ?= main

git-clean-check: ## Fail if the working tree has uncommitted changes
	@git diff --quiet && git diff --cached --quiet \
		|| { $(call log-error,working tree is dirty); exit 1; }

version: ## Print the version (GitVersion if present, else git describe)
	@if command -v dotnet-gitversion >/dev/null 2>&1; then \
		dotnet-gitversion -showvariable SemVer; \
	else \
		git describe --tags --always --dirty; \
	fi

pr-create: ## Open a PR against the default branch (requires gh) => [title="..."]
	@gh pr create --base $(DEFAULT_BRANCH) $(if $(title),--title "$(title)",--fill)

pr-view: ## Show the PR for the current branch (requires gh)
	@gh pr view
