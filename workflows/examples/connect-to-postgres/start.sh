#!/bin/bash

set -e

echo "Creating postgres-credentials secret"
kubectl create secret generic postgres-credentials --from-literal=POSTGRES_USER="$(openssl rand -base64 12)" --from-literal=POSTGRES_PASSWORD="$(openssl rand -base64 12)" --from-literal=POSTGRES_DB=argo

echo "Creating postgres resources"
kubectl apply -f workflows/examples/connect-to-postgres/pg-svc-sts.yaml

# wait for postgres to be ready
kubectl wait --for=condition=ready --timeout=120s pod -l app=postgresql

echo "Creating job testing connection to postgres"
kubectl apply -f workflows/examples/connect-to-postgres/job.yaml

kubectl wait --for=condition=complete --timeout=120s job/pg-connect

echo "Creating workflow to connect to postgres"
argo submit --watch workflows/examples/connect-to-postgres/workflow.yaml
