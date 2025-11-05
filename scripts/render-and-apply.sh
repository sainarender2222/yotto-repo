#!/usr/bin/env bash
# Usage: ./render-and-apply.sh <user> <domain> <image>
set -euo pipefail
USER=${1:?user required}
DOMAIN=${2:?domain required}
IMAGE=${3:?image required}
NS=${USER}-ns
APP=${USER}-app
mkdir -p /tmp/multi-tenant
# render deployment + service
sed -e "s|{{NAMESPACE}}|${NS}|g" -e "s|{{APP_NAME}}|${APP}|g" -e "s|{{IMAGE}}|${IMAGE}|g" -e "s|{{TENANT}}|${USER}|g" k8s/templates/deployment.yaml > /tmp/multi-tenant/${USER}-deploy.yaml
kubectl apply -f /tmp/multi-tenant/${USER}-deploy.yaml
# resource quota, pdb, hpa, networkpolicy
sed -e "s|{{NAMESPACE}}|${NS}|g" k8s/templates/resourcequota.yaml | kubectl apply -f -
sed -e "s|{{NAMESPACE}}|${NS}|g" -e "s|{{APP_NAME}}|${APP}|g" k8s/templates/pdb.yaml | kubectl apply -f -
sed -e "s|{{NAMESPACE}}|${NS}|g" -e "s|{{APP_NAME}}|${APP}|g" k8s/templates/hpa.yaml | kubectl apply -f -
sed -e "s|{{NAMESPACE}}|${NS}|g" -e "s|{{APP_NAME}}|${APP}|g" k8s/templates/networkpolicy.yaml | kubectl apply -f -
# create ingress (uses external-dns annotation and cert-manager cluster issuer name)
sed -e "s|{{NAMESPACE}}|${NS}|g" -e "s|{{APP_NAME}}|${APP}|g" -e "s|{{DOMAIN}}|${DOMAIN}|g" -e "s|{{CLUSTER_ISSUER}}|letsencrypt-azure-dns|g" k8s/templates/ingress.yaml > /tmp/multi-tenant/${USER}-ing.yaml
kubectl apply -f /tmp/multi-tenant/${USER}-ing.yaml
echo "Applied resources for ${USER} (namespace: ${NS})"
