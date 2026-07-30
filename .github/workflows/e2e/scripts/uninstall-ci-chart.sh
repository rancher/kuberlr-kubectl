#!/bin/bash
set -e
set -x

source $(dirname $0)/entry

cd $(dirname $0)/../../../..

helm uninstall --wait -n cattle-ci-system rancher-kuberlr-kubectl-debug

echo "PASS: Kuberlr-Kubectl Shell has been uninstalled"
