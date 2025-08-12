#!/bin/bash

echo "[INFO] Starting run script"

#set -e

echo "[INFO] Checking for required variable"
if [[ -z $CHARTNAME || -z "$CHARTREPO" || -z "$VSPHERE_USERNAME" || -z "$VSPHERE_PASSWORD" || -z "$VKS_SUPERVISOR_IP" || -z "$VKS_NAMESPACE" || -z "$VKS_CLUSTER_NAME" || -z "$K8S_NAMESPACE" || -z "$CHARTVERSION" ]]; then
    echo "[ERROR] Missing required variable:"
    echo "CHARTNAME, CHARTREPO, VSPHERE_USERNAME, VSPHERE_PASSWORD, VKS_SUPERVISOR_IP, VKS_NAMESPACE, VKS_CLUSTER_NAME, K8S_NAMESPACE, CHARTVERSION"
    exit 1
fi

echo "[INFO] Logging into VKS... "
expect <<EOF
set timeout 20
spawn /bin/kubectl vsphere login --insecure-skip-tls-verify \
--server=${VKS_SUPERVISOR_IP} \
--tanzu-kubernetes-cluster-namespace "${VKS_NAMESPACE}" \
--tanzu-kubernetes-cluster-name "${VKS_CLUSTER_NAME}" \
--vsphere-username "${VSPHERE_USERNAME}"
expect "Password:"
sleep 3
send "${VSPHERE_PASSWORD}\r"
expect eof
EOF

echo "[INFO] Adding helm repo $CHARTREPO... "
# Install Helm chart
helm repo add $CHARTREPO
helm repo update

echo "[INFO] Deploying $CHARTNAME to $K8S_NAMESPACE... "
helm install $CHARTNAME --version $CHARTVERSION -n $K8S_NAMESPACE

echo "[INFO] Starting sshd"
exec /usr/sbin/sshd -D
