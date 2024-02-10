# Argo Workflows on Kubernetes - Quick Start

Base repository for a quick setup of Argo Workflows on Kubernetes.

## Argo Workflows minimal requirements

For argo-server to be able to schedule pods on the Kubernetes cluster, it needs to have a service account with the necessary permissions. Minimal permissions needed are defined in [workflows/rbac.yaml](workflows/rbac.yaml).

To test whether the service account has the necessary permissions, you can submit a test workflow:

```bash
argo submit --watch workflows/examples/hello-world.yaml
```

## Requirements for local setup

- [docker](https://docs.docker.com/get-docker/)
- [k3d](https://k3d.io/#installation)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [helm](https://helm.sh/docs/intro/install/)
- [argo cli](https://argo-workflows.readthedocs.io/en/latest/walk-through/argo-cli/)
