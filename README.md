# Kubeflow Manifests

The installation manifest for Kubeflow.

## Steps

1. Run the following commands to pass the OIDC parameters to the `kfctl` template

```sh
# Note will need to populate the .env file
source .env
./params.sh
```

2. Run `kfctl` to generate the kustomize folder

```sh
kfctl build -f kfctl_k8s_istio.v1.0.1.yaml
```

3. In the generated kustomize folder make the following corrections.

In `kustomize/oidc-authservice/base/statefulset.yaml`

```yaml
spec:
  containers:
  - name: authservice
    image: <acr-registry>.azurecr.io/oidc-authservice:latest
    imagePullPolicy: Always
    imagePullSecrets:
    - name: <acr-registry>-registry-connection
```

In `kustomize/oidc-authservice/base/envoy-filter.yaml`

```yaml
kind: EnvoyFilter
metadata:
  name: authn-filter
spec:
  workloadLabels:
    istio: ingressgateway-kubeflow
```

In `kustomize/pipelines-ui/base/kustomization.yaml`

```yaml
images:
- name: gcr.io/ml-pipeline/frontend
  newTag: 0.2.5
  newName: gcr.io/ml-pipeline/frontend
```

In `kustomize/notebook-controller/base/deployment.yaml`

```yaml
env:
  ...
  - name: ENABLE_CULLING
    value: "true"
  - name: IDLE_TIME
    value: "1440"
  - name: CULLING_CHECK_PERIOD
    value: "1"
```

4. Run the following commands to deploy and configure Kubeflow.

```sh
kfctl apply
kubectl -n kubeflow patch --type=json gateway kubeflow-gateway -p '[{"op":"replace","path":"/spec/selector/istio","value":"ingressgateway-kubeflow"}]'
kubectl apply -f patches/kubeflow.yml
kubectl annotate mutatingwebhookconfigurations.admissionregistration.k8s.io admission-webhook-mutating-webhook-configuration certmanager.k8s.io/inject-ca-from=kubeflow/admission-webhook-cert --overwrite
```
