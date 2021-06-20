#!/bin/bash
export PROJECT_ID=${1}
export CLUSTER_LABEL=${2}
cd bank-of-anthos
instance=$(gcloud container clusters list --filter="resourceLabels.workload ~ ${CLUSTER_LABEL}" --format="value[separator=','](name,location)")
echo "Cleaning up the deployment from the REGIONAL cluster: ${instance}"
name="${instance%,*}";
location="${instance#*,}";
# Assuming this is a regional cluster
gcloud container clusters get-credentials --region=${location} ${name}
export MONOLITH_VM_NAME=$(gcloud compute instances list --filter="name ~ ledger-monolith" --format="value(name)")
sed "s/\[PROJECT_ID\]/${PROJECT_ID}/g" src/ledgermonolith/config.yaml > _config.yaml
sed "s/ledgermonolith-service/${MONOLITH_VM_NAME}/g" _config.yaml > config.yaml
kubectl delete -f config.yaml
kubectl delete -f extras/jwt/jwt-secret.yaml
kubectl delete -f kubernetes-manifests/accounts-db.yaml
kubectl delete -f kubernetes-manifests/userservice.yaml
kubectl delete -f kubernetes-manifests/contacts.yaml
kubectl delete -f kubernetes-manifests/frontend.yaml
kubectl delete -f kubernetes-manifests/loadgenerator.yaml
