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

| Directory  | Purpose                                                                       |
| ---------- | ----------------------------------------------------------------------------- |
| `aaw`      | Installs Kubeflow on top of Statistics Canada Cloud Native Platform           |
| `argo`     | Provides ArgoCD Project Metadata to facilitate a GitOps deployment model      |
| `upstream` | Installs a generalized Kubeflow useful for testing and accessing new features |

<!-- Links Referenced -->

[kubeflow-manifests]: https://github.com/kubeflow/manifests
