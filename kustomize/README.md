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
| `argo`     | Provides ArgoCD Application Metadata on top of the `aaw` stack                                 |
| `local`    | Necessary adjustments for running the `aaw` stack on a local, dev, and CI environment          |
| `upstream` | Installs Kubeflow upstream along with the AAW kustomizations without the Cloud Native Platform |

<!-- Links Referenced -->

[kubeflow-manifests]: https://github.com/kubeflow/manifests
