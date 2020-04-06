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
    ports:
    - name: http-api
      containerPort: 8080
    env:
      - name: USERID_HEADER
        value: $(userid-header)
      - name: USERID_PREFIX
        value: $(userid-prefix)
      - name: USERID_CLAIM
        value: preferred_username
      - name: OIDC_PROVIDER
        value: $(oidc_provider)
      - name: OIDC_AUTH_URL
        value: $(oidc_auth_url)
      - name: OIDC_SCOPES
        value: "profile email"
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

In `kustomize/jupyter-web-app/base/config-map.yaml`

```yaml
spawnerFormDefaults:
  image:
    # The container Image for the user's Jupyter Notebook
    # If readonly, this value must be a member of the list below
    value: <acr-registry>.azurecr.io/tensorflow-2.1.0-notebook-cpu:master
    # The list of available standard container Images
    options:
      - <acr-registry>.azurecr.io/tensorflow-2.1.0-notebook-cpu:master
      - <acr-registry>.azurecr.io/tensorflow-2.1.0-notebook-gpu:master
      - <acr-registry>.azurecr.io/r-notebook:master
    # By default, custom container Images are allowed
    # Uncomment the following line to only enable standard container Images
    readOnly: true
```

In `kustomize/webhook/base/deployment.yaml`

```yaml
spec:
  template:
    spec:
      containers:
      - image: <acr-registry>.azurecr.io/admission-webhook:latest
        name: admission-webhook
        volumeMounts:
        - mountPath: /etc/webhook/certs
          name: webhook-cert
          readOnly: true
      imagePullSecrets:
        - name: <acr-registry>-registry-connection
```

4. Run the following commands to deploy and configure Kubeflow.

```sh
kfctl apply
kubectl -n kubeflow patch --type=json gateway kubeflow-gateway -p '[{"op":"replace","path":"/spec/selector/istio","value":"ingressgateway-kubeflow"}]'
kubectl apply -f patches/kubeflow.yml
kubectl annotate mutatingwebhookconfigurations.admissionregistration.k8s.io admission-webhook-mutating-webhook-configuration certmanager.k8s.io/inject-ca-from=kubeflow/admission-webhook-cert --overwrite
```
