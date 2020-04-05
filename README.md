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

4. To correct an issue with using an older cert-manager run the following commands.

```sh
kubectl apply -f patches/kubeflow.yml
```

5. Run the following commands to deploy and configure Kubeflow.

```sh
kubectl apply
kubectl scale statefulset -n kubeflow admission-webhook-bootstrap-stateful-set --replicas=0
kubectl -n kubeflow patch --type=json gateway kubeflow-ingressgateway -p '[{"op":"replace","path":"/spec/selector/istio","value":"ingressgateway-kubeflow"}]'
```
