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

# source:
# https://github.com/argoproj/argo-helm/tree/main/charts/argo-workflows

# server.extraArgs={--auth-mode=server} - we can use the UI without having to log in
# controller.metricsConfig.enabled=true - enable prometheus metrics server
# controller.telemetryConfig.enabled=true - enable prometheus telemetry server

helm upgrade --install argo-workflows argo/argo-workflows --version "$LATEST_HELM_TAG" --set "server.extraArgs={--auth-mode=server}" --set "controller.telemetryConfig.enabled=true" --set "controller.metricsConfig.enabled=true" > /dev/null

# helm upgrade --install argo-workflows argo/argo-workflows --version "$LATEST_HELM_TAG" --values awf-values.yml

kubectl apply -f workflows/rbac.yaml > /dev/null

argo submit --watch workflows/examples/hello-world/workflow.yaml

echo ""
echo "You're all set! Check out the Argo UI at http://localhost:2746/workflows with:"
echo ""
echo "kubectl port-forward svc/argo-workflows-server 2746:2746"
echo ""

jq ".argo.\"argo-workflows\" = \"$LATEST_HELM_TAG\"" working_versions.json > working_versions.json.tmp && mv working_versions.json.tmp working_versions.json
