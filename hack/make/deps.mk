KUBECTL_VERSION1 := v1.29.12
KUBECTL1_SUM_arm64 ?= $(shell curl -L "https://dl.k8s.io/release/$(KUBECTL_VERSION1)/bin/linux/arm64/kubectl.sha256")
KUBECTL1_SUM_amd64 ?= $(shell curl -L "https://dl.k8s.io/release/$(KUBECTL_VERSION1)/bin/linux/amd64/kubectl.sha256")

KUBECTL_VERSION2 := v1.30.8
KUBECTL2_SUM_arm64 ?= $(shell curl -L "https://dl.k8s.io/release/$(KUBECTL_VERSION2)/bin/linux/arm64/kubectl.sha256")
KUBECTL2_SUM_amd64 ?= $(shell curl -L "https://dl.k8s.io/release/$(KUBECTL_VERSION2)/bin/linux/amd64/kubectl.sha256")

KUBECTL_VERSION3 := v1.31.4
KUBECTL3_SUM_arm64 ?= $(shell curl -L "https://dl.k8s.io/release/$(KUBECTL_VERSION3)/bin/linux/arm64/kubectl.sha256")
KUBECTL3_SUM_amd64 ?= $(shell curl -L "https://dl.k8s.io/release/$(KUBECTL_VERSION3)/bin/linux/amd64/kubectl.sha256")

KUBECTL_VERSION4 := v1.32.0
KUBECTL4_SUM_arm64 ?= $(shell curl -L "https://dl.k8s.io/release/$(KUBECTL_VERSION4)/bin/linux/arm64/kubectl.sha256")
KUBECTL4_SUM_amd64 ?= $(shell curl -L "https://dl.k8s.io/release/$(KUBECTL_VERSION4)/bin/linux/amd64/kubectl.sha256")

KUBECTL1 := "$(KUBECTL_VERSION1):$(KUBECTL1_SUM_arm64):$(KUBECTL1_SUM_amd64)"
KUBECTL2 := "$(KUBECTL_VERSION2):$(KUBECTL2_SUM_arm64):$(KUBECTL2_SUM_amd64)"
KUBECTL3 := "$(KUBECTL_VERSION3):$(KUBECTL3_SUM_arm64):$(KUBECTL3_SUM_amd64)"
KUBECTL4 := "$(KUBECTL_VERSION4):$(KUBECTL4_SUM_arm64):$(KUBECTL4_SUM_amd64)"

KUBECTL_INFO_LIST := "$(KUBECTL1) $(KUBECTL2) $(KUBECTL3) $(KUBECTL4)"

# Reduces the code duplication on Makefile by keeping all args into a single variable.
IMAGE_ARGS := --build-arg KUBECTL_INFO_LIST=$(KUBECTL_INFO_LIST)