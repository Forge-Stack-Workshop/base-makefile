# makefile-tier: lib
#!make
# ═════════════════════════════════════════════════════════════════════════════
# Profile: unity — a Unity project (tests + build via the Unity CLI).
# Exposes Unity operations under the canonical target names. Set UNITY to your
# Unity executable path (or provide it in CI).
#   make test          # EditMode tests
#   make build UNITY_PLATFORM=StandaloneWindows64
# ═════════════════════════════════════════════════════════════════════════════

# ── Project overrides (set before includes) ─────────────────────────────────
# PROJECT_NAME := my-game
# UNITY        := /opt/unity/Editor/Unity

include lib/common/00_variables.Makefile
include lib/common/01_functions.Makefile

include lib/unity/unity.Makefile
include lib/quality/precommit.Makefile
include lib/git/github.Makefile

# ── Canonical core mapped onto Unity operations (chrysa naming policy) ────────
.PHONY: install dev lint format typecheck test test-cov build clean ci

install: ## Restore packages (Unity resolves them on first open)
	@echo "Unity restores packages on project open — nothing to install here."

dev: ## Open the project in the Unity editor
	@$(UNITY) -projectPath $(UNITY_PROJECT)

lint: ## Lint C# (dotnet format --verify-no-changes if available)
	@command -v dotnet >/dev/null 2>&1 && dotnet format --verify-no-changes || echo "dotnet not available — skipping lint"

format: ## Format C# (dotnet format if available)
	@command -v dotnet >/dev/null 2>&1 && dotnet format || echo "dotnet not available — skipping format"

typecheck: ## Compile scripts (Unity compiles on build/test; no separate step)
	@echo "C# is compiled by Unity during test/build — no separate typecheck."

test: unity-tests       ## Run EditMode tests
test-cov: unity-tests   ## Run tests (coverage via the Unity Code Coverage package)
build: unity-build      ## Build the player
ci: lint test           ## Aggregate CI gate: lint + test

clean: ## Remove Unity's generated Library/Temp/obj directories
	@rm -rf Library Temp obj

include lib/common/02_help.Makefile
