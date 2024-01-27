#!/bin/bash

LATEST_TAG=$(curl --silent https://api.github.com/repos/argoproj/argo-workflows/releases/latest | jq '.tag_name' | sed -e 's/^"//' -e 's/"$//')
DEPLOYMENT_TIMEOUT=45

if [[ ! $LATEST_TAG =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Error: LATEST_TAG is not in the expected format"
  echo "LATEST_TAG: $LATEST_TAG"
  echo "Expected: v\d+.\d+.\d+"
  exit 1
fi

echo "Will use latest tag: $LATEST_TAG"

k3d cluster create argo

kubectl create namespace argo

kubectl apply -n argo -f "https://github.com/argoproj/argo-workflows/releases/download/$LATEST_TAG/quick-start-minimal.yaml"

kubectl patch deployment \
  argo-server \
  --namespace argo \
  --type='json' \
  -p='[{"op": "replace", "path": "/spec/template/spec/containers/0/args", "value": [
  "server",
  "--auth-mode=server"
]}]'

# kubectl apply -f ui-role-list.yaml

counter=1

while [[ $(kubectl get deployment -n argo argo-server -o jsonpath="{.status.readyReplicas}") != 1 ]]; do
  echo "$counter: waiting for deployment..."
  sleep 1
  counter=$((counter + 1))
  if [[ $counter -gt $DEPLOYMENT_TIMEOUT ]]; then
    echo ""
    echo "##############################"
    echo "Didn't start in time. Exiting."
    echo "##############################"
    echo ""
    bash local_stop.sh
    break
  fi
done

kubectl -n argo port-forward deployment/argo-server 2746:2746
