# Connect to postgres

Example in which we create postgres k8s resources (secret, svc, sts), test connection from a job/pod and run a workflow that connects to the postgres database.

## Requirements

[Base requirements](../../README.md#requirements-for-local-setup) + additional:

- [openssl](https://www.openssl.org/) - for generating passwords with `openssl rand`
