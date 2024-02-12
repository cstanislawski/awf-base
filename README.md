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
- [jq](https://stedolan.github.io/jq/download/)

## Compatibility

[working_versions.json](./working_versions.json) contain the versions of helm charts used and confirmed to be correctly with what's defined in the repository.

## Examples

You can find various examples in [./workflows/examples](./workflows/examples/).

To run them, simply run the main [startup script](./start.sh):

```bash
bash start.sh
```

and then all the examples should be runnable from the root directory, e.g.:

```bash
bash workflows/examples/connect-to-postgres/start.sh
```

## TODO

### Workflows

1. Heavy concurrent database operations on different unique tables.
2. 1000 concurrent lightweight operations.
3. 1000 concurrent heavy operations.
4. Sourcing workflows / workflow templates from a git repository.
5. Multiple workflows depending on each other (A -> B -> C,  A -> D -> C etc).
6. Worklows integration with Vault with some tasks
7. Large scale integration with Vault

### Monitoring

1. Prometheus auto-discovery.
2. Grafana dashboards for core (awf controller, server) & workflows.

### Networking

1. Ingress setup for local development.

### Other services

1. Argo Events
