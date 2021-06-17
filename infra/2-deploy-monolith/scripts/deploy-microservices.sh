#!/bin/bash
export PROJECT_ID=${1}
export ZONE=${2}
export CLUSTER_LABEL=${3}
cd bank-of-anthos
ls -al
instance=$(gcloud container clusters list --filter="resourceLabels.workload ~ ${CLUSTER_LABEL}" --format="value[separator=','](name,location)")
echo "Configuring the REGIONAL cluster: ${instance}"
name="${instance%,*}";
location="${instance#*,}";
# Assuming this is a regional cluster
gcloud container clusters get-credentials --region=${location} ${name}
sed "s/\[[PROJECT_ID]\]/${PROJECT_ID}/g" src/ledgermonolith/config.yaml > config.yaml
kubectl apply -f config.yaml
kubectl apply -f extras/jwt/jwt-secret.yaml
kubectl apply -f kubernetes-manifests/accounts-db.yaml
kubectl apply -f kubernetes-manifests/userservice.yaml
kubectl apply -f kubernetes-manifests/contacts.yaml
kubectl apply -f kubernetes-manifests/frontend.yaml
kubectl apply -f kubernetes-manifests/loadgenerator.yaml
