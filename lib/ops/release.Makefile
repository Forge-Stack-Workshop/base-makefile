#!make
# ─────────────────────────────────────────────────────────────────────────────
# ops/release — changelog + tag. Uses git-cliff for the changelog and GitVersion
# (or git describe) for the version. Never pushes automatically.
# ─────────────────────────────────────────────────────────────────────────────

.PHONY: changelog release-tag release

CHANGELOG_FILE ?= CHANGELOG.md

changelog: ## Regenerate the changelog with git-cliff
	@command -v git-cliff >/dev/null 2>&1 || { $(call log-error,git-cliff not installed); exit 1; }
	@git-cliff --output $(CHANGELOG_FILE)
	$(call log-ok,wrote $(CHANGELOG_FILE))

release-tag: ## Create an annotated tag from the computed version => [VERSION=x.y.z]
	@version="$(if $(VERSION),$(VERSION),$(shell dotnet-gitversion -showvariable SemVer 2>/dev/null))"; \
	[ -n "$$version" ] || { $(call log-error,set VERSION or install GitVersion); exit 1; }; \
	git tag -a "v$$version" -m "release v$$version" && echo "tagged v$$version (not pushed)"

release: changelog release-tag ## Regenerate changelog and tag (review, then push manually)
