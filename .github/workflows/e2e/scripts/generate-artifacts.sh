#!/bin/bash
set -e
set -x

source $(dirname $0)/entry

cd $(dirname $0)/../../../..

case "${KUBERNETES_DISTRIBUTION_TYPE}" in
"k3s")
    components=(
        "k3s-server"
    )
    ;;
"rke")
    components=(
        "kube-controller-manager"
        "kube-scheduler"
        "kube-proxy"
        "kube-etcd"
    )
    ;;
"rke2")
    components=(
        "kube-controller-manager"
        "kube-scheduler"
        "kube-proxy"
        "kube-etcd"
    )
    ;;
*)
    echo "KUBERNETES_DISTRIBUTION_TYPE=${KUBERNETES_DISTRIBUTION_TYPE} is unknown"
    exit 1
esac

ARTIFACT_DIRECTORY=artifacts
DESCRIBE_DIRECTORY=${ARTIFACT_DIRECTORY}/described
MANIFEST_DIRECTORY=${ARTIFACT_DIRECTORY}/manifests
LOG_DIRECTORY=${ARTIFACT_DIRECTORY}/logs

# Manifests
mkdir -p ${MANIFEST_DIRECTORY}
mkdir -p ${MANIFEST_DIRECTORY}/daemonsets
mkdir -p ${MANIFEST_DIRECTORY}/deployments
mkdir -p ${MANIFEST_DIRECTORY}/jobs
mkdir -p ${MANIFEST_DIRECTORY}/statefulsets
mkdir -p ${MANIFEST_DIRECTORY}/pods

kubectl get namespaces -o yaml > ${MANIFEST_DIRECTORY}/namespaces.yaml || true
kubectl get services -A > ${MANIFEST_DIRECTORY}/services-list.txt || true

## cattle-ci-system ns manifests
kubectl get daemonset -n cattle-ci-system -o yaml > ${MANIFEST_DIRECTORY}/daemonsets/cattle-ci-system.yaml || true
kubectl get deployment -n cattle-ci-system -o yaml > ${MANIFEST_DIRECTORY}/deployments/cattle-ci-system.yaml || true
kubectl get job -n cattle-ci-system -o yaml > ${MANIFEST_DIRECTORY}/jobs/cattle-ci-system.yaml || true
kubectl get statefulset -n cattle-ci-system -o yaml > ${MANIFEST_DIRECTORY}/statefulsets/cattle-ci-system.yaml || true
kubectl get pods -n cattle-ci-system -o yaml > ${MANIFEST_DIRECTORY}/pods/cattle-ci-system.yaml || true

# Logs

## Rancher logs
mkdir -p ${LOG_DIRECTORY}/rancher

kubectl logs deployment/rancher-webhook -n cattle-system > ${LOG_DIRECTORY}/rancher/rancher_webhook.log || true
kubectl logs deployment/cattle-cluster-agent -n cattle-system > ${LOG_DIRECTORY}/rancher/cluster_agent.log || true
kubectl logs deployment/system-upgrade-controller -n cattle-system > ${LOG_DIRECTORY}/rancher/upgrade_controller.log || true

mkdir -p ${LOG_DIRECTORY}/rancher-monitoring

## Rancher Kubectl-Kuberlr
# TODO: decide what is worth collecting
