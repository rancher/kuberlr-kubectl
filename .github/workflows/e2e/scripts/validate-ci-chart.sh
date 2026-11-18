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

# The image has to start through its own entrypoint, with only arguments.
if ! kubectl -n cattle-ci-system wait --for=condition=complete job/kuberlr-kubectl-entrypoint --timeout="${KUBECTL_WAIT_TIMEOUT}"; then
    echo "ERROR: Kuberlr-Kubectl did not run through its default entrypoint"
    kubectl -n cattle-ci-system describe job/kuberlr-kubectl-entrypoint || true
    kubectl -n cattle-ci-system describe pod -l app=kuberlr-kubectl-entrypoint || true
    kubectl -n cattle-ci-system logs -l app=kuberlr-kubectl-entrypoint --tail=50 || true
    exit 1
fi

echo "PASS: Kuberlr-Kubectl runs through its default entrypoint"
