#!/bin/bash

set -e
set -x

echo "This test will simply list all daemonsets on the cluster..."
kubectl get daemonset -A