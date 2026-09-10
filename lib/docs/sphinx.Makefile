#!make
# ─────────────────────────────────────────────────────────────────────────────
# docs/sphinx — build HTML documentation with Sphinx.
# DOCS_SRC = source dir, DOCS_OUT = build dir. Runs through $(RUN) for containers.
# ─────────────────────────────────────────────────────────────────────────────

.PHONY: docs-html docs-serve docs-clean

DOCS_SRC ?= docs
DOCS_OUT ?= docs/_build/html

docs-html: ## Build the HTML documentation
	$(call log-info,sphinx-build $(DOCS_SRC))
	@$(RUN) $(PYTHON) -m sphinx -b html $(DOCS_SRC) $(DOCS_OUT)

docs-serve: docs-html ## Build then serve the docs on localhost:8000
	@$(PYTHON) -m http.server --directory $(DOCS_OUT) 8000

docs-clean: ## Remove the built documentation
	@rm -rf $(DOCS_OUT)
