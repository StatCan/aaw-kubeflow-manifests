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
kfctl build -V -f kfctl_azure.yaml -d > output.yaml
```

## Argo

When working with Pipelines and Kubeflow you should have the `argo` client.

```sh
kubectl get workflow -o name | grep ${prefix} | cut -d'/' -f2 | xargs argo -n kubeflow delete
argo delete -n kubeflow --older 1d
```
