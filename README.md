## Kubeflow Manifests for AAW

The Kubeflow installation manifests for Advanced Analytics Workspaces (AAW).

 - **[Kubeflow Upgrade Planning][upgrade-planning]**

## Prerequisites

- **[K3D][k3d-install]** (local testing)
- **[kubectl][kubectl-install]**
- **[Taskfile][taskfile-install]**

## Commands

Generate and save the rendered manifests to a local directory for debugging:

```sh
# kubectl kustomize stacks/aaw
task stack:aaw:preview
```

Deploy Kubeflow on top of Statistics Canada's Cloud Native Platform (CNP):

```sh
# kubectl apply --kustomize stacks/aaw
task stack:aaw
```

## Documentation

This kustomize folder exactly matches the upstream Kubeflow Manifests repository in its naming and folder hierarchy.

- **[Kubeflow Manifests][kubeflow-manifests]**

While the upstream location is organized under three (3) main directories we have added an additional one for `stacks`.

| Directory | Purpose                                                                                               |
| --------- | ----------------------------------------------------------------------------------------------------- |
| `apps`    | Kubeflow's official components, as maintained by the respective Kubeflow WGs                          |
| `common`  | Common services, as maintained by the Manifests WG                                                    |
| `contrib` | 3rd party contributed applications, which are maintained externally and are not part of a Kubeflow WG |
| `stacks`  | Different type of configurations for Kubeflow and its dependencies (`aaw`, `argo`, `upstream`)        |

## Stacks

Different type of configurations for Kubeflow and its dependencies.

| Directory  | Purpose                                                                                        |
| ---------- | ---------------------------------------------------------------------------------------------- |
| `aaw`      | Installs Kubeflow on top of Statistics Canada's Cloud Native Platform (CNP)                    |
| `argo`     | Provides ArgoCD Application Metadata for the `aaw` stack                                       |
| `local`    | Necessary adjustments for running the `aaw` stack on a local, dev, and CI environment          |
| `upstream` | Installs Kubeflow upstream along with the AAW kustomizations without the Cloud Native Platform |

### AAW

The `aaw` stack expects to be installed on top of the Cloud Native Platform which already provides some of the base dependencies as illustrated below:

```sh
## Statistics Canada's Cloud Native Platform (CNP)
##
## └─── https://github.com/statcan/terraform-statcan-aaw-platform
##      ├─── https://github.com/statcan/terraform-statcan-azure-cloud-native-platform-infrastructure
##      │    ├─── aad_pod_identity
##      │    ├─── cert_manager
##      │    ├─── vault
##      │    └─── velero
##      ├─── https://github.com/statcan/terraform-statcan-kubernetes-core-platform
##      │    ├─── aad_pod_identity
##      │    ├─── cert_manager
##      │    ├─── fluentd
##      │    ├─── gatekeeper
##      │    ├─── kubecost
##      │    ├─── prometheus
##      │    ├─── vault_agent
##      │    └─── velero
##      └─── https://github.com/statcan/terraform-statcan-kubernetes-app-platform
##           ├─── istio operator
##           └─── istio gateway handling
```

<!-- Links Referenced -->

[k3d-install]:             https://k3d.io/v5.2.2/#installation
[kubeflow-manifests]:      https://github.com/kubeflow/manifests
[kubectl-install]:         https://kubernetes.io/docs/tasks/tools/#kubectl
[taskfile-install]:        https://taskfile.dev/#/installation
[upgrade-planning]:        https://github.com/StatCan/aaw-kubeflow-manifests/issues/110
