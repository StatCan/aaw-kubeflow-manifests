# Kubeflow Manifests

The installation manifests for Kubeflow.

 - [Kubeflow Upgrade Planning][upgrade-planning]

## AAW

Preview the rendered manifests:

```sh
# kubectl kustomize stacks/aaw
task stack:aaw:preview
```

Deploy Kubeflow on top of Cloud Native Platform:

```sh
# kubectl apply --kustomize stacks/aaw
task stack:aaw
```

## Prerequisties

- **[K3D][k3d-install]** (local tesing)
- **[Taskfile][taskfile-install]**

## Documentation

- Information on the **[Manifests Structure][doc-manifests-structure]**

<!-- Links Referenced -->

[doc-manifests-structure]: kustomize/README.md
[k3d-install]:             https://k3d.io/v5.2.2/#installation
[taskfile-install]:        https://taskfile.dev/#/installation
[upgrade-planning]:        https://github.com/StatCan/aaw-kubeflow-manifests/issues/110
