ifeq ($(VERSION),)
VERSION := $(shell ./scripts/version --short VERSION)
endif

ifeq ($(TAG),)
TAG := $(shell ./scripts/version --short TAG)
endif

# CACHE_KEY is passed to the Dockerfile to invalidate the cache of the layers
# that fetch RPMs. It combines the commit AND every tag pointing at HEAD, so
# tagging an already-built commit (or adding another tag) forces a rebuild
# that picks up newer packages. Unlike VERSION, it is never either/or.
CACHE_KEY = $(shell git rev-parse --short HEAD)-$(shell git tag -l --contains HEAD | paste -sd, -)

RUNNER := docker
IMAGE_BUILDER := $(RUNNER) buildx
MACHINE := rancher

# Define the target platforms that can be used across the ecosystem.
# Note that what would actually be used for a given project will be
# defined in TARGET_PLATFORMS, and must be a subset of the below:
DEFAULT_PLATFORMS := linux/amd64,linux/arm64

.PHONY: help
help: ## display Makefile's help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

buildx-machine: ## create rancher dockerbuildx machine targeting platform defined by DEFAULT_PLATFORMS.
	@docker buildx ls | grep $(MACHINE) || \
		docker buildx create --name=$(MACHINE) --platform=$(DEFAULT_PLATFORMS)