#!/bin/bash

# check if `helm repo list` contains argo, if not, add it
if ! helm repo list | grep -q argo; then
  helm repo add argo https://argoproj.github.io/argo-helm
fi

helm repo update argo > /dev/null

# extract latest version of argo-workflows
LATEST_HELM_TAG=$(helm search repo argo/argo-workflows | grep argo/argo-workflows | awk '{print $2}')
LATEST_APP_TAG=$(helm search repo argo/argo-workflows | grep argo/argo-workflows | awk '{print $3}')

echo "Will use helm chart version: $LATEST_HELM_TAG"
echo "Will use argo-workflows version: $LATEST_APP_TAG"

k3d cluster create argo

export LATEST_HELM_TAG=$LATEST_HELM_TAG

# helm install argo-workflows argo/argo-workflows --namespace argo --create-namespace --version "$LATEST_HELM_TAG" --values values.yaml

helm install argo-workflows argo/argo-workflows --version "$LATEST_HELM_TAG" --values values.yaml
