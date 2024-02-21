#!/bin/bash

set -e

echo "Deleting postgres resources"
kubectl delete -f workflows/examples/connect-to-postgres/pg-svc-sts.yaml

echo "Deleting postgres-credentials secret"
kubectl delete secret postgres-credentials

echo "Deleting job testing connection to postgres"
kubectl delete -f workflows/examples/connect-to-postgres/job.yaml
