KUBECTL29_VERSION := v1.29.12
KUBECTL29_SUM_arm64 ?= $(shell curl -L "https://dl.k8s.io/release/$(KUBECTL29_VERSION)/bin/linux/arm64/kubectl.sha256")
KUBECTL29_SUM_amd64 ?= $(shell curl -L "https://dl.k8s.io/release/$(KUBECTL29_VERSION)/bin/linux/amd64/kubectl.sha256")

KUBECTL30_VERSION := v1.30.8
KUBECTL30_SUM_arm64 ?= $(shell curl -L "https://dl.k8s.io/release/$(KUBECTL30_VERSION)/bin/linux/arm64/kubectl.sha256")
KUBECTL30_SUM_amd64 ?= $(shell curl -L "https://dl.k8s.io/release/$(KUBECTL30_VERSION)/bin/linux/amd64/kubectl.sha256")

KUBECTL31_VERSION := v1.31.4
KUBECTL31_SUM_arm64 ?= $(shell curl -L "https://dl.k8s.io/release/$(KUBECTL31_VERSION)/bin/linux/arm64/kubectl.sha256")
KUBECTL31_SUM_amd64 ?= $(shell curl -L "https://dl.k8s.io/release/$(KUBECTL31_VERSION)/bin/linux/amd64/kubectl.sha256")

KUBECTL32_VERSION := v1.32.0
KUBECTL32_SUM_arm64 ?= $(shell curl -L "https://dl.k8s.io/release/$(KUBECTL32_VERSION)/bin/linux/arm64/kubectl.sha256")
KUBECTL32_SUM_amd64 ?= $(shell curl -L "https://dl.k8s.io/release/$(KUBECTL32_VERSION)/bin/linux/amd64/kubectl.sha256")

KUBECTL29 := "$(KUBECTL29_VERSION):$(KUBECTL29_SUM_arm64):$(KUBECTL29_SUM_amd64)"
KUBECTL30 := "$(KUBECTL30_VERSION):$(KUBECTL30_SUM_arm64):$(KUBECTL30_SUM_amd64)"
KUBECTL31 := "$(KUBECTL31_VERSION):$(KUBECTL31_SUM_arm64):$(KUBECTL31_SUM_amd64)"
KUBECTL32 := "$(KUBECTL32_VERSION):$(KUBECTL32_SUM_arm64):$(KUBECTL32_SUM_amd64)"

KUBECTL_VERSION_INFO := "$(KUBECTL29) $(KUBECTL30) $(KUBECTL31) $(KUBECTL32)"

# Reduces the code duplication on Makefile by keeping all args into a single variable.
IMAGE_ARGS := --build-arg KUBECTL_VERSION_INFO=$(KUBECTL_VERSION_INFO)