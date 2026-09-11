#!make
# ─────────────────────────────────────────────────────────────────────────────
# docker/build — build, tag and push an application image.
# IMAGE = repo/name, TAG = version (default: git describe). Set REGISTRY to push.
# ─────────────────────────────────────────────────────────────────────────────

.PHONY: image-build image-push image-tag

IMAGE      ?= $(PROJECT_NAME)
TAG        ?= $(shell git describe --tags --always --dirty 2>/dev/null || echo latest)
DOCKERFILE ?= Dockerfile
REGISTRY   ?=

image-build: ## Build the application image => [TAG={version}]
	$(call log-info,docker build $(IMAGE):$(TAG))
	@docker build -f $(DOCKERFILE) -t $(IMAGE):$(TAG) .

image-tag: ## Tag the built image for the registry => [REGISTRY={host}]
	@$(if $(REGISTRY),,$(error REGISTRY is required to tag for a registry))
	@docker tag $(IMAGE):$(TAG) $(REGISTRY)/$(IMAGE):$(TAG)

image-push: image-tag ## Push the image to the registry => [REGISTRY={host}]
	@docker push $(REGISTRY)/$(IMAGE):$(TAG)
