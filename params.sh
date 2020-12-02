#!/bin/bash

export CLUSTER_NAME="${CLUSTER_NAME:=k8s-cancentral-01-default-aks}"
export OIDC_PROVIDER="${OIDC_PROVIDER:-default}"
export OIDC_REDIRECT_URI="${OIDC_REDIRECT_URI:-default}"
export OIDC_AUTH_URL="${OIDC_AUTH_URL:-default}"
export CLIENT_ID="${CLIENT_ID:-default}"
export APPLICATION_SECRET="${APPLICATION_SECRET:-default}"
export CONFIG_FILE="${CONFIG_FILE:-kfctl_azure.yaml}"

yq w -i ${CONFIG_FILE} 'metadata.clusterName' ${CLUSTER_NAME}

$(cat <<EOF >kustomize/oidc-authservice/configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: oidc-authservice-parameters
  namespace: istio-system
data:
  application_secret: '${APPLICATION_SECRET}'
  client_id: ${CLIENT_ID}
  namespace: istio-system
  oidc_auth_url: ${OIDC_AUTH_URL}
  oidc_provider: ${OIDC_PROVIDER}
  oidc_redirect_uri: ${OIDC_REDIRECT_URI}
  skip_auth_uri: ""
  userid-header: kubeflow-userid
  userid-prefix: ""
EOF
)
