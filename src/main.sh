#!/bin/bash

function main {
  ./params.sh
  kfctl apply -f kfctl_k8s_istio.v1.0.1.yaml
  kubectl -n kubeflow patch --type=json gateway kubeflow-gateway -p '[{"op":"replace","path":"/spec/selector/istio","value":"ingressgateway-kubeflow"}]'
  kubectl apply -f patches/kubeflow.yml
  kubectl annotate mutatingwebhookconfigurations.admissionregistration.k8s.io admission-webhook-mutating-webhook-configuration certmanager.k8s.io/inject-ca-from=kubeflow/admission-webhook-cert --overwrite
}

main "${*}"
