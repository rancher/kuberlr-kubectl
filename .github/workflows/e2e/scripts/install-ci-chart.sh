#!/bin/bash
set -e
set -x

source $(dirname $0)/entry
source $(dirname $0)/cluster-args.sh

cd $(dirname $0)/../../../..

helm upgrade --install --create-namespace -n cattle-ci-system rancher-kuberlr-kubectl-debug \
  --set global.kubectl.image.repository=${REPO:-rancher}/kuberlr-kubectl \
  --set global.kubectl.image.tag=${TAG:-dev} \
  ${cluster_args} \
  ${RANCHER_HELM_ARGS} ./build/charts/kuberlr-kubectl-test

echo "PASS: Kuberlr-Kubectl CI chart has been installed"
