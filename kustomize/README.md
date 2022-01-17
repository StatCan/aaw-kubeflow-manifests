## Manifests Structure

This manifests folder exactly matches the upstream Kubeflow Manifests repository in its naming and folder hierarchy.

- **[Kubeflow Manifests][kubeflow-manifests]**

While the upstream location is organized under three (3) main directories we have added an additional one for `stacks`.

| Directory | Purpose                                                                                               |
| --------- | ----------------------------------------------------------------------------------------------------- |
| `apps`    | Kubeflow's official components, as maintained by the respective Kubeflow WGs                          |
| `common`  | Common services, as maintained by the Manifests WG                                                    |
| `contrib` | 3rd party contributed applications, which are maintained externally and are not part of a Kubeflow WG |

## Application Sets

All the applications can be deployed at once using an `ApplicationSet`. See `examples/` for versions. The following deploys all apps, but lets you configure the version and overlay of each app.

```yaml
apiVersion: argoproj.io/v1alpha1
kind: ApplicationSet
metadata:
  name: kubeflow
  namespace: argocd
spec:
  generators:
  - list:
      elements:
      - app: katib
        folder: apps
        overlay: aaw
        version: main

      - app: kfserving
        folder: apps
        overlay: aaw
        version: main
      # truncated...
  template:
    metadata:
      name: 'kubeflow-{{app}}'
      namespace: argocd
    spec:
      project: default
      source:
        repoURL: https://github.com/statcan/aaw-kubeflow-manifests.git
        targetRevision: {{version}}
        path: kustomize/{{folder}}/{{app}}/overlays/{{overlay}}
      destination:
        server: https://kubernetes.default.svc
      syncPolicy:
        automated:
          prune: true
          selfHeal: true
```

## Overlays

Different type of configurations for Kubeflow and its dependencies.

| Overlay    | Purpose                                                                       |
| ---------- | ----------------------------------------------------------------------------- |
| `upstream` | Installs a generalized Kubeflow useful for testing and accessing new features |
| `aaw`      | Installs Kubeflow on top of Statistics Canada Cloud Native Platform           |
| `local-dev`| Builds on `aaw` but allows patching suitable for local development            |

<!-- Links Referenced -->

[kubeflow-manifests]: https://github.com/kubeflow/manifests
