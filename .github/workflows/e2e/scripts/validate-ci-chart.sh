#!/bin/bash
set -e
set -x

source $(dirname $0)/entry

cd $(dirname $0)/../../../..

if ! kubectl -n cattle-ci-system rollout status deployment kuberlr-kubectl-shell --timeout="${KUBECTL_WAIT_TIMEOUT}"; then
    echo "ERROR: Kuberlr-Kubectl Shell did not roll out"
    exit 1
fi

echo "PASS: Kuberlr-Kubectl Shell is up and running"

if ! kubectl -n cattle-ci-system rollout status deployment kuberlr-kubectl-action --timeout="${KUBECTL_WAIT_TIMEOUT}"; then
    echo "ERROR: Kuberlr-Kubectl Shell did not roll out"
    exit 1
fi

echo "PASS: Kuberlr-Kubectl Shell is up and running"
