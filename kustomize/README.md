## Manifests Structure

This manifests folder exactly matches the upstream Kubeflow Manifests repository in its naming and folder hierarchy.

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
## Installs Kubeflow on top of Statistics Canada's Cloud Native Platform (CNP)
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

[kubeflow-manifests]: https://github.com/kubeflow/manifests
