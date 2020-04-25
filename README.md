# Kubeflow Manifests

The installation manifest for Kubeflow.

## kfctl

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

In `kustomize/api-service/base.yaml`

```yaml
images:
- name: gcr.io/ml-pipeline/api-server
  newTag: 0.2.5
  newName: gcr.io/ml-pipeline/api-server
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
    value: <acr-registry>.azurecr.io/minimal-notebook-cpu:<git-sha>
    # The list of available standard container Images
    options:
      - <acr-registry>.azurecr.io/base-notebook-cpu:<git-sha>
      - <acr-registry>.azurecr.io/base-notebook-gpu:<git-sha>
      - <acr-registry>.azurecr.io/minimal-notebook-cpu:<git-sha>
      - <acr-registry>.azurecr.io/minimal-notebook-gpu:<git-sha>
      - <acr-registry>.azurecr.io/geomatics-notebook-cpu:<git-sha>
      - <acr-registry>.azurecr.io/machine-learning-notebook-cpu:<git-sha>
      - <acr-registry>.azurecr.io/machine-learning-gpu:<git-sha>
    # By default, custom container Images are allowed
    # Uncomment the following line to only enable standard container Images
    readOnly: false
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

Until cert-manager is upgraded, make the following changes:

  - Find and replace `cert-manager.io/v1alpha2` with `certmanager.k8s.io/v1alpha1`
  - Find and replace `cert-manager.io/inject-ca-from` with `certmanager.k8s.io/inject-ca-from`

In `kustomize/webhook/overlays/cert-manager/kustomizations.yaml`,

```yaml
- name: cert_name
  objref:
      kind: Certificate
      group: certmanager.k8s.io
      version: v1alpha1
      name: admission-webhook-cert
```

In `kustomize/webhook/kustomization.yaml`:

```yaml
- fieldref:
    fieldPath: metadata.name
  name: cert_name
  objref:
    group: certmanager.k8s.io
    kind: Certificate
    name: admission-webhook-cert
    version: v1alpha1
```


In `kustomize/argo/base/configmap.yaml`

```yaml
kind: ConfigMap
metadata:
  name: workflow-controller-configmap
  namespace: kubeflow
data:
  config: |
    {
    executorImage: $(executorImage),
    containerRuntimeExecutor: $(containerRuntimeExecutor),
    archive: true
    artifactRepository:
```

In `kustomize/pipelines-ui/base/deployment.yaml`

```yaml
    spec:
      containers:
      - name: ml-pipeline-ui
        image: gcr.io/ml-pipeline/frontend
        imagePullPolicy: IfNotPresent
        env:
        - name: ARGO_ARCHIVE_LOGS
          value: "true"
        - name: ARGO_ARCHIVE_ARTIFACTORY
          value: minio
        - name: ARGO_ARCHIVE_BUCKETNAME
          value: mlpipeline
        - name: ARGO_ARCHIVE_PREFIX
          value: logs
```

4. Run the following commands to deploy and configure Kubeflow.

```sh
kfctl apply -f kfctl_k8s_istio.v1.0.1.yaml
kubectl -n kubeflow patch --type=json gateway kubeflow-gateway -p '[{"op":"replace","path":"/spec/selector/istio","value":"ingressgateway-kubeflow"}]'
kubectl apply -f patches/kubeflow.yml
kubectl annotate mutatingwebhookconfigurations.admissionregistration.k8s.io admission-webhook-mutating-webhook-configuration certmanager.k8s.io/inject-ca-from=kubeflow/admission-webhook-cert --overwrite
```

## Argo

When working with Pipelines and Kubeflow you should have the `argo` client.

```sh
kubectl get workflow -o name | grep ${prefix} | cut -d'/' -f2 | xargs argo -n kubeflow delete

argo delete -n kubeflow --older 1d
```
