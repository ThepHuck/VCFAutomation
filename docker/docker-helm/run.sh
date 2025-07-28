#!/bin/bash

echo "[INFO] Starting run script"

#set -e

echo "[INFO] Checking for required variable"
if [[ -z $OPEAVER || -z "$HFTOKEN" || -z "$VSPHERE_USERNAME" || -z "$VSPHERE_PASSWORD" || -z "$VKS_SUPERVISOR_IP" || -z "$VKS_NAMESPACE" || -z "$VKS_CLUSTER_NAME" || -z "$K8S_NAMESPACE" || -z "$HFMODEL" ]]; then
    echo "[ERROR] Missing required variable:"
    echo "OPEAVER, HFTOKEN, VSPHERE_USERNAME, VSPHERE_PASSWORD, VKS_SUPERVISOR_IP, VKS_NAMESPACE, VKS_CLUSTER_NAME, K8S_NAMESPACE, HFMODEL"
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

if [ "$APIBACKEND" = "true" ]; then
  echo "[INFO] Cloning git repo Enterprise-Inference... "
  /usr/bin/git clone https://github.com/opea-project/Enterprise-Inference

  echo "[INFO] Updating helm dependencies..."
  helm dependency update Enterprise-Inference/core/helm-charts/vllm

  echo "[INFO] deploying helm chart..."
  helm install xeon-llama-8b Enterprise-Inference/core/helm-charts/vllm \
  --set LLM_MODEL_ID="${HFMODEL}" \
  --set global.HUGGINGFACEHUB_API_TOKEN="${HFTOKEN}" \
  --values Enterprise-Inference/core/helm-charts/vllm/values.yaml \
  --namespace "${K8S_NAMESPACE}"

else

  echo "[INFO] Cloning git repo GenAIInfra $OPEAVER... "
  /usr/bin/git clone --branch "$OPEAVER" https://github.com/opea-project/GenAIInfra

  echo "[INFO] Updating helm dependencies..."
  /root/GenAIInfra/helm-charts/update_dependency.sh
  helm dependency update GenAIInfra/helm-charts/chatqna

  export MODELDIR=""
  export MODELNAME="$HFMODEL"

echo "[INFO] Building helm values file..."
cat <<EOF > /tmp/helm-values.yaml
global:
  HUGGINGFACEHUB_API_TOKEN: "$HFTOKEN"
  modelUseHostPath: "$MODELDIR"
vllm:
  LLM_MODEL_ID: "$MODELNAME"
EOF

  echo "[INFO] helm values file contents..."
  cat /tmp/helm-values.yaml

  echo "[INFO] deploying helm chart..."
  helm install chatqna GenAIInfra/helm-charts/chatqna \
  -f /tmp/helm-values.yaml \
  --namespace "${K8S_NAMESPACE}"

fi

echo "[INFO] Starting sshd"
exec /usr/sbin/sshd -D
